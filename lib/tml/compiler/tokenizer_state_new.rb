# encoding: UTF-8

module Tml
  module Compiler

    class TokenizerState
      STATES = {
        start: [
          { on: '{',    next: :block_start, terminal: true, backtrack: true },
          { on: '}',    next: :block_end, terminal: true, backtrack: true },
          { on: /./m,   next: :start }
        ],

        variable: [
          { on: /[\w]/,         next: :variable },
          { on: /[:\{\},"'\.]/, next: :block, terminal: true, backtrack: true },
          { on: /./m,           next: :block, terminal: true }
        ],

        in_double_quotes: [
          { on: '\\', next: :dq_escape_sequence },
          { on: '"',  next: :block, terminal: true },
          { on: /./m, next: :in_double_quotes }
        ],

        in_single_quotes: [
          { on: '\\', next: :sq_escape_sequence },
          { on: "'",  next: :block, terminal: true },
          { on: /./m, next: :in_single_quotes }
        ],

        dq_escape_sequence: [
          { on: /./m, next: :in_double_quotes }
        ],

        sq_escape_sequence: [
          { on: /./m, next: :in_single_quotes }
        ],

        block_start: [
          { on: '{', next: :block_start },
          { on: '!', next: :block, terminal: true },
          { on: '=', next: :block, terminal: true },
          { on: '{', next: :block, terminal: true },
          { on: '?', next: :block, terminal: true },
          { on: //,  next: :block, terminal: true, backtrack: true }
        ],

        block: [
          { on: '{',  next: :block_start, terminal: true, backtrack: true },
          { on: '}',  next: :block_end, terminal: true, backtrack: true },
          { on: '"',  next: :in_double_quotes },
          { on: "'",  next: :in_single_quotes },
          { on: ':',  next: :block, terminal: true },
          { on: ',',  next: :block, terminal: true },
          { on: '.',  next: :block, terminal: true },
          { on: /./m, next: :variable }
        ],

        block_end: [
          { on: '}',  next: :block_end },
          { on: /./m, next: :start, terminal: true, backtrack: true }
        ]
      }

      INITIAL_STATE = :start

      attr_reader :state, :tokens

      def initialize
        @state = INITIAL_STATE
        @accumulator = []
      end

      def feed(char)
        # binding.pry if state == :block_start
        new_state = find_next_state_for(char)
        puts new_state[:next]
        @state = new_state[:next]
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

      protected

      def find_next_state_for(char)
        STATES[state].find do |next_state|
          char_matches?(next_state[:on], char)
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
