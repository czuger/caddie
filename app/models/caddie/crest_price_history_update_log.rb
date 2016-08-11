module Caddie
  class CrestPriceHistoryUpdateLog < ActiveRecord::Base

    def self.store_log_data( feed_date, update_planning_time, feeding_time, total_inserts, total_connections, total_time )
      log = Caddie::CrestPriceHistoryUpdateLog.where( feed_date: feed_date ).first_or_initialize
      log.update_planning_time = update_planning_time
      log.feeding_time = feeding_time
      log.total_inserts = total_inserts
      log.co_seconds = total_connections.to_f / total_time
      log.save!
      log
    end
  end
end
