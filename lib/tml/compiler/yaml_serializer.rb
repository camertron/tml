# encoding: UTF-8

require 'yaml-write-stream'

module Tml
  module Compiler

    class YamlSerializer < Visitor
      attr_reader :writer

      def initialize(stream)
        @writer = YamlWriteStream.from_stream(stream)
      end

      def serialize(ast)
        visit(ast)
        writer.flush
      end

      protected

      def visit_children(node)
        writer.write_map unless writer.in_map?
        writer.write_key_value('type', remove_namespacing(node.class.name))
        writer.write_map('properties')

        super

        writer.close_map
        writer.close_map
      end

      def visit_child(key, child)
        if child.respond_to?(:each_child)
          writer.write_map(key.to_s)
          super
        else
          writer.write_key_value(key.to_s, child || '')
        end
      end

      def visit_RootNode(node)
        writer.write_sequence
        super
      end
    end

  end
end
