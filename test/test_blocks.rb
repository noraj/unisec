# frozen_string_literal: false

require 'minitest/autorun'
require 'unisec'

class UnisecTest < Minitest::Test
  def test_unisec_blocks_ucd_blocks_version
    assert_match(/\A\d+\.\d+\.\d+\Z/, Unisec::Blocks.ucd_blocks_version)
  end

  def test_unisec_blocks_list
    list_default = Unisec::Blocks.list
    # type of output
    assert_kind_of(Array, list_default)
    assert_kind_of(Hash, list_default.first)
    # block properties
    assert_kind_of(Range, list_default.first[:range])
    assert_kind_of(String, list_default.first[:name])
    assert_nil(list_default.first[:range_size])
    assert_nil(list_default.first[:char_count])
    # no test with :with_count as it's too slow
  end

  def test_unisec_blocks_count_char_in_block
    assert_kind_of(Integer, Unisec::Blocks::count_char_in_block(0xAC00..0xD7AF))
  end

  def test_unisec_blocks_block
    # search by decimal code point with count
    a1 = Unisec::Blocks.block(65, with_count:true)
    assert_kind_of(Hash, a1)
    assert_kind_of(Range, a1[:range])
    assert_kind_of(String, a1[:name])
    assert_kind_of(Integer, a1[:range_size])
    assert_kind_of(Integer, a1[:char_count])
    # search by standardized hexadecimal code point without count
    a2 = Unisec::Blocks.block("U+1f4a9")
    assert_kind_of(Hash, a2)
    assert_kind_of(Range, a2[:range])
    assert_kind_of(String, a2[:name])
    assert_nil(a2[:range_size])
    assert_nil(a2[:char_count])
    # search by character with count
    a3 = Unisec::Blocks.block("…", with_count:true)
    assert_kind_of(Hash, a3)
    assert_kind_of(Range, a3[:range])
    assert_kind_of(String, a3[:name])
    assert_kind_of(Integer, a3[:range_size])
    assert_kind_of(Integer, a3[:char_count])
    # search by block name without count
    a4 = Unisec::Blocks.block("javanese")
    assert_kind_of(Hash, a4)
    assert_kind_of(Range, a4[:range])
    assert_kind_of(String, a4[:name])
    assert_nil(a4[:range_size])
    assert_nil(a4[:char_count])
    # search by block name with different casing
    assert_kind_of(Hash, Unisec::Blocks.block("Javanese"))
    assert_kind_of(Hash, Unisec::Blocks.block("JaVaNeSe"))
    # search by INVALID decimal code point
    assert_nil(Unisec::Blocks.block(900000))
    # search by INVALID standardized hexadecimal
    assert_nil(Unisec::Blocks.block('U+95874'))
    # search by INVALID character (e.g. several, composite, joint provided)
    assert_nil(Unisec::Blocks.block('🇫🇷'))
    # search by INVALID block name
    assert_nil(Unisec::Blocks.block('not existing'))
  end
end
