class AddThreadSliceIdToCaddieCrestPriceHistoryUpdates < ActiveRecord::Migration
  def change
    add_column :caddie_crest_price_history_updates, :thread_slice_id, :integer, index: true
  end
end
