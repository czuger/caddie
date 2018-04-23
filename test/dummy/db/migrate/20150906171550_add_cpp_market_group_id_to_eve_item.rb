class AddCppMarketGroupIdToEveItem < ActiveRecord::Migration[4.2]
  def change
    add_column :eve_items, :cpp_market_group_id, :integer
    add_index :eve_items, :cpp_market_group_id
  end
end
