# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class GenderBranchComputation
      class << self
        def compute(properties)
          properties.fetch(properties[:subject].gender, '')
        end
      end
    end

  end
end
