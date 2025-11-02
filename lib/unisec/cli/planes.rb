# frozen_string_literal: true

require 'dry/cli'
require 'unisec'
require 'unisec/utils'

module Unisec
  module CLI
    module Commands
      # CLI sub-commands `unisec planes xxx` for the class {Unisec::Planes} from the lib.
      module Planes
        # Command `unisec planes list`
        #
        # Example:
        #
        # ```plaintext
        # $ unisec planes list
        # Range: U+0000 - U+FFFF      Name: Basic Multilingual Plane
        # Range: U+10000 - U+1FFFF    Name: Supplementary Multilingual Plane
        # Range: U+20000 - U+2FFFF    Name: Supplementary Ideographic Plane
        # Range: U+30000 - U+3FFFF    Name: Tertiary Ideographic Plane
        # …
        # $ unisec planes list --with-blocks=true
        # Range: U+0000 - U+FFFF      Name: Basic Multilingual Plane
        #   Blocks:
        #     Range: U+0000 - U+007F      Name: Basic Latin
        #     Range: U+0080 - U+00FF      Name: Latin-1 Supplement
        #     Range: U+0100 - U+017F      Name: Latin Extended-A
        #     Range: U+0180 - U+024F      Name: Latin Extended-B
        # ```
        class List < Dry::CLI::Command
          desc 'List all Unicode planes'

          option :with_blocks, default: 'false', values: %w[true false],
                               desc: 'display the blocks associated with each plane?'
          option :with_count, default: 'false', values: %w[true false],
                              desc: "calculate block's range size & char count?"

          # List Unicode blocks
          def call(**options)
            Unisec::Planes.list_display(with_blocks: options[:with_blocks].to_bool,
                                        with_count: options[:with_count].to_bool)
          end
        end

        # Command `unisec planes search`
        #
        # Example:
        #
        # ```plaintext
        # $ unisec planes search 3
        # Range: U+30000 - U+3FFFF    Name: Tertiary Ideographic Plane
        # $ unisec planes search 2 --with-blocks=true
        # Range: U+20000 - U+2FFFF    Name: Supplementary Ideographic Plane
        #   Blocks:
        #     Range: U+20000 - U+2A6DF    Name: CJK Unified Ideographs Extension B
        #     Range: U+2A700 - U+2B73F    Name: CJK Unified Ideographs Extension C
        #     Range: U+2B740 - U+2B81F    Name: CJK Unified Ideographs Extension D
        #     Range: U+2B820 - U+2CEAF    Name: CJK Unified Ideographs Extension E
        #     Range: U+2CEB0 - U+2EBEF    Name: CJK Unified Ideographs Extension F
        #     Range: U+2EBF0 - U+2EE5F    Name: CJK Unified Ideographs Extension I
        #     Range: U+2F800 - U+2FA1F    Name: CJK Compatibility Ideographs Supplement
        # $ unisec planes search 'basic multilingual plane'
        # Range: U+0000 - U+FFFF      Name: Basic Multilingual Plane
        # $ unisec planes search 'unassigned'
        # Range: U+40000 - U+4FFFF    Name: unassigned
        # Range: U+50000 - U+5FFFF    Name: unassigned
        # Range: U+60000 - U+6FFFF    Name: unassigned
        # Range: U+70000 - U+7FFFF    Name: unassigned
        # Range: U+80000 - U+8FFFF    Name: unassigned
        # Range: U+90000 - U+9FFFF    Name: unassigned
        # Range: U+A0000 - U+AFFFF    Name: unassigned
        # Range: U+B0000 - U+BFFFF    Name: unassigned
        # Range: U+C0000 - U+CFFFF    Name: unassigned
        # Range: U+D0000 - U+DFFFF    Name: unassigned
        # ```
        class Search < Dry::CLI::Command
          desc 'Search for a specific plane'

          argument :plane_arg, required: true,
                               desc: 'Name or number of the plane'

          option :with_blocks, default: 'false', values: %w[true false],
                               desc: 'display the blocks associated with each plane?'
          option :with_count, default: 'false', values: %w[true false],
                              desc: "calculate block's range size & char count?"

          # Display a plane matching a plane name or plane number
          # @param plane_arg [String|Integer] name or number of the plane
          def call(plane_arg: nil, **options)
            plane_arg = plane_arg.to_i if /\A\d+\Z/.match?(plane_arg) # cast decimal string to integer
            Unisec::Planes.plane_display(plane_arg, with_blocks: options[:with_blocks].to_bool,
                                                    with_count: options[:with_count].to_bool)
          end
        end
      end
    end
  end
end
