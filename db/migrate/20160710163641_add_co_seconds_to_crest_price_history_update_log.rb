class AddCoSecondsToCrestPriceHistoryUpdateLog < ActiveRecord::Migration[4.2]
  def change
    add_column :caddie_crest_price_history_update_logs, :co_seconds, :float
  end
end
