class AddTotalInsertsToCrestPriceHistoryUpdateLog < ActiveRecord::Migration
  def change
    add_column :caddie_crest_price_history_update_logs, :total_inserts, :integer
  end
end