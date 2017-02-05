# == Schema Information
#
# Table name: trades
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  stock_id   :integer          not null
#  volume     :integer          not null
#  trade_type :string           not null
#  value      :float            not null
#  created_at :datetime
#  updated_at :datetime
#

class Trade < ActiveRecord::Base
  validates :user_id, :stock_id, :volume, :trade_type, :value, presence: true
  validates :volume, numericality: true

  belongs_to :user
  belongs_to :stock

  scope :most_recent, -> { order(:created_at).last }
end
