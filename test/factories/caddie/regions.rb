FactoryGirl.define do

  factory :caddie_region, class: Region do

    factory :caddie_heimatar do
      cpp_region_id '10000030'
      name 'Heimatar'

      after(:create) do |region|

        # pator = create( :rens, region: region )
        # rens = create( :pator, region: region )

        blueprint_and_market_group = create( :caddie_inferno_fury_cruise_missile )
        blueprint_but_no_market_group = create( :caddie_mjolnir_fury_cruise_missile )
        no_market_group_and_no_blueprint = create( :caddie_inferno_precision_cruise_missile )

        [ blueprint_and_market_group, blueprint_but_no_market_group, no_market_group_and_no_blueprint ].each do |item|

          # [ pator, rens ].each do |trade_hub|
          #   create( :min_price, trade_hub: trade_hub, eve_item: item )
          # end

          # create( :crest_prices_last_month_average, eve_item: item, region: region )

        end
      end

    end

  end

end
