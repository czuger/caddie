FactoryGirl.define do
  factory :region, class: Region do
    cpp_region_id '123456'
    name 'Region test'
    factory :heimatar do
      cpp_region_id '10000030'
      name 'Heimatar'
    end
  end
end
