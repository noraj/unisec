# frozen_string_literal: true

require 'dry/cli'
require 'unisec'

module Unisec
  module CLI
    module Commands
      # CLI sub-commands `unisec dump xxx` for several dump classes like {Unisec::Hexdump} or {Unisec::Decxdump} from the lib.
      module Dump
        # CLI command `unisec dump hex` for the class {Unisec::Hexdump} from the lib.
        #
        # Example:
        #
        # ```plaintext
        # $ unisec dump hex "ACCEIS"
        # UTF-8: 41 43 43 45 49 53
        # UTF-16BE: 0041 0043 0043 0045 0049 0053
        # UTF-16LE: 4100 4300 4300 4500 4900 5300
        # UTF-32BE: 00000041 00000043 00000043 00000045 00000049 00000053
        # UTF-32LE: 41000000 43000000 43000000 45000000 49000000 53000000
        #
        # $ unisec dump hex "ACCEIS" --enc utf16le
        # 4100 4300 4300 4500 4900 5300
        # ```
        class Hex < Dry::CLI::Command
          desc 'Hexadecimal dump (hexdump) in all Unicode encodings'

          argument :input, required: true,
                           desc: 'String input. Read from STDIN if equal to -.'

          option :enc, default: nil, values: %w[utf8 utf16be utf16le utf32be utf32le],
                       desc: 'Output only in the specified encoding.'

          # Hexdump of all Unicode encodings.
          # @param input [String] Input string to encode
          def call(input: nil, **options)
            input = $stdin.read.chomp if input == '-'
            if options[:enc].nil?
              puts Unisec::Hexdump.new(input).display
            else
              # using send() is safe here thanks to the value whitelist
              puts Unisec::Hexdump.send(options[:enc], input)
            end
          end
        end

        # CLI command `unisec dump dec` for the class {Unisec::Decdump} from the lib.
        #
        # Example:
        #
        # ```plaintext
        # $ unisec dump dec "TODO"
        #
        # $ unisec dump dec "TODO" --enc utf16le
        # ```
        class Dec < Dry::CLI::Command
          desc 'Decimal dump (decdump) in all Unicode encodings'

          argument :input, required: true,
                           desc: 'String input. Read from STDIN if equal to -.'

          option :enc, default: nil, values: %w[utf8 utf16be utf16le utf32be utf32le],
                       desc: 'Output only in the specified encoding.'

          # Decdump of all Unicode encodings.
          # @param input [String] Input string to encode
          def call(input: nil, **options)
            input = $stdin.read.chomp if input == '-'
            if options[:enc].nil?
              puts Unisec::Decdump.new(input).display
            else
              # using send() is safe here thanks to the value whitelist
              puts Unisec::Decdump.send(options[:enc], input)
            end
          end
        end
      end
    end
  end
end
