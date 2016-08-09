require 'test_helper'

module Caddie
  class CrestPriceHistoryLastDayTimestampTest < ActiveSupport::TestCase

    def setup
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [ { 'date' => Time.now.to_s } ], 5 ] )
    end

    def teardown
      Caddie::CrestPriceHistoryUpdate.unstub( :get_multipage_data )
    end

    test 'Should create a CrestPriceHistoryLastDayTimestamp record and an history object when there is no day timestamp and no history record' do
      create( :crest_price_history_update )

      assert_difference 'CrestPriceHistory.count', 1 do
        assert_difference 'Caddie::CrestPriceHistoryLastDayTimestamp.count', 1 do
          Caddie::CrestPriceHistoryUpdate.feed_price_histories
        end
      end
    end

    test 'Should create new histories objects but no new last day timestamps object' do
      create( :crest_price_history_update )

      Caddie::CrestPriceHistoryUpdate.unstub( :get_multipage_data )
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [ { 'date' => ( Time.now - 24 * 60 * 60 ).to_s } ], 5 ] )
      Caddie::CrestPriceHistoryUpdate.feed_price_histories

      Caddie::CrestPriceHistoryUpdate.unstub( :get_multipage_data )
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [ { 'date' => Time.now.to_s } ], 5 ] )

      assert_difference 'CrestPriceHistory.count', 1 do
        assert_no_difference 'Caddie::CrestPriceHistoryLastDayTimestamp.count' do
          Caddie::CrestPriceHistoryUpdate.feed_price_histories
        end
      end
    end

    test 'Should update the CrestPriceHistoryLastDayTimestamp object' do
      cphldt = create( :crest_price_history_last_day_timestamp, day_timestamp: Time.new( 0 ) )

      assert_no_difference 'Caddie::CrestPriceHistoryLastDayTimestamp.count' do
        cphldt = Caddie::CrestPriceHistoryLastDayTimestamp.create_or_update_last_day_timestamp(
          cphldt, Time.now, nil, nil )
      end
      assert_equal Time.now.strftime( '%D' ), cphldt.day_timestamp.strftime( '%D' )
    end

    test 'Should create a new CrestPriceHistoryLastDayTimestamp as there is none' do
      cph = create( :crest_price_history )
      cphldt = nil

      assert_difference 'Caddie::CrestPriceHistoryLastDayTimestamp.count' do
        cphldt = Caddie::CrestPriceHistoryLastDayTimestamp.create_or_update_last_day_timestamp(
          nil, Time.now, cph.region_id, cph.eve_item_id )
      end
      assert_equal Time.now.strftime( '%D' ), cphldt.day_timestamp.strftime( '%D' )
    end

    test 'Should return an update date of Time.new( 0 ) and a null last record because there is no history object' do
      last_update_date, last_update_record = Caddie::CrestPriceHistoryLastDayTimestamp
        .find_or_create_last_day_timestamp( -1, -1 )

      assert_equal Time.new( 0 ), last_update_date
      refute last_update_record
    end

    test 'Should return an update date equal to the created history object and no last record' do
      cph = create( :crest_price_history )

      last_update_date, last_update_record = Caddie::CrestPriceHistoryLastDayTimestamp
        .find_or_create_last_day_timestamp( cph.region_id, cph.eve_item_id )

      assert_equal cph.history_date.strftime( '%D' ), last_update_date.strftime( '%D' )
      refute last_update_record
    end

    test 'Should return an update date equal to the latest created history object and no last record' do
      cph1 = create( :crest_price_history, history_date: Time.now - 24*60*60 )
      cph2 = create( :crest_price_history, region_id: cph1.region_id, eve_item_id: cph1.eve_item_id )

      last_update_date, last_update_record = Caddie::CrestPriceHistoryLastDayTimestamp
        .find_or_create_last_day_timestamp( cph1.region_id, cph1.eve_item_id )

      assert_equal cph2.history_date.strftime( '%D' ), last_update_date.strftime( '%D' )
      assert cph1.history_date < last_update_date
      refute last_update_record
    end

    test 'Should return an update date and a last record' do
      cphldt = create( :crest_price_history_last_day_timestamp )

      last_update_date, last_update_record = Caddie::CrestPriceHistoryLastDayTimestamp
        .find_or_create_last_day_timestamp( cphldt.region_id, cphldt.eve_item_id )

      assert_equal cphldt.day_timestamp.strftime( '%D' ), last_update_date.strftime( '%D' )
      assert last_update_record
    end
  end
end
