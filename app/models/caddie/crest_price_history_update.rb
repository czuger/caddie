require 'set'

module Caddie

  class CrestPriceHistoryUpdate < ActiveRecord::Base
    belongs_to :eve_item
    belongs_to :region

    extend Caddie::CrestDataRetriever

    def self.update
      current_path = File.dirname( __FILE__ )
      request = File.open( "#{current_path}/update_table.sql" ).read
      ActiveRecord::Base.connection.execute( request )
    end

    def self.feed_price_histories
      total_connections_counts = 0
      total_inserts = 0
      date_deb = Time.now

      daily_operations_list.joins( :eve_item, :region ).pluck( :eve_item_id, :region_id, :cpp_eve_item_id, :cpp_region_id ).each do |row|

        # puts "Processing row = #{row}"

        eve_item_id, region_id, cpp_eve_item_id, cpp_region_id = row
        # puts "Requesting : #{cpp_region_id}, #{cpp_eve_item_id}"
        items, connections_count = get_markets( cpp_region_id, cpp_eve_item_id )
        total_connections_counts += connections_count

        ActiveRecord::Base.transaction do

          # puts 'About to reject already used lines'
          timestamps = CrestPriceHistory.where( region_id: region_id, eve_item_id: eve_item_id ).pluck( :day_timestamp ).to_set
          items.reject! do |item|
            date_info = DateTime.parse( item['date'] )
            date_info_ts = date_info.strftime( '%Y%m%d' )
            timestamps.include?( date_info_ts )
          end
          # puts 'Lines rejected'


          items.each do |item_data|

            date_info = DateTime.parse( item_data['date'] )
            date_info_ts = date_info.strftime( '%Y%m%d' )

            CrestPriceHistory.create!( region_id: region_id, eve_item_id: eve_item_id, day_timestamp: date_info_ts,
              history_date: date_info,  order_count: item_data['orderCount'], volume: item_data['volume'],
              low_price: item_data['lowPrice'], avg_price: item_data['avgPrice'], high_price: item_data['highPrice'] )
              total_inserts += 1
          end
        end
      end
      [ total_inserts, total_connections_counts, Time.now - date_deb ]
    end

    private

    def self.daily_operations_list
      self.where( next_process_date: Time.now.to_date ).order( :process_queue_priority )
    end

  end

end
