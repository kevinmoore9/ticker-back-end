# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.new(email: "aa@aa.com", password: "password")
u.save

Balance.create(user_id: u.id, equity: 0, cash: 50000)

u2 = User.new(email: "test@testing.com", password: "111111")
u2.save

Balance.create(user_id: u2.id, equity: 0, cash: 20000)

u.buy_stock("AAPL", 100)
u.buy_stock("TSLA", 10)
u.buy_stock("GOOG", 10)
u.buy_stock("FB", 50)

u2.buy_stock("BUD", 100)
u2.buy_stock("DEO", 50)
