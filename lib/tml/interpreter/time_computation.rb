# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class TimeComputation
      class << self
        def compute(properties)
          loc_time = properties[:subject].date_time.localize.to_time
          loc_time.send("to_#{properties[:format].text}_s")
        end
      end
    end

  end
end
