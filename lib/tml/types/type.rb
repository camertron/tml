# encoding: UTF-8

module Tml
  module Types

    class Type
      def self.type_name
        @type_name ||= name.split('::').last
      end
    end

  end
end
