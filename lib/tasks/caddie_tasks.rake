namespace :caddie do

  desc "Feed the price histories table"
  task :feed_price_histories => :environment do

    puts 'About to compute crest_price_history_updates'
    Caddie::CrestPriceHistoryUpdate.update

    puts 'About to feed crest_price_histories'
    total_inserts, total_connections, total_time = Caddie::CrestPriceHistoryUpdate.feed_price_histories
    puts "#{total_inserts} insertions, #{total_connections} connections in #{total_time.round( 2 )} seconds. #{(total_connections/total_time).round( 2 )} co/sec"

  end

end

