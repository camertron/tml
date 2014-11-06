# encoding: UTF-8

module Tml
  module Compiler

    class ParseError < StandardError; end

    class Parser
      attr_reader :tokens, :index, :block_counter

      def initialize(tokens)
        @tokens = tokens
      end

      def parse
        @index = 0
        @block_counter = 0
        start
      end

      private

      def start
        RootNode.new.tap do |node|
          until eos?
            node.children << statement
          end
        end
      end

      def statement
        case current.type
          when :identifier
            if block_counter > 0
              function_call(identifier)
            else
              text
            end
          when *TokenizerState::OPENING_BLOCK_TYPES
            block
          when :string_literal
            string_literal
          when :numeric_literal
            numeric_literal
        end
      end

      def string_literal
        # remove quotes
        StringLiteralNode.new(current.value[1..-2]).tap do
          consume(:string_literal)
        end
      end

      def numeric_literal
        NumericLiteralNode.new(current.value.strip).tap do
          consume(:numeric_literal)
        end
      end

      def text
        TextNode.new(current.value).tap do
          consume(:identifier)
        end
      end

      def identifier
        IdentifierNode.new(current.value.strip).tap do
          consume(:identifier)
        end
      end

      def function_call(id)
        if current.type == :dot
          consume(:dot)
          FunctionCallNode.new(id, identifier)
        else
          id
        end
      end

      def block
        @block_counter += 1

        case current.type
          when :var_block_start
            var_block
          when :print_block_start
            print_block
          when :compute_block_start
            compute_block
          when :conditional_block_start
            conditional_block
          else
            raise ParseError, "Unrecognized block '#{current.type}'"
        end
      end

      def var_block
        consume(:var_block_start)
        properties = property_list
        value = properties.delete('value')

        if properties.size == 1
          name, type = properties.first

          VariableDefinitionBlockNode.new(name, type, value).tap do
            block_end
          end
        else
          raise ParseError,
            "Too many properties for variable definition block. #{properties.inspect}"
        end
      end

      def print_block
        consume(:print_block_start)

        PrintBlockNode.new(statement).tap do
          block_end
        end
      end

      def compute_block
        consume(:compute_block_start)
        properties = property_list

        if computation = properties.delete(:compute)
          ComputationBlockNode.new(computation, properties).tap do
            block_end
          end
        else
          raise ParseError,
            "Compute block defined without 'compute' property"
        end
      end

      def conditional_block
        consume(:conditional_block_start)
        properties = property_list

        if conditional = properties.delete(:if)
          if thenn = properties.delete(:then)
            elsee = properties.delete(:else)

            ConditionalBlockNode.new(conditional, thenn, elsee).tap do
              block_end
            end
          else
            raise ParseError, "conditional 'then' property not found"
          end
        else
          raise ParseError, "conditional 'if' property not found"
        end
      end

      def property_list
        list = {}

        if current.type == :identifier
          property.tap do |prop|
            list[prop.first] = prop.last
          end
        end

        while current.type == :comma
          consume(:comma)

          property.tap do |prop|
            list[prop.first] = prop.last
          end
        end

        list
      end

      def property
        property_name = identifier.text.to_sym
        consume(:colon)
        property_value = statement
        [property_name, property_value]
      end

      def block_end
        @block_counter -= 1

        case current.type
          when :compute_block_end
            consume(:compute_block_end)
          else
            consume(:block_end)
        end
      end

      def eos?
        index >= tokens.size
      end

      def current
        tokens[index]
      end

      def consume(token_type)
        do_consume(token_type)
        while consume_ws; end
      end

      def do_consume(token_type)
        if current.type == token_type
          @index += 1
        else
          raise ParseError, "expected '#{token_type}', got '#{current.type}'"
        end
      end

      def consume_ws
        consume = !eos? &&
          current.type == :identifier &&
          current.value.strip.empty? &&
          block_counter > 0

        do_consume(:identifier) if consume
        consume
      end
    end

  end
end
