FactoryGirl.define do
  factory :caddie_crest_price_history, class: CrestPriceHistory do
    day_timestamp '20160801'
    history_date { Time.now }
  end
end
