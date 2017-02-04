class CreateStock < ActiveRecord::Migration
    def change
        create_table :stocks do |t|
            t.string :symbol, null: false
            t.float :price, null: false

            t.timestamps
        end
        add_index :stocks, :symbol
    end
end
