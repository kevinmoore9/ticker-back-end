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
  validates :user_id, :total, :equity, :cash, presence: true
  belongs_to :user
end
