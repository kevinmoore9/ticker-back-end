# == Schema Information
#
# Table name: stocks
#
#  id         :integer          not null, primary key
#  symbol     :string           not null
#  price      :float            not null
#  created_at :datetime
#  updated_at :datetime
#

class Stock < ActiveRecord::Base
  validates :symbol, :price, presence: true
  has_many :trades
end
