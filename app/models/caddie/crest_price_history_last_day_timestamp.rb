module Caddie
  class CrestPriceHistoryLastDayTimestamp < ActiveRecord::Base
    belongs_to :eve_item
    belongs_to :region
  end
end
