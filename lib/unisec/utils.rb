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

class String
  # Convert a string to a boolean
  # @return [TrueClass|FalseClass]
  # @example
  #   "true".to_bool # => true
  def to_bool
    case to_s.chomp.downcase
    when 'true', 'yes', 'y', '1'
      true
    when 'false', 'no', 'n', '0'
      false
    else
      raise ArgumentError, "invalid value for Boolean: #{str.inspect}"
    end
  end
end

class Range
  # Is a range included in another range? Are all values of range B included in range A?
  # @param range [Range]
  # @return [TrueClass|FalseClass]
  # @example
  #   (1..10).include_range?(2..11) # => false
  #   (1..10).include_range?(2..4) # => true
  def include_range?(range)
    self.begin <= range.begin && self.end >= range.end
  end
end

module Unisec
  # Generic stuff not Unicode-related that can be re-used.
  module Utils
    # About string conversion and manipulation.
    module String
      # Convert a string input into the chosen type.
      # @param input [String] If the input is a Unicode string, only the first code point will be taken into account.
      #   The input must represent a character encoded in hexadecimal, decimal, binary or standard code point format.
      #   See {convert_to_integer} and {convert_to_char} for detailed examples.
      # @param target_type [Symbol] Convert to the chosen type. Currently only supports `:integer` and `:char`.
      # @return [Variable] The type of the output depends on the chosen `target_type`.
      # @example
      #   Unisec::Utils::String.convert('0x1f4a9', :integer) # => 128169
      #   Unisec::Utils::String.convert('0x1f4a9', :char) # => "💩"
      def self.convert(input, target_type)
        case target_type
        when :integer
          convert_to_integer(input)
        when :char
          convert_to_char(input)
        else
          raise TypeError, "Target type \"#{target_type}\" not avaible"
        end
      end

      # Internal method used for {convert}.
      #
      # Convert a string input into integer.
      # @param input [String] If the input is a Unicode string, only the first code point will be taken into account.
      #   The input must represent a character encoded in hexadecimal, decimal, binary, standard code point format.
      #   The input type is determined automatically based on the prefix.
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
      #   # Standardized format of hexadecimal code point
      #   Unisec::Utils::String.convert_to_integer('U+1F4A9') # => 128169
      def self.convert_to_integer(input)
        case autodetect(input)
        when :hexadecimal
          input.hex2dec(prefix: '0x').to_i
        when :stdcp
          input.hex2dec(prefix: 'U+').to_i
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

      # Internal method used for {convert}.
      #
      # Convert a string input into a character.
      # @param input [String] If the input is a Unicode string, only the first code point will be taken into account.
      #   The input must represent a character encoded in hexadecimal, decimal, binary, standard code point format.
      #   The input type is determined automatically based on the prefix.
      # @return [String]
      # @example
      #   # Hexadecimal
      #   Unisec::Utils::String.convert_to_char('0x1f4a9') # => "💩"
      #   # Decimal
      #   Unisec::Utils::String.convert_to_char('0d128169') # => "💩"
      #   # Binary
      #   Unisec::Utils::String.convert_to_char('0b11111010010101001') # => "💩"
      #   # Unicode string
      #   Unisec::Utils::String.convert_to_char('💩') # => "💩"
      #   # Standardized format of hexadecimal code point
      #   Unisec::Utils::String.convert_to_char('U+1F4A9') # => "💩"
      def self.convert_to_char(input)
        case autodetect(input)
        when :hexadecimal, :stdcp, :decimal, :binary, :string
          [convert(input, :integer)].pack('U')
        else
          raise TypeError, "Input \"#{input}\" is not of the expected type"
        end
      end

      # Internal method used for {.convert}.
      #
      # Autodetect the representation type of the string input.
      # @param str [String] Input.
      # @return [Symbol] the detected type: `:hexadecimal`, `:decimal`, `:binary`, `:string`, :stdcp.
      # @example
      #   # Hexadecimal
      #   Unisec::Utils::String.autodetect('0x1f4a9') # => :hexadecimal
      #   # Decimal
      #   Unisec::Utils::String.autodetect('0d128169') # => :decimal
      #   # Binary
      #   Unisec::Utils::String.autodetect('0b11111010010101001') # => :binary
      #   # Unicode string
      #   Unisec::Utils::String.autodetect('💩') # => :string
      #   # Standardized format of hexadecimal code point
      #   Unisec::Utils::String.autodetect('U+1F4A9') # => :stdcp
      def self.autodetect(str)
        case str
        when /0x[0-9a-fA-F]+/
          :hexadecimal
        when /U\+[0-9A-F]+/
          :stdcp
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
      # @todo Replace this method by target type :stdcp in String.convert()
      # @example
      #   Unisec::Utils::String.char2codepoint('💎') # => "U+1F48E"
      def self.char2codepoint(chr)
        Integer.deccp2stdhexcp(chr.codepoints.first)
      end

      # Display the code points in Unicode format for the given characters (code points as string)
      # @param chrs [String] Unicode code points (as characters / string)
      # @return [String] code points in Unicode format
      # @example
      #   Unisec::Utils::String.chars2codepoints("ỳ́") # => "U+0079 U+0300 U+0301"
      #   Unisec::Utils::String.chars2codepoints("🧑‍🌾") # => "U+1F9D1 U+200D U+1F33E"
      def self.chars2codepoints(chrs)
        out = []
        chrs.each_char do |chr|
          out << char2codepoint(chr)
        end
        out.join(' ')
      end

      # Display the code points in integer format for the given characters (code points as string)
      # @param chrs [String] Unicode code points (as characters / string)
      # @return [String] code points in integer format
      # @example
      #   Unisec::Utils::String.chars2intcodepoints('I 💕 Ruby 💎') # => "73 32 128149 32 82 117 98 121 32 128142"
      def self.chars2intcodepoints(chrs)
        chrs.codepoints.join(' ')
      end

      # Convert a string of hex encoded Unicode code points range to actual
      # integer Ruby range.
      # @param range_str [String] Unicode code points range as in data/Blocks.txt
      # @return [Range]
      # @example
      #   Unisec::Utils::String::to_range('0080..00FF') # => 128..255
      def self.to_range(range_str)
        ::Range.new(*range_str.split('..').map { |x| x.hex2dec.to_i })
      end
    end

    module Integer
      # Convert from decimal code point to standardized format hexadecimal code point
      # @param int_cp [Integer] Code point in decimal format
      # @return [String] code point in Unicode format
      # @todo Replace this method by the Integer.convert()
      # @example
      #   Unisec::Utils::Integer.deccp2stdhexcp(128640) # => "U+1F680"
      def self.deccp2stdhexcp(int_cp)
        "U+#{format('%.4x', int_cp).upcase}"
      end
    end

    module Range
      # Convert a (integer) range to a range of Unicode code points
      # @param range [::Range]
      # @return [::String]
      # @example
      #   Unisec::Utils::Range.range2codepoint_range(1048576..1114111) # => "U+100000 - U+10FFFF"
      def self.range2codepoint_range(range)
        "#{Integer.deccp2stdhexcp(range.begin)} - #{Integer.deccp2stdhexcp(range.end)}"
      end
    end

    module Arguments
      # Converts an argument that is a string, a string of arguments separated by comma, a symbol to an array of symbol.
      # Useful for methods that are expected to work on array of symbols but can receive various format of imputs (e.g. from CLI).
      # @param input [::String|Symbol] (anything else will be returned untransformed)
      # @return [Array<Symbol>] (or anything else if input type is not respected)
      # @example
      #   Unisec::Utils::Arguments.to_array_of_sym("arg") # => [:arg]
      #   Unisec::Utils::Arguments.to_array_of_sym("a,b,c") # => [:a, :b, :c]
      #   Unisec::Utils::Arguments.to_array_of_sym(:snake) # => [:snake]
      #   Unisec::Utils::Arguments.to_array_of_sym([:a, :b, :c]) # => [:a, :b, :c]
      def self.to_array_of_sym(input)
        case input
        when ::String # a,b,c => [:a, :b, :c]
          input.split(',').map(&:to_sym)
        when ::Symbol # :a => [:a]
          [input]
        else
          input
        end
      end

      # Converts encoding name from CLI to encoding name in standard format or Ruby Class
      # @param argenc [::String] Encoding name as used as argument in Unisec CLI (authorized values are: utf8 utf16be utf16le utf32be utf32le).
      # @param target [::String] 'standard' for standard encoding name, 'class' for Ruby class naming
      # @return [::String|Class]
      # @example
      #   Unisec::Utils::Arguments.argenc2enc('utf8', target: 'standard') # => "UTF-8"
      #   Unisec::Utils::Arguments.argenc2enc('utf16be', target: 'class') # => #<Encoding:UTF-16BE (autoload)>
      def self.argenc2enc(argenc, target: 'standard')
        argument_encodings = %w[utf8 utf16be utf16le utf32be utf32le]
        raise ArgumentError unless argument_encodings.include?(argenc)

        if target == 'standard'
          argenc.upcase.insert(3, '-')
        elsif target == 'class'
          Encoding.const_get(argenc.upcase.insert(3, '_')) # const_get safe thanks to input whitelist
        else
          raise ArgumentError
        end
      end
    end
  end
end
