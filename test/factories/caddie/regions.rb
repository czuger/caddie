FactoryGirl.define do
  factory :caddie_region, class: Region do
    factory :caddie_heimatar do
      cpp_region_id '10000030'
      name 'Heimatar'
    end
  end
end
