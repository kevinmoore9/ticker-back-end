# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170205021418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "balances", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.float    "equity",     null: false
    t.float    "cash",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "balances", ["user_id"], name: "index_balances_on_user_id", using: :btree

  create_table "stocks", force: :cascade do |t|
    t.string   "symbol",       null: false
    t.float    "price",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
  end

  add_index "stocks", ["symbol"], name: "index_stocks_on_symbol", using: :btree

  create_table "trades", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "stock_id",   null: false
    t.integer  "volume",     null: false
    t.string   "trade_type", null: false
    t.float    "value",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trades", ["user_id"], name: "index_trades_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.string   "session_token",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
