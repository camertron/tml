# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class CurrencyFormatComputation
      class << self
        def compute(properties)
          loc_num = properties[:subject].value.localize.to_currency
          precision = properties[:precision]
          currency = properties[:currency]
          loc_num.to_s(precision: precision, currency: currency)
        end
      end
    end

  end
end
