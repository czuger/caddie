module Caddie
  class PriceAdvice < ActiveRecord::Base
    belongs_to :eve_item
    belongs_to :trade_hub
  end
end
