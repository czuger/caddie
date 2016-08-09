module Caddie
  class CrestPriceHistoryLastDayTimestamp < ActiveRecord::Base
    belongs_to :eve_item
    belongs_to :region

    def self.find_or_create_last_day_timestamp( region_id, eve_item_id )

      @debug = ENV[ 'EBS_DEBUG_MODE' ] && ENV[ 'EBS_DEBUG_MODE' ].downcase == 'true' && Rails.env != 'test'

      last_update_record = CrestPriceHistoryLastDayTimestamp.find_by_region_id_and_eve_item_id( region_id, eve_item_id )

      if last_update_record
        last_update_date = last_update_record.day_timestamp
      else
        last_update_date = CrestPriceHistory.where( region_id: region_id, eve_item_id: eve_item_id ).maximum( :history_date )
      end

      last_update_date = Time.new( 0 ) unless last_update_date

      puts "Last update record = #{last_update_date.inspect}" if @debug
      [ last_update_date, last_update_record ]
    end

    def self.create_or_update_last_day_timestamp( last_update_record, max_date_info, region_id, eve_item_id )
      if last_update_record
        last_update_record.update!( day_timestamp: max_date_info )
      else
        last_update_record = CrestPriceHistoryLastDayTimestamp.create!( region_id: region_id, eve_item_id: eve_item_id, day_timestamp: max_date_info )
      end
      last_update_record
    end
  end
end
