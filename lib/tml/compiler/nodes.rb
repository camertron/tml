# encoding: UTF-8

module Tml
  module Compiler

    class RootNode
      attr_reader :children

      def initialize(*args)
        @children = []
      end

      def each_child(&block)
        children.each(&block)
      end
    end

    module BaseNode
      def self.included(base)
        base.children.each do |child|
          base.send(:attr_reader, child)
        end
      end

      def initialize(*args)
        self.class.children.each_with_index do |child, index|
          instance_variable_set(:"@#{child}", args[index])
        end
      end

      def each_child
        if block_given?
          self.class.children.each do |child|
            yield child, instance_variable_get(:"@#{child}")
          end
        else
          to_enum(__method__)
        end
      end
    end

    class StringLiteralNode
      def self.children
        @children ||= [:text].freeze
      end

      include BaseNode
    end

    class NumericLiteralNode
      def self.children
        @children ||= [:number].freeze
      end

      include BaseNode
    end

    class IdentifierNode
      def self.children
        @children ||= [:text].freeze
      end

      include BaseNode
    end

    class FunctionCallNode
      def self.children
        @children ||= [:receiver, :method].freeze
      end

      include BaseNode
    end

    class TextNode
      def self.children
        @children ||= [:text].freeze
      end

      include BaseNode
    end

    class ComputationBlockNode
      attr_reader :properties

      def self.children
        @children ||= [:computation].freeze
      end

      def initialize(computation, properties)
        @computation = computation
        @properties = properties
      end

      include BaseNode

      def each_child
        if block_given?
          super { |key, child| yield key, child }
          properties.each_pair { |key, prop| yield key, prop }
        else
          to_enum(__method__)
        end
      end
    end

    class VariableDefinitionBlockNode
      def self.children
        @children ||= [:name, :type, :value].freeze
      end

      include BaseNode
    end

    class PrintBlockNode
      def self.children
        @children ||= [:statement].freeze
      end

      include BaseNode
    end

    class ConditionalBlockNode
      def self.children
        @children ||= [:conditional, :then, :else].freeze
      end

      include BaseNode
    end

  end
end
