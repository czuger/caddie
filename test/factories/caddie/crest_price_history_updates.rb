FactoryGirl.define do
  factory :crest_price_history_update, class: Caddie::CrestPriceHistoryUpdate do
    eve_item
    region
    next_process_date { Time.now }
  end
end
