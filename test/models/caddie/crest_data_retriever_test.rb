require 'test_helper'

module Caddie
  class CrestDataRetrieverTest < ActiveSupport::TestCase

    def setup

      Object.stubs( :read ).returns( { items: [ 'item_test' ] }.to_json )
      Caddie::CrestPriceHistoryUpdate.stubs( :open ).returns( Object )

    end

    test 'get_multipage_data' do
      result = Caddie::CrestPriceHistoryUpdate.get_markets( 1, 1 )
      assert_equal [['item_test'], 1], result
    end

    test 'Shoud properly handle OpenURI::HTTPError' do
      Caddie::CrestPriceHistoryUpdate.unstub( :open )
      Caddie::CrestPriceHistoryUpdate.stubs(:open).raises( OpenURI::HTTPError.new( 'No connection', STDERR ) )

      Caddie::CrestPriceHistoryUpdate.stubs(:sleep)

      result = Caddie::CrestPriceHistoryUpdate.feed_price_histories
      assert_equal 53*2, result[3]

      Caddie::CrestPriceHistoryUpdate.unstub(:sleep)
    end

    teardown do
      Object.unstub(:read)
      Caddie::CrestPriceHistoryUpdate.unstub(:open)
    end

  end
end