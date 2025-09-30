# frozen_string_literal: true

require 'paint'
require 'unisec/utils'

module Unisec
  class Blocks
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
    # @return [Array<Hash>] blocks name, range and count
    # @example
    #   Unisec::Blocks.list # => FIXME
    def self.list
      raise NotImplementedError
    end

    # Display a CLI-friendly output listing all blocks
    def self.char_display
      raise NotImplementedError
    end
  end
end
