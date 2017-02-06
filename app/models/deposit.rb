class Deposit < ActiveRecord::Base
  validates :user_id, :amount, presence: true, numericality: true

  belongs_to :user
end
