FactoryGirl.define do
  factory :crest_price_history_last_day_timestamp, class: Caddie::CrestPriceHistoryLastDayTimestamp do
    eve_item
    region
    day_timestamp { Time.now }
  end
end
