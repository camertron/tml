# encoding: UTF-8

module Tml

  module InputHelperMethods
    class << self
      def date_and_time(*args, &block)
        Tml::Types::DateAndTime.new(*args, &block)
      end

      def noun_with_gender(*args, &block)
        Tml::Types::NounWithGender.new(*args, &block)
      end

      def number(*args, &block)
        Tml::Types::Number.new(*args, &block)
      end

      def plural_number(*args, &block)
        Tml::Types::PluralNumber.new(*args, &block)
      end

      def string(*args, &block)
        Tml::Types::String.new(*args, &block)
      end
    end
  end

  module HelperMethods
    def tml(string, &block)
      tokens = Tml::Compiler::Tokenizer.tokenize(string)
      # binding.pry
      ast = Tml::Compiler::Parser.new(tokens).parse

      inputs = if block
        InputHelperMethods.module_eval(&block)
      else
        {}
      end

      Tml::Interpreter.evaluate(ast, inputs)
    end
  end

end
