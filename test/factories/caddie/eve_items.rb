FactoryGirl.define do

  factory :caddie_eve_item, class: EveItem do

    cost 5
    involved_in_blueprint true

    sequence :cpp_eve_item_id do |n|
      n
    end
    sequence :name do |n|
      "Name #{n}"
    end
    sequence :name_lowcase do |n|
      "name #{n}"
    end

    # An example of item with blueprint and market group
    factory :caddie_inferno_fury_cruise_missile do
      cpp_eve_item_id 2621
      name "Inferno Fury Cruise Missile"
      name_lowcase "inferno fury cruise missile"
      cost 1815252.83
      # market_group { FactoryGirl.create( :advanced_high_damage_cruise_missiles_market_group ) }

      after(:create) do |eve_item|
        # create( :inferno_fury_cruise_blueprint, eve_item: eve_item )
      end

    end

    # An example of item with blueprint but no market group
    factory :caddie_mjolnir_fury_cruise_missile do
      cpp_eve_item_id 24535
      name "Mjolnir Fury Cruise Missile"
      name_lowcase "mjolnir fury cruise missile"
      cost 1815252.83

      after(:create) do |eve_item|
        # create( :inferno_fury_cruise_blueprint, eve_item: eve_item )
      end

    end

    # An example with no blueprint and no market group
    factory :caddie_inferno_precision_cruise_missile do
      cpp_eve_item_id 2637
      name "Inferno Precision Cruise Missile"
      name_lowcase "inferno precision cruise missile"
      cost 1815252.83
    end

  end
end
