# frozen_string_literal: true

require 'ctf_party'

class Integer
  # Convert an integer to an hexadecimal string
  # @return [String] The interger converted to hexadecimal and casted to an upper case string
  # @example
  #   42.to_hex # => "2A"
  def to_hex
    to_s(16).upcase
  end

  # Convert an integer to an binary string
  # @return [String] The interger converted to binary and casted to a string
  # @example
  #   42.to_bin # => "101010"
  def to_bin
    to_s(2)
  end
end

module Unisec
  # Generic stuff not Unicode-related that can be re-used.
  module Utils
    # About string conversion and manipulation.
    module String
      # Convert a string input into the chosen type.
      # @param input [String] If the target type is `:integer`, the string must represent a number encoded in
      #   hexadecimal, decimal, binary. If it's a Unicode string, only the first code point will be taken into account.
      # @param target_type [Symbol] Convert to the chosen type. Currently only supports `:integer`.
      # @return [Variable] The type of the output depends on the chosen `target_type`.
      # @example
      #   Unisec::Utils::String.convert('0x1f4a9', :integer) # => 128169
      def self.convert(input, target_type)
        case target_type
        when :integer
          convert_to_integer(input)
        else
          raise TypeError, "Target type \"#{target_type}\" not avaible"
        end
      end

      # Internal method used for {.convert}.
      #
      # Convert a string input into integer.
      # @param input [String] The string must represent a number encoded in hexadecimal, decimal, binary. If it's a
      #   Unicode string, only the first code point will be taken into account. The input type is determined
      #   automatically based on the prefix.
      # @return [Integer]
      # @example
      #   # Hexadecimal
      #   Unisec::Utils::String.convert_to_integer('0x1f4a9') # => 128169
      #   # Decimal
      #   Unisec::Utils::String.convert_to_integer('0d128169') # => 128169
      #   # Binary
      #   Unisec::Utils::String.convert_to_integer('0b11111010010101001') # => 128169
      #   # Unicode string
      #   Unisec::Utils::String.convert_to_integer('💩') # => 128169
      def self.convert_to_integer(input)
        case autodetect(input)
        when :hexadecimal
          input.hex2dec(prefix: '0x').to_i
        when :decimal
          input.to_i
        when :binary
          input.bin2hex.hex2dec.to_i
        when :string
          input.codepoints.first
        else
          raise TypeError, "Input \"#{input}\" is not of the expected type"
        end
      end

      # Internal method used for {.convert}.
      #
      # Autodetect the representation type of the string input.
      # @param str [String] Input.
      # @return [Symbol] the detected type: `:hexadecimal`, `:decimal`, `:binary`, `:string`.
      # @example
      #   # Hexadecimal
      #   Unisec::Utils::String.autodetect('0x1f4a9') # => :hexadecimal
      #   # Decimal
      #   Unisec::Utils::String.autodetect('0d128169') # => :decimal
      #   # Binary
      #   Unisec::Utils::String.autodetect('0b11111010010101001') # => :binary
      #   # Unicode string
      #   Unisec::Utils::String.autodetect('💩') # => :string
      def self.autodetect(str)
        case str
        when /0x[0-9a-fA-F]/
          :hexadecimal
        when /0d[0-9]+/
          :decimal
        when /0b[0-1]+/
          :binary
        else
          :string
        end
      end

      # Reverse a string by graphemes (not by code points)
      # @return [String] the reversed string
      # @example
      #   b = "\u{1f1eb}\u{1f1f7}\u{1F413}" # => "🇫🇷🐓"
      #   b.reverse # => "🐓🇷🇫"
      #   Unisec::Utils::String.grapheme_reverse(b) # => "🐓🇫🇷"
      def self.grapheme_reverse(str)
        str.grapheme_clusters.reverse.join
      end

      # Display the code point in Unicode format for a given character (code point as string)
      # @param chr [String] Unicode code point (as character / string)
      # @return [String] code point in Unicode format
      # @example
      #   Unisec::Properties.char2codepoint('💎') # => "U+1F48E"
      def self.char2codepoint(chr)
        Integer.deccp2stdhexcp(chr.codepoints.first)
      end

      # Display the code points in Unicode format for the given characters (code points as string)
      # @param chrs [String] Unicode code points (as characters / string)
      # @return [String] code points in Unicode format
      # @example
      #   Unisec::Properties.chars2codepoints("ỳ́") # => "U+0079 U+0300 U+0301"
      #   Unisec::Properties.chars2codepoints("🧑‍🌾") # => "U+1F9D1 U+200D U+1F33E"
      def self.chars2codepoints(chrs)
        out = []
        chrs.each_char do |chr|
          out << char2codepoint(chr)
        end
        out.join(' ')
      end
    end

    module Integer
      # Convert from decimal code point to standardized format hexadecimal code point
      # @param int_cp [Integer] Code point in decimal format
      # @return [String] code point in Unicode format
      # @example
      #   Unisec::Utils::Integer.deccp2stdhexcp(128640) # => "U+1F680"
      def self.deccp2stdhexcp(int_cp)
        "U+#{format('%.4x', int_cp).upcase}"
      end
    end
  end
end
