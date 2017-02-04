class ChangeTypeToTradeType < ActiveRecord::Migration
  def change
    rename_column :trades, :type, :trade_type
  end
end
