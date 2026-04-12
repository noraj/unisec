# frozen_string_literal: true

require 'ctf_party'
require 'paint'
require 'unisec/utils'

module Unisec
  # Normalization Forms
  class Normalization
    # HTML escapable characters mapped with their Unicode counterparts that will
    # cast to themself after applying normalization forms using compatibility mode.
    HTML_ESCAPE_BYPASS = {
      '<' => ['﹤', '＜'],
      '>' => ['﹥', '＞'],
      '"' => ['＂'],
      "'" => ['＇'],
      '&' => ['﹠', '＆']
    }.freeze

    # Original input
    # @return [String] untouched input
    attr_reader :original

    # Normalization Form C (NFC) - Canonical Decomposition, followed by Canonical Composition
    # @return [String] input normalized with NFC
    attr_reader :nfc

    # Normalization Form KC (NFKC) - Compatibility Decomposition, followed by Canonical Composition
    # @return [String] input normalized with NFKC
    attr_reader :nfkc

    # Normalization Form D (NFD) - Canonical Decomposition
    # @return [String] input normalized with NFD
    attr_reader :nfd

    # Normalization Form KD (NFKD) - Compatibility Decomposition
    # @return [String] input normalized with NFKD
    attr_reader :nfkd

    # Generate all normilzation forms for a given input
    # @param str [String] the target string
    # @return [nil]
    def initialize(str)
      @original = str
      @nfc = Normalization.nfc(str)
      @nfkc = Normalization.nfkc(str)
      @nfd = Normalization.nfd(str)
      @nfkd = Normalization.nfkd(str)
    end

    # Normalization Form C (NFC) - Canonical Decomposition, followed by Canonical Composition
    # @param str [String] the target string
    # @return [String] input normalized with NFC
    def self.nfc(str)
      str.unicode_normalize(:nfc)
    end

    # Normalization Form KC (NFKC) - Compatibility Decomposition, followed by Canonical Composition
    # @param str [String] the target string
    # @return [String] input normalized with NFKC
    def self.nfkc(str)
      str.unicode_normalize(:nfkc)
    end

    # Normalization Form D (NFD) - Canonical Decomposition
    # @param str [String] the target string
    # @return [String] input normalized with NFD
    def self.nfd(str)
      str.unicode_normalize(:nfd)
    end

    # Normalization Form KD (NFKD) - Compatibility Decomposition
    # @param str [String] the target string
    # @return [String] input normalized with NFKD
    def self.nfkd(str)
      str.unicode_normalize(:nfkd)
    end

    # Replace HTML escapable characters with their Unicode counterparts that will
    # cast to themself after applying normalization forms using compatibility mode.
    # Usefull for XSS, to bypass HTML escape.
    # If several values are possible, one is picked randomly.
    # @param str [String] the target string
    # @return [String] escaped input
    def self.replace_bypass(str)
      str = str.dup
      HTML_ESCAPE_BYPASS.each do |k, v|
        str.gsub!(k, v.sample)
      end
      str
    end

    # Instance version of {Normalization.replace_bypass}.
    def replace_bypass
      Normalization.replace_bypass(@original)
    end

    # Find the list of symbols that will transform into a given symbol after normalization
    # @param target [String]
    # @param forms [String|Symbol|Array<Symbol>]
    # @return [Hash] (results won't include input)
    # @example
    #   Unisec::Normalization.reverse_normalize('<') # => {nfc: [], nfd: [], nfkc: ["﹤", "＜"], nfkd: ["﹤", "＜"]}
    #   Unisec::Normalization.reverse_normalize('.', forms: [:nfkc, :nfkd]) # => {nfkc: ["․", "﹒", "．"], nfkd: ["․", "﹒", "．"]}
    #   Unisec::Normalization.reverse_normalize('ffi', forms: :nfkc) # => {nfkc: ["ﬃ"]}
    #   Unisec::Normalization.reverse_normalize('≯', forms: 'nfd') # => {nfd: ["≯"]}
    #   Unisec::Normalization.reverse_normalize('ô', forms: 'nfc,nfd') # => {nfc: [], nfd: []}
    def self.reverse_normalize(target, forms: %i[nfc nfd nfkc nfkd])
      forms = Utils::Arguments.to_array_of_sym(forms)
      result = {}
      forms.each do |form|
        result[form] = []
      end

      (0x000000..0x10FFFF).each do |codepoint|
        char = codepoint.chr(Encoding::UTF_8)
        forms.each do |form|
          result[form] << char if (char.unicode_normalize(form) == target) && (char != target)
        end
      rescue RangeError # skip UTF-16 surrogates and potential other invalid code points
        next
      end

      result
    end

    # Display a CLI-friendly output summurizing all normalization forms
    # @return [String] CLI-ready output
    # @example
    #   puts Unisec::Normalization.new("\u{1E9B 0323}").display
    #   # =>
    #   # Original: ẛ̣
    #   #   U+1E9B U+0323
    #   # NFC: ẛ̣
    #   #   U+1E9B U+0323
    #   # NFKC: ṩ
    #   #   U+1E69
    #   # NFD: ẛ̣
    #   #   U+017F U+0323 U+0307
    #   # NFKD: ṩ
    #   #   U+0073 U+0323 U+0307
    def display
      colorize = lambda { |form_title, form_attr|
        "#{Paint[form_title.to_s, :underline,
                 :bold]}: #{form_attr}\n  #{Paint[Unisec::Utils::String.chars2codepoints(form_attr), :red]}\n"
      }
      colorize.call('Original', @original) +
        colorize.call('NFC', @nfc) +
        colorize.call('NFKC', @nfkc) +
        colorize.call('NFD', @nfd) +
        colorize.call('NFKD', @nfkd)
    end

    # Display a CLI-friendly output of the XSS payload to bypass HTML escape and
    # what it does once normalized in NFKC & NFKD.
    # @return [String] CLI-ready output
    # @example
    #   $ puts Unisec::Normalization.new('<script>').display_replace
    #   # =>
    #   # Original: <script>
    #   #   U+003C U+0073 U+0063 U+0072 U+0069 U+0070 U+0074 U+003E
    #   # Bypass payload: ＜script＞
    #   #   U+FF1C U+0073 U+0063 U+0072 U+0069 U+0070 U+0074 U+FF1E
    #   # NFKC: <script>
    #   #   U+003C U+0073 U+0063 U+0072 U+0069 U+0070 U+0074 U+003E
    #   # NFKD: <script>
    #   #   U+003C U+0073 U+0063 U+0072 U+0069 U+0070 U+0074 U+003E
    def display_replace
      colorize = lambda { |form_title, form_attr|
        "#{Paint[form_title.to_s, :underline,
                 :bold]}: #{form_attr}\n  #{Paint[Unisec::Utils::String.chars2codepoints(form_attr), :red]}\n"
      }
      payload = replace_bypass
      colorize.call('Original', @original) +
        colorize.call('Bypass payload', payload) +
        colorize.call('NFKC', Normalization.nfkc(payload)) +
        colorize.call('NFKD', Normalization.nfkd(payload))
    end

    # Display a CLI-friendly output reverse normalization results
    # @param target [String] see {Unisec::Normalization.reverse_normalize}
    # @param forms [String|Symbol|Array<Symbol>] see {Unisec::Normalization.reverse_normalize}
    # @return [String] CLI-ready output
    # @example
    #   puts Unisec::Normalization.display_reverse_normalize('<')
    #   # =>
    #   # Original:
    #   #   < (U+003C)
    #   # NFKC
    #   #   ﹤ (U+FE64)
    #   #   ＜ (U+FF1C)
    #   # NFKD
    #   #   ﹤ (U+FE64)
    #   #   ＜ (U+FF1C)
    def self.display_reverse_normalize(target, forms: %i[nfc nfd nfkc nfkd]) # rubocop:disable Metrics/AbcSize
      colorize_form = ->(form_title) { Paint[form_title, :underline, :bold] }
      colorize_char = ->(char) { "  #{char} (#{Paint[Unisec::Utils::String.chars2codepoints(char), :red]})\n" }
      out = "#{colorize_form.call('Original')}:\n#{colorize_char.call(target)}"
      res = Unisec::Normalization.reverse_normalize(target, forms: forms) # => {nfc: [], nfd: [], nfkc: ["﹤", "＜"], nfkd: ["﹤", "＜"]}
      res.each_key do |k|
        next if res[k].empty?

        out += "#{colorize_form.call(k.to_s.upcase)}\n"
        res[k].each do |v|
          out += colorize_char.call(v)
        end
      end
      out
    end
  end
end
