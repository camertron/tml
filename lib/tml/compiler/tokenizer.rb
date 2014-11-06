# encoding: UTF-8

module Tml
  module Compiler

    class Tokenizer
      TOKENS = {
        /\A\{!\z/ => :var_block_start,
        /\A\{=\z/ => :print_block_start,
        /\A\{\?\z/ => :conditional_block_start,
        /\A\{\{\z/ => :compute_block_start,
        /\A\}\}\z/ => :compute_block_end,
        /\A\}\z/ => :block_end,
        /\A".*"\z/ => :string_literal,
        /\A'.*'\z/ => :string_literal,
        /\A[\s]*[\d]*\.?[\d]+?[\s]*\z/ => :numeric_literal,
        /\A:\z/ => :colon,
        /\A,\z/ => :comma,
        /\A\.\z/ => :dot,
        // => :identifier
      }

      class << self

        def tokenize(text)
          state = TokenizerState.new

          tokens = text.each_char.flat_map do |char|
            identify_token_list(state.feed(char))
          end

          if last_token = state.eos
            tokens << identify_token(last_token)
          end

          tokens
        end

        private

        def identify_token_list(token_list)
          token_list.map do |token_text|
            identify_token(token_text)
          end
        end

        def identify_token(token_text)
          TOKENS.each_pair do |regex, type|
            if regex =~ token_text
              return make_token(token_text, type)
            end
          end
        end

        def make_token(value, type)
          Token.new(value, type)
        end

      end
    end

  end
end
