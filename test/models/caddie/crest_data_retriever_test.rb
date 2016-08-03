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

  end
end