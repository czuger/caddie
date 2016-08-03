require 'test_helper'

module Caddie
  class CrestPriceHistoryLastDayTimestampTest < ActiveSupport::TestCase

    def setup
    end

    test 'Should create new histories objects and new last day timestamps object' do
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [ { 'date' => Time.now.to_s } ], 5 ] )
      Caddie::CrestPriceHistoryLastDayTimestamp.delete_all
      assert_difference 'CrestPriceHistory.count', 53 do
        assert_difference 'Caddie::CrestPriceHistoryLastDayTimestamp.count', 53 do
          Caddie::CrestPriceHistoryUpdate.feed_price_histories
        end
      end
      Caddie::CrestPriceHistoryUpdate.unstub( :get_multipage_data )
    end

    test 'Should create new histories objects but no new last day timestamps object' do
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [ { 'date' => ( Time.now - 24 * 60 * 60 ).to_s } ], 5 ] )
      Caddie::CrestPriceHistoryUpdate.feed_price_histories

      Caddie::CrestPriceHistoryUpdate.unstub( :get_multipage_data )
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [ { 'date' => Time.now.to_s } ], 5 ] )
      assert_difference 'CrestPriceHistory.count', 53 do
        assert_no_difference 'Caddie::CrestPriceHistoryLastDayTimestamp.count' do
          Caddie::CrestPriceHistoryUpdate.feed_price_histories
        end
      end
      Caddie::CrestPriceHistoryUpdate.unstub( :get_multipage_data )
    end


  end
end
