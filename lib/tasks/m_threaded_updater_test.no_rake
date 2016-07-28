require 'mocha/api'
require 'minitest'

include Mocha::API
include FactoryGirl::Syntax::Methods

require_relative '../../test/dummy/app/models/eve_item'
require_relative '../../test/dummy/app/models/region'
require_relative '../../test/factories/caddie/eve_items'
require_relative '../../test/factories/caddie/regions'
require_relative '../../app/models/caddie/crest_data_retriever'
require_relative '../../app/models/caddie/crest_price_history_update'
require_relative '../../test/factories/caddie/crest_price_history_updates'

# Regular test unit does not commit between insertions, this algo rely on database to split work between threads
# So we have to fake a test outside the test unit
namespace :test do

  desc "M threaded uptader test"
  task :m_threaded_uptader_test=> :environment do
    if (ENV['RAILS_ENV'] == "test") # protect against execution in dev mode

      Caddie::CrestPriceHistoryUpdate.stubs( :get_multipage_data ).returns( [ [], 5 ] )

      Region.delete_all
      EveItem.delete_all
      Caddie::CrestPriceHistoryUpdate.delete_all

      next_process_date = Time.now.to_date
      region = create( :caddie_heimatar )
      1.upto( 53 ).each do
        item = create( :caddie_eve_item )
        create( :crest_price_history_update, region: region, eve_item: item, next_process_date: next_process_date )
      end

      th = Caddie::MThreadedUpdater.new( 4, Caddie::CrestPriceHistoryUpdate.daily_operations_list )
      th.split_work_for_threads
      timings = th.feed_price_histories_threaded
      # pp timings
      unless 53 == timings[1]/5
        "Test failed : #{timings[1]/5} != 53"
      else
        puts 'Test passed'
      end
    else
      puts 'Can be only executed in test env'
    end

    Region.delete_all
    EveItem.delete_all
    Caddie::CrestPriceHistoryUpdate.delete_all
  end
end