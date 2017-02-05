# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  equity     :float            not null
#  cash       :float            not null
#  created_at :datetime
#  updated_at :datetime
#

class Balance < ActiveRecord::Base
  validates :user_id, :equity, :cash, presence: true
  belongs_to :user

  scope :most_recent, -> { order(:created_at).last }

  def self.update_all
    users = User.all
    users.each do |user|
      cash = user.balances.most_recent.cash
      equity = 0
      owned_stocks = user.stocks
      owned_stocks.each do |ticker_sym, details|
        equity += details.price * details.num_shares
      end
      new_balance = Balance.new(user_id: user.id,
                                cash: cash,
                                equity: equity)
      new_balance.save
    end
  end
end
