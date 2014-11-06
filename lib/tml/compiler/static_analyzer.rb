# encoding: UTF-8

module Tml
  module Compiler

    class MissingInputError < StandardError; end

    class StaticAnalyzer
      class << self
        def analyze!(ast, inputs)
          check_variable_definitions!(ast, inputs)
        end

        private

        def check_variable_definitions!(ast, inputs)
          find_variable_definitions(ast).each do |definition|
            input = inputs.find do |name, input|
              name == definition.name &&
                definition.type.is_a?(IdentifierNode) &&
                input.class.type_name == definition.type.text
            end

            unless input
              raise MissingInputError,
                "couldn't find required input '#{definition.name}' of " +
                  "type '#{definition.type.text}' in the list of inputs"
            end
          end
        end

        def find_variable_definitions(ast)
          VariableDefinitionFinder.new.tap do |finder|
            finder.visit(ast)
          end.definitions
        end
      end
    end

    class VariableDefinitionFinder < Visitor
      attr_reader :definitions

      def initialize
        @definitions = []
      end

      def visit_VariableDefinitionBlockNode(node)
        definitions << node
      end
    end

  end
end
