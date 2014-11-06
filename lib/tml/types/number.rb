# encoding: UTF-8

module Tml
  module Types

    class Number < Type
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        value
      end
    end

  end
end
