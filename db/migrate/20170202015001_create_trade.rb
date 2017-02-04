class CreateTrade < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.integer :user_id, null: false, foreign_key: true
      t.integer :stock_id, null: false, foreign_key: true
      t.integer :volume, null: false
      t.string :type, null: false
      t.float :value, null: false

      t.timestamps
    end
    add_index :trades, :user_id
  end
end
