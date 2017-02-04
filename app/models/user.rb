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

  has_one :balance
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
