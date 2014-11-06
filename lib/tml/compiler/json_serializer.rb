# encoding: UTF-8

require 'json-write-stream'

module Tml
  module Compiler

    class JsonSerializer < Visitor
      attr_reader :writer

      def initialize(stream)
        @writer = JsonWriteStream.from_stream(stream)
      end

      def serialize(ast)
        visit(ast)
        writer.flush
      end

      protected

      def visit_children(node)
        writer.write_object unless writer.in_object?
        writer.write_key_value('type', remove_namespacing(node.class.name))
        writer.write_object('properties')

        super

        writer.close_object
        writer.close_object
      end

      def visit_child(key, child)
        if child.respond_to?(:each_child)
          writer.write_object(key.to_s)
          super
        else
          writer.write_key_value(key.to_s, child)
        end
      end

      def visit_RootNode(node)
        writer.write_array
        super
      end
    end

  end
end
