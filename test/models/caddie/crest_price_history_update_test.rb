require 'test_helper'

module Caddie
  class CrestPriceHistoryUpdateTest < ActiveSupport::TestCase

    def setup
      cph = create( :crest_price_history )
      @cphu = create( :crest_price_history_update, region_id: cph.region_id, eve_item_id: cph.eve_item_id )
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [], 5 ] )
      # raise 'daily_operation_list = 0. You may recreate fixtures for today by running "RAILS_ENV=test ruby caddie_create_test_fixtures.rb"' if Caddie::CrestPriceHistoryUpdate.daily_operations_list.count == 0
    end

    def teardown
      Caddie::CrestPriceHistoryUpdate.unstub(:get_multipage_data)
    end

    test 'test update for new item' do
      @cphu.destroy
      assert_difference 'Caddie::CrestPriceHistoryUpdate.count' do
        Caddie::CrestPriceHistoryUpdate.update
      end
      assert_equal 1, Caddie::CrestPriceHistoryUpdate.daily_operations_list.count
    end

    test 'test update for existing item' do
      Caddie::CrestPriceHistoryUpdate.update
      assert_no_difference 'Caddie::CrestPriceHistoryUpdate.count' do
        Caddie::CrestPriceHistoryUpdate.update
      end
      assert_equal 1, Caddie::CrestPriceHistoryUpdate.daily_operations_list.count
    end

    test 'feed_price_histories single threaded' do
      result = Caddie::CrestPriceHistoryUpdate.feed_price_histories
      assert_equal 5, result[1]
    end

    # Deactivated. Waiting for a better solution : the fixture solution sucks
    # test 'feed_price_histories multi threaded' do
    #   th = Caddie::MThreadedUpdater.new( Caddie::CrestPriceHistoryUpdate::NB_THREADS, Caddie::CrestPriceHistoryUpdate.daily_operations_list )
    #   result = th.feed_price_histories_threaded
    #   assert_equal 265, result[1]
    # end

  end
end