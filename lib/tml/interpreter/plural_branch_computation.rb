# encoding: UTF-8

require 'twitter_cldr'

module Tml
  module Interpreter

    class PluralBranchComputation
      class << self
        def compute(properties)
          properties.fetch(properties[:subject].plural_form, '')
        end
      end
    end

  end
end
