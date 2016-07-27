require 'test_helper'
require 'minitest/mock'

module Caddie
  class CrestPriceHistoryUpdateTest < ActiveSupport::TestCase

    def setup
      @region = create( :heimatar )
      next_process_date = Time.now.to_date
      1.upto( 53 ).each do
        item = create( :eve_item )
        create( :crest_price_history_update, region: @region, eve_item: item, next_process_date: next_process_date )
      end
      Caddie::CrestPriceHistoryUpdate.stubs( :get_markets ).returns( [ [], 5 ] )

    end

    test 'feed_price_histories' do
      result = Caddie::CrestPriceHistoryUpdate.feed_price_histories
      assert_equal 265, result[1]
    end

    # TODO : factory girl does not seems to work with thread
    # Fixtures work. Test real create! to see errors
    # Ask the question on stackoverflow
    test "feed_price_histories_threaded" do
      result = Caddie::CrestPriceHistoryUpdate.feed_price_histories_threaded
      puts result.inspect
      assert_equal 265, result[1]
    end

  end
end