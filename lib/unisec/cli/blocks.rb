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

          # Display a block matching a decimal code point, standardized hexadecimal codepoint, string character or block name
          # @param block_arg [Integer|String] Decimal code point or standardized hexadecimal codepoint or string character (only one, so be careful with emojis, composed or joint characters using several units) or directly look for the block name (case insensitive).
          def call(block_arg: nil, **options)
            block_arg = block_arg.to_i if /\A\d+\Z/.match?(block_arg) # cast decimal string to integer
            Unisec::Blocks.block_display(block_arg, with_count: options[:with_count].to_bool)
          end
        end

        # Command `unisec blocks invalid`
        #
        # Example:
        #
        # ```plaintext
        # $ unisec blocks invalid
        # (Assigned) invalid, private, reserved ranges:
        # Range: U+D800 - U+DFFF      Name: Surrogates (invalid outside UTF-16)
        # Range: U+E000 - U+F8FF      Name: Private Use Area (located in BMP)
        # Range: U+F0000 - U+FFFFF    Name: Supplementary Private Use Area-A
        # Range: U+100000 - U+10FFFF  Name: Supplementary Private Use Area-B
        #
        # Unasigned, unallocated ranges:
        # Range: U+2FE0 - U+2FEF
        # Range: U+10200 - U+1027F
        # Range: U+103E0 - U+103FF
        # Range: U+107C0 - U+107FF
        # …
        # ```
        class Invalid < Dry::CLI::Command
          desc 'List all invalid and unsassigned ranges'

          # List all invalid and unsassigned ranges
          def call(**)
            Unisec::Blocks.list_invalid_display
          end
        end
      end
    end
  end
end
