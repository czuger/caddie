FactoryGirl.define do
  factory :crest_price_history, class: CrestPriceHistory do
    history_date { Time.now }
    region
    eve_item
  end
end
