json.extract! user, :id, :email, :session_token
json.stocks user.stocks
json.balances user.balances.most_recent
