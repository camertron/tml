# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class BooleanComputation
      class << self
        def compute(properties)
          arg1 = properties[:arg1]
          arg2 = properties[:arg2]
          send(properties[:operation].text, arg1, arg2)
        end

        protected

        def or(arg1, arg2)
          arg1 || arg2
        end

        def and(arg1, arg2)
          arg1 && arg2
        end

        def equals(arg1, arg2)
          arg1 == arg2
        end

        def not_equals(arg1, arg2)
          arg1 != arg2
        end

        def greater_than(arg1, arg2)
          arg1 > arg2
        end

        def greater_than_equal_to(arg1, arg2)
          arg1 >= arg2
        end

        def less_than(arg1, arg2)
          arg1 < arg2
        end

        def less_than_equal_to(arg1, arg2)
          arg1 <= arg2
        end
      end
    end

  end
end
