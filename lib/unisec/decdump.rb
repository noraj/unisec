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
    #   ded.utf8 # => "TODO"
    #   ded.utf16be # => "TODO"
    #   ded.utf32be # => "TODO"
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
    #   Unisec::Decdump.utf8('🐋') # => "TODO"
    # @todo add padding when suported in ctf-time
    def self.utf8(str)
      str.encode('UTF-8').to_hex.scan(/.{2}/).map(&:hex2dec).join(' ')
    end

    # Encode to UTF-16BE in decdump format (packed by code unit = every 2 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-16BE encoded)
    # @example
    #   Unisec::Decdump.utf16be('🐋') # => "TODO"
    # @todo add padding when suported in ctf-time
    def self.utf16be(str)
      str.encode('UTF-16BE').to_hex.scan(/.{2}/).map(&:hex2dec).join(' ').scan(/\d+ \d+/).map { |x| "|#{x}|" }.join(' ')
    end

    # Encode to UTF-16LE in decdump format (packed by code unit = every 2 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-16LE encoded)
    # @example
    #   Unisec::Decdump.utf16le('🐋') # => "TODO"
    # @todo add padding when suported in ctf-time
    def self.utf16le(str)
      str.encode('UTF-16LE').to_hex.scan(/.{2}/).map(&:hex2dec).join(' ').scan(/\d+ \d+/).map { |x| "|#{x}|" }.join(' ')
    end

    # Encode to UTF-32BE in decdump format (packed by code unit = every 4 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-32BE encoded)
    # @example
    #   Unisec::Decdump.utf32be('🐋') # => "TODO"
    # @todo add padding when suported in ctf-time
    def self.utf32be(str)
      str.encode('UTF-32BE').to_hex.scan(/.{2}/).map(&:hex2dec).join(' ').scan(/\d+ \d+ \d+ \d+/).map do |x|
        "|#{x}|"
      end.join(' ')
    end

    # Encode to UTF-32LE in decdump format (packed by code unit = every 4 bytes)
    # @param str [String] Input string to encode
    # @return [String] decdump (UTF-32LE encoded)
    # @example
    #   Unisec::Decdump.utf32le('🐋') # => "TODO"
    # @todo add padding when suported in ctf-time
    def self.utf32le(str)
      str.encode('UTF-32LE').to_hex.scan(/.{2}/).map(&:hex2dec).join(' ').scan(/\d+ \d+ \d+ \d+/).map do |x|
        "|#{x}|"
      end.join(' ')
    end

    # Display a CLI-friendly output summurizing the decdump in all Unicode encodings
    # @return [String] CLI-ready output
    # @example
    #   puts Unisec::Decdump.new('K').display # =>
    #   # UTF-8: TODO
    #   # UTF-16BE: TODO
    #   # UTF-16LE: TODO
    #   # UTF-32BE: TODO
    #   # UTF-32LE: TODO
    def display
      "UTF-8: #{@utf8}\n" \
      "UTF-16BE: #{@utf16be}\n" \
      "UTF-16LE: #{@utf16le}\n" \
      "UTF-32BE: #{@utf32be}\n" \
      "UTF-32LE: #{@utf32le}".gsub('|', Paint['|', :red])
    end
  end
end
