require 'set'
require 'open-uri'

module Caddie

  class CrestPriceHistoryUpdate < ActiveRecord::Base
    belongs_to :eve_item
    belongs_to :region

    extend Caddie::CrestDataRetriever

    NB_THREADS=4

    def self.update
      current_path = File.dirname( __FILE__ )
      request = File.open( "#{current_path}/update_table.sql" ).read
      ActiveRecord::Base.connection.execute( request )
    end

    def self.feed_price_histories( updates_ids: nil, thread_log_file: nil )
      total_connections_counts = 0
      total_inserts = 0
      date_deb = Time.now

      debug = ENV[ 'EBS_DEBUG_MODE' ] && ENV[ 'EBS_DEBUG_MODE' ].downcase == 'true' && Rails.env != 'test'
      output = thread_log_file ? thread_log_file : STDOUT
      outerr = thread_log_file ? thread_log_file : STDERR

      if updates_ids
        dol = self.where( id: updates_ids ).order( :process_queue_priority ) if updates_ids
      else
        dol = daily_operations_list
      end

      output.puts "dol.count = #{dol.count}" if debug

      global_errors_count = 0
      dol.joins( :eve_item, :region ).pluck( :eve_item_id, :region_id, :cpp_eve_item_id, :cpp_region_id, :id ).each do |row|

        eve_item_id, region_id, cpp_eve_item_id, cpp_region_id = row
        if debug
          output.puts
          output.puts '*'*50
          output.puts 'Requesting:'
          output.puts "r = Region.find_by_cpp_region_id( #{cpp_region_id} )"
          output.puts "i = EveItem.find_by_cpp_eve_item_id( #{cpp_eve_item_id} )"
        end

        items = []
        connections_count = 0
        http_errors = 0
        # We retry 2 times
        begin
          begin
            items, connections_count = get_markets( cpp_region_id, cpp_eve_item_id, thread_log_file: thread_log_file )
          rescue OpenURI::HTTPError, Errno::ECONNRESET => e
            http_errors += 1
            global_errors_count += 1
            outerr.puts "#{e.message} for cpp_region_id = #{cpp_region_id} and cpp_eve_item_id = #{cpp_eve_item_id}" unless Rails.env == 'test'
            sleep( 5 ) # in case of an error, we don't retry immediately.
          end
        end while http_errors >= 1 && http_errors < 2

        total_connections_counts += connections_count

        ActiveRecord::Base.transaction do

          last_update_date, last_update_record = Caddie::CrestPriceHistoryLastDayTimestamp.
            find_or_create_last_day_timestamp( region_id, eve_item_id )

          output.puts "Last update record date = #{last_update_date.inspect}" if debug
          
          items.reject!{ |item| DateTime.parse( item['date'] ) <= last_update_date }

          output.puts "Kept items.count = #{items.count}" if debug

          max_date_info = last_update_date
          items.each do |item_data|
            date_info = DateTime.parse( item_data['date'] )
            max_date_info = [ max_date_info, date_info ].max

            CrestPriceHistory.create!( region_id: region_id, eve_item_id: eve_item_id,
              history_date: date_info,  order_count: item_data['orderCount'], volume: item_data['volume'],
              low_price: item_data['lowPrice'], avg_price: item_data['avgPrice'], high_price: item_data['highPrice'] )
              total_inserts += 1
          end

          output.puts "Computed max date info = #{max_date_info}" if debug

          Caddie::CrestPriceHistoryLastDayTimestamp.create_or_update_last_day_timestamp(
            last_update_record, max_date_info, region_id, eve_item_id )
        end
        output.flush

      end
      [ total_inserts, total_connections_counts, Time.now - date_deb, global_errors_count ]
    end

    private

    def self.daily_operations_list
      self.where( next_process_date: Time.now.to_date ).order( :process_queue_priority )
    end

  end

end
