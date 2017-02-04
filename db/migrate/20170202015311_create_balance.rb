class CreateBalance < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.integer :user_id, null: false
      t.float :equity, null: false
      t.float :cash, null: false

      t.timestamps
    end
    add_index :balances, :user_id
  end
end
