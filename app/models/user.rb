# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#


class User < ActiveRecord::Base

  attr_reader :password

  validates :email, :password_digest, :session_token, presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: :true

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  after_initialize :ensure_session_token
  before_validation :ensure_session_token_uniqueness

  has_many :balances
  has_many :trades

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def stocks #returns a hash where keys are ticker symbols and vals are numbers of shares
    buyHash = {}
    sellHash = {}

    Trade.where(user_id: self.id).each do |tr|
      if tr.trade_type == 'BUY'
        if buyHash[tr.stock_id]
          buyHash[tr.stock_id] += tr.volume
        else
          buyHash[tr.stock_id] = tr.volume
        end
      elsif tr.trade_type == 'SELL'
        if sellHash[tr.stock_id]
          sellHash[tr.stock_id] += tr.volume
        else
          sellHash[tr.stock_id] = tr.volume
        end
      end
    end

    holdings = {}
    buyHash.keys.each do |sym|
      sold = sellHash[sym] ? sellHash[sym] : 0
      if buyHash[sym] - sold > 0
        holdings[sym] = buyHash[sym] - sold
      end
    end
    holdings
  end

  def buy_stock(ticker_sym, quantity)
    if Stock.ensure_stock(ticker_sym)
      stock = Stock.find_by(symbol: ticker_sym)
      cost = stock.price * quantity
      old_balance = self.balances.most_recent
      cash = old_balance.cash
      raise "insufficient cash for this trade" if cash < cost
      purchase = Trade.new(trade_type: 'BUY',
                           user_id: self.id,
                           volume: quantity,
                           stock_id: stock.id,
                           value: cost)
      new_balance = Balance.new(user_id: self.id,
                                cash: cash - cost,
                                equity: old_balance.equity + cost)
      ActiveRecord::Base.transaction do
        purchase.save!
        new_balance.save!
      end
      true
    else #stock not found
      false
    end
  end

  def sell_stock(ticker_sym, quantity)
    stock = Stock.find_by(symbol: ticker_sym)
    my_stocks = self.stocks
    raise "You don't own this stock" unless my_stocks.include?(stock.id)
    raise "You don't own that many shares" unless my_stocks[stock.id] >= quantity
    income = quantity * stock.price
    old_balance = self.balances.most_recent
    sale = Trade.new(trade_type: 'SELL',
                     user_id: self.id,
                     volume: quantity,
                     stock_id: stock.id,
                     value: income)
    new_balance = Balance.new(user_id: self.id,
                              cash: old_balance.cash + income,
                              equity: old_balance.equity - income)
    ActiveRecord::Base.transaction do
      sale.save!
      new_balance.save!
    end
    true
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    return nil unless user
    user.password_is?(password) ? user : nil
  end

  def password_is?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = new_session_token
    ensure_session_token_uniqueness
    self.save
    self.session_token
  end

  private

  def ensure_session_token
    self.session_token ||= new_session_token
  end

  def new_session_token
    SecureRandom.base64
  end

  def ensure_session_token_uniqueness
    while User.find_by(session_token: self.session_token)
      self.session_token = new_session_token
    end
  end
end
