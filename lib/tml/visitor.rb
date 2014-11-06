# encoding: UTF-8

module Tml

  class Visitor
    def visit(node)
      method = "visit_#{remove_namespacing(node.class.name)}"
      send(method, node)
    end

    protected

    # `Node` instances are special because they contain
    # an array of children, not a list of key/value pairs.
    def visit_RootNode(node)
      node.each_child do |child|
        visit(child)
      end
    end

    def visit_children(node)
      if node.respond_to?(:each_child)
        node.each_child.each_with_object({}) do |(key, child), ret|
          ret[key] = visit_child(key, child)
        end
      else
        {}
      end
    end

    def visit_child(key, child)
      visit(child)
    end

    def method_missing(method, *args, &block)
      if method.to_s.start_with?('visit_')
        visit_children(*args, &block)
      else
        raise NoMethodError,
          "no method `#{method}' for #{self.class.name}"
      end
    end

    def respond_to?(method)
      method.to_s.start_with?('visit_')
    end

    def remove_namespacing(method)
      method.to_s.split('::').last
    end
  end

end
