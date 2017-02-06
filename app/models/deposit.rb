# == Schema Information
#
# Table name: deposits
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  amount     :float            not null
#  created_at :datetime
#  updated_at :datetime
#

class Deposit < ActiveRecord::Base
  validates :user_id, :amount, presence: true, numericality: true

  belongs_to :user
end
