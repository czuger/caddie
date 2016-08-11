require 'test_helper'

module Caddie
  class CrestPriceHistoryUpdateLogTest < ActiveSupport::TestCase

    test 'Should create a new log entry' do
      assert_difference 'Caddie::CrestPriceHistoryUpdateLog.count' do
        Caddie::CrestPriceHistoryUpdateLog.store_log_data( Time.now.to_date, 10, 10, 50, 50, 100 )
      end
    end

    test 'Should update the log entry' do
      log = nil
      Caddie::CrestPriceHistoryUpdateLog.store_log_data( Time.now.to_date, 10, 10, 50, 50, 100 )
      assert_no_difference 'Caddie::CrestPriceHistoryUpdateLog.count' do
        log = Caddie::CrestPriceHistoryUpdateLog.store_log_data( Time.now.to_date, 10, 10, 1000, 50, 100 )
      end
      assert_equal 1000, log.total_inserts
    end
  end
end
