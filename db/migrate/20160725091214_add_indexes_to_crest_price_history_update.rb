class AddIndexesToCrestPriceHistoryUpdate < ActiveRecord::Migration[4.2]
  def change
    add_index :caddie_crest_price_history_updates, :nb_days
    add_index :caddie_crest_price_history_updates, :process_queue
    add_index :caddie_crest_price_history_updates, :next_process_date
    add_index :caddie_crest_price_history_updates, :thread_slice_id
  end
end
