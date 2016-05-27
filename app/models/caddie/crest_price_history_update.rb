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

        eve_item_id, region_id, cpp_eve_item_id, cpp_region_id = row
        # puts "Requesting : #{cpp_region_id}, #{cpp_eve_item_id}"
        items, connections_count = get_markets( cpp_region_id, cpp_eve_item_id )
        total_connections_counts += connections_count

        ActiveRecord::Base.transaction do
          items.each do |item_data|

            date_info = DateTime.parse( item_data['date'] )
            date_info_ts = date_info.strftime( '%Y%m%d' )

            CrestPriceHistory.where( region_id: region_id, eve_item_id: eve_item_id, day_timestamp: date_info_ts ).first_or_create! do |h|
              h.history_date = date_info
              h.order_count = item_data['orderCount']
              h.volume = item_data['volume']
              h.low_price = item_data['lowPrice']
              h.avg_price = item_data['avgPrice']
              h.high_price = item_data['highPrice']
              total_inserts += 1
            end
          end
        end
      end
      [ total_inserts, total_connections_counts, Time.now - date_deb ]
    end

    private

    def self.daily_operations_list
      self.where( next_process_date: Time.now.to_date ).order( :process_queue_priority ).limit( 100 )
    end

  end

end
