# This does not really work.

require 'rubygems'
require 'active_record'
require 'factory_girl'
include FactoryGirl::Syntax::Methods

require_relative '../test/dummy/app/models/region'
require_relative '../test/dummy/app/models/eve_item'
require_relative '../app/models/caddie/crest_data_retriever'
require_relative '../app/models/caddie/crest_price_history_update'
require_relative '../app/models/caddie/crest_price_history_last_day_timestamp'

require_relative '../test/factories/caddie/regions'
require_relative '../test/factories/caddie/eve_items'
require_relative '../test/factories/caddie/crest_price_history_updates'

def create_fixture( fixture_file, fixtures )

  File.open( "../test/fixtures/#{fixture_file}.yml", 'w') do |f|
    increment = 1
    fixtures.each do |fixture|
      attrs = fixture.attributes
      attrs.delete_if{|k,v| v.blank?}

      output = { 'r_' + increment.to_s => attrs}
      f << output.to_yaml.gsub(/^---\n/,'') + "\n"

      increment += 1
    end
  end

end

db_config = YAML::load(File.open( '../test/dummy/config/database.yml' ) )
ApplicationRecord.establish_connection( db_config[ 'test' ] )

`RAILS_ENV=test rake db:reset`

region = create( :caddie_heimatar )
create_fixture( 'regions', [ region ] )

next_process_date = Time.now.to_date

eve_items = []
price_histories = []
1.upto( 53 ).each do
  eve_item = create( :caddie_eve_item )
  price_histories << create( :caddie_crest_price_history_update, region: region, eve_item: eve_item, next_process_date: next_process_date )
  eve_items << eve_item
end
create_fixture( 'eve_items', eve_items )
create_fixture( 'caddie/crest_price_history_updates', price_histories )