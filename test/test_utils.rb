# frozen_string_literal: false

require 'minitest/autorun'
require 'unisec'

class UnisecTest < Minitest::Test
  def test_unisec_utils_string_char2codepoint
    assert_equal('U+00E9', Unisec::Utils::String.char2codepoint('é'))
    assert_equal('U+0041', Unisec::Utils::String.char2codepoint('AZ'))
  end

  def test_unisec_utils_string_chars2codepoints
    assert_equal('U+00E9', Unisec::Utils::String.chars2codepoints('é'))
    assert_equal('U+0041 U+005A', Unisec::Utils::String.chars2codepoints('AZ'))
  end

  def test_unisec_utils_integer_deccp2stdhexcp
    assert_equal('U+1F680', Unisec::Utils::Integer.deccp2stdhexcp(128640))
    assert_equal('U+0020', Unisec::Utils::Integer.deccp2stdhexcp(32))
  end

  def test_unisec_utils_string_grapheme_reverse
    assert_equal('🇫🇷🐓', Unisec::Utils::String.grapheme_reverse('🐓🇫🇷'))
  end

  def test_unisec_utils_string_convert
    assert_equal(128169, Unisec::Utils::String.convert('0x1f4a9', :integer))
    assert_equal(128169, Unisec::Utils::String.convert('0d128169', :integer))
    assert_equal(128169, Unisec::Utils::String.convert('0b11111010010101001', :integer))
    assert_equal(128169, Unisec::Utils::String.convert('💩', :integer))
  end

  def test_unisec_utils_string_to_range
    assert_equal(128..255, Unisec::Utils::String::to_range('0080..00FF'))
  end

  def test_unisec_utils_string_stdhexcp2deccp
    assert_equal(8230, Unisec::Utils::String.stdhexcp2deccp('U+2026'))
  end

  def test_unisec_utils_range_range2codepoint_range
    assert_equal("U+100000 - U+10FFFF", Unisec::Utils::Range.range2codepoint_range(1048576..1114111))
  end

  def test_unisec_utils_to_hex
    assert_equal('2A', 42.to_hex)
  end

  def test_unisec_utils_to_bin
    assert_equal('101010', 42.to_bin)
  end

  def test_unisec_utils_to_bool
    assert_equal(true, "true".to_bool)
  end

  def test_unisec_utils_include_range?
    assert_equal(false, (1..10).include_range?(2..11))
    assert_equal(true, (1..10).include_range?(2..4))
  end
end
