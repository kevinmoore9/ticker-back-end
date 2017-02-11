# Ticker-back-end

## Rails backend for the mobile app [Ticker-Tycoon](https://github.com/kevinmoore9/ticker-tycoon)

## [Demo Page](https://kevinmoore9.github.io/ticker-tycoon/)

## Technical Overview

This repo is the backend for a mobile app written in React-Native. For this
reason, no HTML views are currently included.

### Schema

All data tables include fields for a unique ID and created_at and updated_at timestamps plus the following columns

`users`:
  - `id`
  - `email`
  - `password_digest`
  - `session_token`

`deposits`:
  - `user_id`
  - `amount`

`balances`:
  - `user_id`
  - `equity`
  - `cash`

`balances`:
  - `symbol`
  - `price`
  - `company_name`

`balances`:
  - `user_id`
  - `stock_id`
  - `volume`
  - `trade_type`
  - `value`

### Design

Most of the functionality is implemented in the User model. The user is
the primary object of interest.

Relations have been set to connect the other tables to users. For example,
given a user object called 'u', u.stocks will return a hash whose keys
are the stocks symbols for all stocks that user currently owns. u.buy_stock(symbol, quantity) would call a method on User that would verify that the user has enough cash to make the purchase, and then generate a trade,
and attempt to commit it.

Only two other models contain their own methods. The Balance model has an
'update_all' method, and the Stock model has both 'update_quotes' and 'ensure_stock'. The latter of these will add a record to the stocks table
if it doesn't already exist. This is required in the User#buy_stock method
to ensure that the stock exists and can be included in the generated trade.

### API Endpoints

Although various request types are handled, they all return the entire
User object via a user show partial

path | request method | controller action | what it does
-----|----------------|-------------------|-----
api/users| POST | UsersController#create | create new record in users table
api/users/:id| GET | UsersController#show | returns user object to front-end
api/users/:id/deposits | POST | DepositsController# | creates a deposit record associated with that user
api/session | POST | SessionsController#create | log user in
api/session | DELETE | SessionsController#destroy | log user out (rarely used)
api/trades | POST | TradesController#create | buys or sells stock by adding record to trades table

## Gems

This application uses a variety of standard gems which can be viewed in
the Gemfile. There are two less standard gems that provide functionality specific to this application: 'stock_quote' and 'Jbuilder'.

### stock_quote

The stock quote [gem](https://github.com/tyrauber/stock_quote) is very
useful for grabbing data from the Yahoo finance API. It formats and sends
requests to the API, and parses the returned jsonp object into an accessible
Ruby object.

### Jbuilder

This [gem](https://github.com/rails/jbuilder) allows familiar Ruby syntax to be used to generate JSON for API views.

## Planned Improvements

This backend works fine. However, it was developed in a very short time-frame
and leaves room for Improvements...

### Reduce Queries

The User#stocks method could probably be handled more efficiently with a
custom SQL query. Until there is a significant number of users, however,
this should not be too much of a problem.

### Suggestions?

If you have any suggestions for improvements feel free to contact the developers through the above linked demo page, or just go ahead and clone, hack, and submit a pull request.
