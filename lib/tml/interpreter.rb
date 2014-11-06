# encoding: UTF-8

module Tml

  module Interpreter
    autoload :InterpreterState,          'tml/interpreter/interpreter_state'
    autoload :DateComputation,           'tml/interpreter/date_computation'
    autoload :TimeComputation,           'tml/interpreter/time_computation'
    autoload :DateTimeComputation,       'tml/interpreter/date_time_computation'
    autoload :GenderBranchComputation,   'tml/interpreter/gender_branch_computation'
    autoload :BooleanComputation,        'tml/interpreter/boolean_computation'
    autoload :PluralBranchComputation,   'tml/interpreter/plural_branch_computation'
    autoload :NumberFormatComputation,   'tml/interpreter/number_format_computation'
    autoload :CurrencyFormatComputation, 'tml/interpreter/currency_format_computation'

    class << self
      def evaluate(ast, inputs)
        Compiler::StaticAnalyzer.analyze!(ast, inputs)
        InterpreterState.new(inputs).evaluate(ast)
      end
    end
  end

end
