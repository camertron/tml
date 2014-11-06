# encoding: UTF-8

module Tml
  module Types

    class PluralNumber < Type
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def plural_form
        @plural_form ||=
          TwitterCldr::Formatters::Plurals::Rules.rule_for(value)
      end

      def to_s
        value
      end
    end

  end
end
