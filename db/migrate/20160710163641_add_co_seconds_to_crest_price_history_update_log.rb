class AddCoSecondsToCrestPriceHistoryUpdateLog < ActiveRecord::Migration
  def change
    add_column :caddie_crest_price_history_update_logs, :co_seconds, :float
  end
end
