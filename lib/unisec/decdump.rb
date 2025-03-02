# frozen_string_literal: true

require 'ctf_party'
require 'paint'

module Unisec
  # Decimal dump (decdump) of all Unicode encodings.
  class Decdump
    # UTF-8 decdump
    # @return [String] UTF-8 decdump
    attr_reader :utf8

    # UTF-16BE decdump
    # @return [String] UTF-16BE decdump
    attr_reader :utf16be

    # UTF-16LE decdump
    # @return [String] UTF-16LE decdump
    attr_reader :utf16le

    # UTF-32BE decdump
    # @return [String] UTF-32BE decdump
    attr_reader :utf32be

    # UTF-32LE decdump
    # @return [String] UTF-32LE decdump
    attr_reader :utf32le

    # Init the decdump.
    # @param str [String] Input string to encode
    # @example
    #   ded = Unisec::Decdump.new('I 💕 Ruby 💎')
    #   ded.utf8 # => "073 032 240 159 146 149 032 082 117 098 121 032 240 159 146 142"
    #   ded.utf16be # => "|000 073| |000 032| |216 061| |220 149| |000 032| |000 082| |000 117| |000 098| |000 121| |000 032| |216 061| |220 142|"
    #   ded.utf32be # => "|000 000 000 073| |000 000 000 032| |000 001 244 149| |000 000 000 032| |000 000 000 082| |000 000 000 117| |000 000 000 098| |000 000 000 121| |000 000 000 032| |000 001 244 142|"
    def initialize(str)
      @utf8 = Decdump.utf8(str)
      @utf16be = Decdump.utf16be(str)
      @utf16le = Decdump.utf16le(str)
      @utf32be = Decdump.utf32be(str)
      @utf32le = Decdump.utf32le(str)
    end

    # Encode to UTF-8 in decdump format (spaced at every code unit = every byte)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-8 encoded)
    # @example
    #   Unisec::Decdump.utf8('🐋') # => "240 159 144 139"
    def self.utf8(str)
      str.encode('UTF-8').to_hex.scan(/.{2}/).map { |x| x.hex2dec(padding: 3) }.join(' ')
    end

    # Encode to UTF-16BE in decdump format (packed by code unit = every 2 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-16BE encoded)
    # @example
    #   Unisec::Decdump.utf16be('🐋') # => "|216 061| |220 011|"
    def self.utf16be(str)
      dec_chuncks = str.encode('UTF-16BE').to_hex.scan(/.{2}/).map do |x|
        x.hex2dec(padding: 3)
      end
      dec_chuncks.join(' ').scan(/\d+ \d+/).map { |x| "|#{x}|" }.join(' ')
    end

    # Encode to UTF-16LE in decdump format (packed by code unit = every 2 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-16LE encoded)
    # @example
    #   Unisec::Decdump.utf16le('🐋') # => "|061 216| |011 220|"
    def self.utf16le(str)
      dec_chuncks = str.encode('UTF-16LE').to_hex.scan(/.{2}/).map do |x|
        x.hex2dec(padding: 3)
      end
      dec_chuncks.join(' ').scan(/\d+ \d+/).map { |x| "|#{x}|" }.join(' ')
    end

    # Encode to UTF-32BE in decdump format (packed by code unit = every 4 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-32BE encoded)
    # @example
    #   Unisec::Decdump.utf32be('🐋') # => "|000 001 244 011|"
    def self.utf32be(str)
      dec_chuncks = str.encode('UTF-32BE').to_hex.scan(/.{2}/).map do |x|
        x.hex2dec(padding: 3)
      end
      dec_chuncks.join(' ').scan(/\d+ \d+ \d+ \d+/).map { |x| "|#{x}|" }.join(' ')
    end

    # Encode to UTF-32LE in decdump format (packed by code unit = every 4 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-32LE encoded)
    # @example
    #   Unisec::Decdump.utf32le('🐋') # => "|011 244 001 000|"
    def self.utf32le(str)
      dec_chuncks = str.encode('UTF-32LE').to_hex.scan(/.{2}/).map do |x|
        x.hex2dec(padding: 3)
      end
      dec_chuncks.join(' ').scan(/\d+ \d+ \d+ \d+/).map { |x| "|#{x}|" }.join(' ')
    end

    # Display a CLI-friendly output summurizing the decdump in all Unicode encodings
    # @return [String] CLI-ready output
    # @example
    #   puts Unisec::Decdump.new('K').display # =>
    #   # UTF-8: 226 132 170
    #   # UTF-16BE: |033 042|
    #   # UTF-16LE: |042 033|
    #   # UTF-32BE: |000 000 033 042|
    #   # UTF-32LE: |042 033 000 000|
    def display
      "UTF-8: #{@utf8}\n" \
      "UTF-16BE: #{@utf16be}\n" \
      "UTF-16LE: #{@utf16le}\n" \
      "UTF-32BE: #{@utf32be}\n" \
      "UTF-32LE: #{@utf32le}".gsub('|', Paint['|', :red])
    end
  end
end
