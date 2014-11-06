# encoding: UTF-8

module Tml
  module Types

    class NounWithGender < Type
      attr_reader :noun, :gender

      def initialize(noun, gender)
        @noun = noun
        @gender = gender
      end

      def to_s
        noun
      end
    end

  end
end
