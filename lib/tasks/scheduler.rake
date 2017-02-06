desc "This task is called by the Heroku scheduler add-on"

task :update_stock_quotes => :environment do
  puts "Updating stock quotes..."
  Stock.update_quotes
  puts "done."
end

task :update_balances => :environment do
  Balance.update_all
end
