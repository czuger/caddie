namespace :caddie do

  desc "Feed the price histories table"
  task :feed_crest_price_histories => :environment do

    start_time = Time.now
    feed_date = start_time.to_date

    unless ENV[ 'EBS_NO_HIST_UPDATE' ] && ENV[ 'EBS_NO_HIST_UPDATE' ].downcase == 'true'
      puts 'About to compute crest_price_history_updates'
      Caddie::CrestPriceHistoryUpdate.update
    end

    end_update_time = Time.now
    update_planning_time = end_update_time - start_time

    puts 'About to feed crest_price_histories'
    total_inserts, total_connections, total_time = Caddie::CrestPriceHistoryUpdate.feed_price_histories
    # th = Caddie::MThreadedUpdater.new( Caddie::CrestPriceHistoryUpdate::NB_THREADS, Caddie::CrestPriceHistoryUpdate.daily_operations_list )
    # total_inserts, total_connections, total_time = th.feed_price_histories_threaded
    puts "#{total_inserts} insertions, #{total_connections} connections in #{total_time.round( 2 )} seconds. #{(total_connections/total_time).round( 2 )} co/sec"

    end_feeding_time = Time.now
    feeding_time = end_feeding_time - end_update_time

    Caddie::CrestPriceHistoryUpdateLog.store_log_data( feed_date, update_planning_time, feeding_time, total_inserts, total_connections, total_time )

  end
end