# encoding: UTF-8

module Tml
  module Types

    class DateAndTime < Type
      attr_reader :date_time

      def initialize(date_time)
        @date_time = date_time
      end
    end

  end
end
