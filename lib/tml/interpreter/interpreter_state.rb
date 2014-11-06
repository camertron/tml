# encoding: UTF-8

module Tml
  module Interpreter

    class InterpreterState < Visitor
      attr_reader :symbol_table

      def initialize(inputs)
        @symbol_table = inputs
        @result = []
      end

      def evaluate(ast)
        visit(ast)
        @result.join
      end

      protected

      def visit_VariableDefinitionBlockNode(node)
        unless symbol_table.include?(node.name)
          symbol_table[node.name.to_sym] = if node.value
            visit(node.value)
          else
            nil
          end
        end
      end

      def visit_PrintBlockNode(node)
        @result << visit(node.statement)
      end

      def visit_ComputationBlockNode(node)
        const = Interpreter.const_get("#{node.computation.text}Computation")
        const.compute(visit_children(node))
      end

      def visit_IdentifierNode(node)
        symbol_table[node.text.to_sym] || node
      end

      def visit_StringLiteralNode(node)
        interpolate(node.text)
      end

      def visit_NumericLiteralNode(node)
        if node.number.include?('.')
          node.number.to_f
        else
          node.number.to_i
        end
      end

      def visit_FunctionCallNode(node)
        receiver = visit(node.receiver)
        receiver.send(node.method.text)
      end

      def visit_ConditionalBlockNode(node)
        if visit(node.conditional)
          visit(node.then)
        else
          visit(node.else) if node.else
        end
      end

      def visit_TextNode(node)
        @result << node.text
      end

      def interpolate(text)
        text.gsub(/%\{(.*)\}/) do
          symbol_table[$1.to_sym].to_s
        end
      end
    end

  end
end
