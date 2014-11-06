# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class DateComputation
      class << self
        def compute(properties)
          loc_date = properties[:subject].date_time.localize.to_date
          loc_date.send("to_#{properties[:format].text}_s")
        end
      end
    end

  end
end
