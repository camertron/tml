# encoding: UTF-8

module Tml
  module Compiler

    class Token
      attr_reader :value, :type

      def initialize(value, type)
        @value = value
        @type = type
      end
    end

  end
end
