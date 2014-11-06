# encoding: UTF-8

module Tml
  module Compiler
    autoload :RootNode,                    'tml/compiler/nodes'
    autoload :StringLiteralNode,           'tml/compiler/nodes'
    autoload :NumericLiteralNode,          'tml/compiler/nodes'
    autoload :IdentifierNode,              'tml/compiler/nodes'
    autoload :FunctionCallNode,            'tml/compiler/nodes'
    autoload :TextNode,                    'tml/compiler/nodes'
    autoload :ComputationBlockNode,        'tml/compiler/nodes'
    autoload :VariableDefinitionBlockNode, 'tml/compiler/nodes'
    autoload :PrintBlockNode,              'tml/compiler/nodes'
    autoload :ConditionalBlockNode,        'tml/compiler/nodes'

    autoload :Token,            'tml/compiler/token'
    autoload :Tokenizer,        'tml/compiler/tokenizer'
    autoload :TokenizerState,   'tml/compiler/tokenizer_state'
    autoload :Parser,           'tml/compiler/parser'
    autoload :Interpreter,      'tml/compiler/interpreter'
    autoload :InterpreterState, 'tml/compiler/interpreter_state'
    autoload :StaticAnalyzer,   'tml/compiler/static_analyzer'

    autoload :JsonSerializer,    'tml/compiler/json_serializer'
    autoload :YamlSerializer,    'tml/compiler/yaml_serializer'
  end
end
