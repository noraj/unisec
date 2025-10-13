# frozen_string_literal: true

require 'paint'
require 'unisec/utils'

module Unisec
  # Operations about Unicode blocks
  class Blocks # rubocop:disable Metrics/ClassLength
    # UCD Blocks file location
    # @see https://www.unicode.org/Public/UCD/latest/ucd/Blocks.txt
    UCD_BLOCKS = File.join(__dir__, '../../data/Blocks.txt')

    # Returns the version of Unicode used in UCD local file (data/Blocks.txt)
    # @return [String] Unicode version
    # @example
    #   Unisec::Blocks.ucd_blocks_version # => "17.0.0"
    def self.ucd_blocks_version
      first_line = File.open(UCD_BLOCKS, &:readline)
      first_line.match(/-(\d+\.\d+\.\d+)\.txt/).captures.first
    end

    # List Unicode blocks name
    # ⚠️ Char count value may be wrong for CJK UNIFIED IDEOGRAPH because they are poorly described in DerivedName.txt.
    # ⚠️ Populating char_count is slow and can take a few seconds.
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count?
    # @return [Array<Hash>] List of blocks (block name, range and count)
    # @example
    #   Unisec::Blocks.list # => [{range: 0..127, name: "Basic Latin", range_size: nil, char_count: nil}, … ]
    #   Unisec::Blocks.list(with_count: true) # => [{range: 0..127, name: "Basic Latin", range_size: 128, char_count: 95}, … ]
    def self.list(with_count: false)
      out = []
      file = File.new(UCD_BLOCKS)
      file.each_line(chomp: true) do |line|
        # Skip if the line is empty or a comment
        next if line.empty? || line[0] == '#'

        # parse the line to extract code point range and the name
        blk_range, blk_name = line.split(';')
        blk_range = Unisec::Utils::String.to_range(blk_range)
        blk_name.lstrip!
        out << {
          range: blk_range,
          name: blk_name,
          range_size: with_count ? blk_range.size : nil,
          char_count: with_count ? count_char_in_block(blk_range) : nil
        }
      end
      out
    end

    # Count the number of characters allocated in a block.
    # ⚠️ Char count value may be wrong for CJK UNIFIED IDEOGRAPH because they are poorly described in DerivedName.txt.
    # @param range [Range] Block code point range
    # @return [Integer] number of code points in the block
    # @example
    #   Unisec::Blocks::count_char_in_block(0xAC00..0xD7AF) # => 11172
    def self.count_char_in_block(range) # rubocop:disable Metrics/AbcSize
      counter = 0
      file = File.new(Rugrep::UCD_DERIVEDNAME)
      file.each_line(chomp: true) do |line|
        # Skip if the line is empty or a comment
        next if line.empty? || line[0] == '#'

        # parse the line to extract code point as integer and the name
        cp_int, _name = line.split(';')
        if cp_int.include?('..') # handle ranges in DerivedName.txt
          ucd_range = Utils::String.to_range(cp_int)
          next unless range.include_range?(ucd_range)

          counter += ucd_range.size
          next
        end
        cp_int = cp_int.chomp.to_i(16)
        next unless range.include?(cp_int)

        counter += 1
        break if cp_int == range.end
      end
      counter
    end

    # Find the block including the target character or code point, or matching the provided name.
    # @param block_arg [Integer|String] Decimal code point or standardized hexadecimal codepoint or string character (only one, so be careful with emojis, composed or joint characters using several units) or directly look for the block name (case insensitive).
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count?
    # @return [Hash|nil] Maching block (block name, range and count) or nil if not found
    # @example
    #   Unisec::Blocks.block(65, with_count:true) # => {range: 0..127, name: "Basic Latin", range_size: 128, char_count: 95}
    #   Unisec::Blocks.block("U+1f4a9") # => {range: 127744..128511, name: "Miscellaneous Symbols and Pictographs", range_size: nil, char_count: nil}
    #   Unisec::Blocks.block("…", with_count:true) # => {range: 8192..8303, name: "General Punctuation", range_size: 112, char_count: 111}
    #   Unisec::Blocks.block("javanese") # => {range: 43392..43487, name: "Javanese", range_size: nil, char_count: nil}
    def self.block(block_arg, with_count: false) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
      file = File.new(UCD_BLOCKS)
      found = false
      file.each_line(chomp: true) do |line|
        # Skip if the line is empty or a comment
        next if line.empty? || line[0] == '#'

        # parse the line to extract code point range and the name
        blk_range, blk_name = line.split(';')
        blk_range = Unisec::Utils::String.to_range(blk_range)
        blk_name.lstrip!
        case block_arg
        when Integer # block_arg is an intgeger code point
          found = true if blk_range.include?(block_arg)
        when String # can be a char or block name or a string code point
          if block_arg.size == 1 # is a char (1 code unit, not one grapheme)
            found = true if blk_range.include?(Utils::String.convert_to_integer(block_arg))
          elsif block_arg.start_with?('U+') # string code point
            found = true if blk_range.include?(Utils::String.stdhexcp2deccp(block_arg))
          elsif blk_name.downcase == block_arg.downcase # block name
            found = true
          end
        end
        if found
          return {
            range: blk_range,
            name: blk_name,
            range_size: with_count ? blk_range.size : nil,
            char_count: with_count ? count_char_in_block(blk_range) : nil
          }
        end
      end
      nil # not found
    end

    # Display a CLI-friendly output listing all blocks
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count?
    def self.list_display(with_count: false) # rubocop:disable Metrics/AbcSize
      blocks = list(with_count: with_count)
      display = ->(key, value, just) { print Paint[key, :red, :bold] + " #{value}".ljust(just) }
      blocks.each do |blk|
        display.call('Range:', Utils::Range.range2codepoint_range(blk[:range]), 22)
        display.call('Name:', blk[:name], 50)
        if with_count
          display.call('Range size:', blk[:range_size], 8)
          display.call('Char count:', blk[:char_count], 0)
        end
        puts
      end
      nil
    end

    # Display a CLI-friendly output detailing the searched block
    # @param block_arg [Integer|String] Decimal code point or standardized hexadecimal codepoint or string character (only one, so be careful with emojis, composed or joint characters using several units) or directly look for the block name (case insensitive).
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count?
    def self.block_display(block_arg, with_count: false)
      blk = block(block_arg, with_count: with_count)
      if blk.nil?
        puts "no block found with #{block_arg}"
      else
        display = ->(key, value) { puts Paint[key, :red, :bold] + " #{value}" }
        display.call('Range:', Utils::Range.range2codepoint_range(blk[:range]))
        display.call('Name:', blk[:name])
        if with_count
          display.call('Range size:', blk[:range_size])
          display.call('Char count:', blk[:char_count])
        end
      end
      nil
    end
  end
end
