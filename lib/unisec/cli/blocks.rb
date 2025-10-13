# frozen_string_literal: true

require 'dry/cli'
require 'unisec'
require 'unisec/utils'

module Unisec
  module CLI
    module Commands
      # CLI sub-commands `unisec blocks xxx` for the class {Unisec::Blocks} from the lib.
      module Blocks
        # Command `unisec blocks list`
        #
        # Example:
        #
        # ```plaintext
        # $ unisec blocks list
        # Range: U+0000 - U+007F      Name: Basic Latin
        # Range: U+0080 - U+00FF      Name: Latin-1 Supplement
        # …
        # ```
        class List < Dry::CLI::Command
          desc 'List all Unicode blocks'

          option :with_count, default: 'false', values: %w[true false],
                              desc: "calculate block's range size & char count?"

          # List Unicode blocks
          def call(**options)
            Unisec::Blocks.list_display(with_count: options[:with_count].to_bool)
          end
        end

        # Command `unisec blocks search`
        #
        # Example:
        #
        # ```plaintext
        # $ unisec blocks search 127745
        # $ unisec blocks search U+1f4a9
        # $ unisec blocks search …
        # $ unisec blocks search javanese
        # ```
        class Search < Dry::CLI::Command
          desc 'Search for a specific block'

          argument :block_arg, required: true,
                               desc: 'Decimal code point | standardized hexadecimal codepoint | string character ' \
                                     '(only one, so be careful with emojis, composed or joint characters using ' \
                                     'several units) | block name (case insensitive)'

          option :with_count, default: 'false', values: %w[true false],
                              desc: "calculate block's range size & char count?"

          # List code points matching a Unicode property
          # @param block_arg [Integer|String] Decimal code point or standardized hexadecimal codepoint or string character (only one, so be careful with emojis, composed or joint characters using several units) or directly look for the block name (case insensitive).
          def call(block_arg: nil, **options)
            block_arg = block_arg.to_i if /\A\d+\Z/.match?(block_arg) # cast decimal string to integer
            Unisec::Blocks.block_display(block_arg, with_count: options[:with_count].to_bool)
          end
        end
      end
    end
  end
end
