# encoding: UTF-8

module Tml
  module Compiler

    class TokenizerState
      STATES = {
        start: [
          { on: '{',    next: :block_start },
          { on: '}',    next: :block_end },
          { on: '"',    next: :in_double_quotes, when: lambda { |s| s.in_block? } },
          { on: "'",    next: :in_single_quotes, when: lambda { |s| s.in_block? } },
          { on: ':',    next: :start, terminal: true, when: lambda { |s| s.in_block? } },
          { on: ',',    next: :start, terminal: true, when: lambda { |s| s.in_block? } },
          { on: '.',    next: :start, terminal: true, when: lambda { |s| s.in_block? } },
          { on: /[\w]/, next: :variable },
          { on: /./m,   next: :text }
        ],

        text: [
          { on: /[:\{\},"'\.]/, next: :start, terminal: true, backtrack: true },
          { on: /./m,           next: :text }
        ],

        variable: [
          { on: /[\w]/,         next: :variable },
          { on: /[:\{\},"'\.]/, next: :start, terminal: true, backtrack: true },
          { on: //,             next: :start, terminal: true }
        ],

        in_double_quotes: [
          { on: '\\', next: :dq_escape_sequence },
          { on: '"',  next: :start, terminal: true },
          { on: /./m, next: :in_double_quotes }
        ],

        in_single_quotes: [
          { on: '\\', next: :sq_escape_sequence },
          { on: "'",  next: :start, terminal: true },
          { on: /./m, next: :in_single_quotes }
        ],

        dq_escape_sequence: [
          { on: /./m, next: :in_double_quotes }
        ],

        sq_escape_sequence: [
          { on: /./m, next: :in_single_quotes }
        ],

        block_start: [
          { on: '!', next: :start, terminal: true },
          { on: '=', next: :start, terminal: true },
          { on: '{', next: :start, terminal: true },
          { on: '?', next: :start, terminal: true }
        ],

        block_end: [
          { on: '}',  next: :start, terminal: true },
          { on: /./m, next: :start, terminal: true, backtrack: true }
        ]
      }

      INITIAL_STATE = :start

      OPENING_BLOCK_TYPES = [
        :var_block_start,
        :print_block_start,
        :compute_block_start,
        :conditional_block_start
      ]

      CLOSING_BLOCK_TYPES = [
        :compute_block_end,
        :block_end
      ]

      attr_reader :state, :tokens

      def initialize
        @state = INITIAL_STATE
        @accumulator = []
        @block_counter = 0
      end

      def feed(char)
        new_state = find_next_state_for(char)
        @state = new_state[:next]

        if state == :block_start
          @block_counter += 1
        elsif state == :block_end
          @block_counter -= 1
        end

        @accumulator.push(char) unless new_state[:backtrack]

        tokens = [if new_state[:terminal]
          token = accum_s
          @accumulator.clear
          token
        end]

        (if new_state[:backtrack]
          tokens + feed(char)
        else
          tokens
        end).select { |t| t && !t.empty? }
      end

      def eos
        last_token = accum_s
        last_token unless last_token.empty?
      end

      def accum_s
        @accumulator.join
      end

      def in_block?
        @block_counter > 0
      end

      protected

      def find_next_state_for(char)
        STATES[state].find do |next_state|
          matches = char_matches?(next_state[:on], char)

          if next_state[:when]
            matches &&= next_state[:when].call(self)
          end

          matches
        end
      end

      def char_matches?(matcher, char)
        case matcher
          when Regexp
            !!(matcher =~ char)
          else
            matcher == char
        end
      end
    end

  end
end
