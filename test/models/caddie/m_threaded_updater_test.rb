require 'test_helper'

module Caddie
  class MThreadedUpdaterTest < ActiveSupport::TestCase

    test 'Col / seconds should be a max and not a sum' do
      Caddie::CrestPriceHistoryUpdate.stubs( :feed_price_histories ).returns( [ 10, 15, 20, 25 ] )
      runner = Caddie::MThreadedUpdater.new( 4, Caddie::CrestPriceHistoryUpdate.daily_operations_list )
      result = runner.feed_price_histories_threaded
      assert_equal [ 10*4, 15*4, 20, 25*4 ], result
    end

  end
end
