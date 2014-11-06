# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class DateTimeComputation
      class << self
        def compute(properties)
          loc_dt = properties[:subject].date_time.localize
          loc_dt.send("to_#{properties[:format].text}_s")
        end
      end
    end

  end
end
