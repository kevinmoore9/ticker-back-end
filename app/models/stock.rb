# == Schema Information
#
# Table name: stocks
#
#  id           :integer          not null, primary key
#  symbol       :string           not null
#  price        :float            not null
#  created_at   :datetime
#  updated_at   :datetime
#  company_name :string
#

class Stock < ActiveRecord::Base
  validates :symbol, :company_name, :price, presence: true
  has_many :trades

  def self.update_quotes
    stocks = Stock.all
    while stocks
      current_batch = stocks.take(100)
      stocks = stocks[100..-1]
      quotes = StockQuote::Stock.quote(current_batch.map { |s| s.symbol })
      current_batch.each_with_index do |st, i|
        price = quotes[i].bid ? quotes[i].bid : quotes[i].close
        st.update_attributes(price: price)
        st.save
      end
    end
  end

  def self.ensure_stock(ticker_sym)
    if Stock.find_by(symbol: ticker_sym)
      true
    else
      stock = Stock.new(symbol: ticker_sym)
      quote =  StockQuote::Stock.quote(ticker_sym)
      if quote.name
        if quote.bid
          stock.price = quote.bid
        elsif quote.close
          stock.price = quote.close
        else
          stock.price = (quote.days_high + quote.days_low) / 2
        end
        stock.company_name = quote.name
        if stock.save
          true
        else
          false
        end
      else
        false
      end
    end
  end
end
