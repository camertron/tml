# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class NumberFormatComputation
      class << self
        def compute(properties)
          loc_num = properties[:subject].value.localize
          precision = properties[:precision]
          loc_num.to_s(precision: precision)
        end
      end
    end

  end
end
