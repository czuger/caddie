require 'test_helper'

module Caddie
  class CrestPriceHistoryUpdateTest < ActiveSupport::TestCase

    def setup
      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [], 5 ] )
      raise 'daily_operation_list = 0. You may recreate fixtures for today by running "RAILS_ENV=test rake app:caddie:create_fixtures_files"' if Caddie::CrestPriceHistoryUpdate.daily_operations_list.count == 0
    end

    teardown do
      Caddie::CrestPriceHistoryUpdate.unstub(:get_multipage_data)
    end

    test 'test update for new item' do
      eve_item = create( :caddie_eve_item )
      create( :caddie_crest_price_history, region_id: 1, eve_item_id: eve_item.id )
      assert_difference 'Caddie::CrestPriceHistoryUpdate.count' do
        Caddie::CrestPriceHistoryUpdate.update
      end
      assert_equal 1, Caddie::CrestPriceHistoryUpdate.daily_operations_list.count
    end

    test 'test update for existing item' do
      # TODO : do the test for : test update for existing item
    end

    test 'feed_price_histories single threaded' do
      result = Caddie::CrestPriceHistoryUpdate.feed_price_histories
      assert_equal 265, result[1]
    end

    test 'feed_price_histories multi threaded' do
      th = Caddie::MThreadedUpdater.new( Caddie::CrestPriceHistoryUpdate::NB_THREADS, Caddie::CrestPriceHistoryUpdate.daily_operations_list )
      result = th.feed_price_histories_threaded
      assert_equal 265, result[1]
    end

  end
end