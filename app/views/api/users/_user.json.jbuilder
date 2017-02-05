stock_hash = user.stocks
stocks = {}
stock_hash.each do |stock_id, num_shares|
  stock = Stock.find_by(id: stock_id)
  stocks[stock.symbol] = { num_shares: stock_hash[stock.symbol],
                           price: stock.price }
end

json.extract! user, :id, :email, :session_token, json.stocks
json.portfolio do
  json.cash balance.cash
  json.equity balance.equity
  json.stocks stocks
end
