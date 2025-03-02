# frozen_string_literal: false

require 'minitest/autorun'
require 'unisec'

class UnisecTest < Minitest::Test
  def test_unisec_decdump_utf8
    assert_equal('240 159 166 147', Unisec::Decdump.utf8('🦓'))
    assert_equal('240 159 167 145 226 128 141 240 159 154 128 032 103 111 101 115 032 105 110 032 240 159 154 128 226 156 168', Unisec::Decdump.utf8('🧑‍🚀 goes in 🚀✨'))
  end

  def test_unisec_decdump_utf16be
    assert_equal('|216 062| |221 147|', Unisec::Decdump.utf16be('🦓'))
    assert_equal('|216 062| |221 209| |032 013| |216 061| |222 128| |000 032| |000 103| |000 111| |000 101| |000 115| |000 032| |000 105| |000 110| |000 032| |216 061| |222 128| |039 040|', Unisec::Decdump.utf16be('🧑‍🚀 goes in 🚀✨'))
  end

  def test_unisec_decdump_utf16le
    assert_equal('|062 216| |147 221|', Unisec::Decdump.utf16le('🦓'))
    assert_equal('|062 216| |209 221| |013 032| |061 216| |128 222| |032 000| |103 000| |111 000| |101 000| |115 000| |032 000| |105 000| |110 000| |032 000| |061 216| |128 222| |040 039|', Unisec::Decdump.utf16le('🧑‍🚀 goes in 🚀✨'))
  end

  def test_unisec_decdump_utf32be
    assert_equal('|000 001 249 147|', Unisec::Decdump.utf32be('🦓'))
    assert_equal('|000 001 249 209| |000 000 032 013| |000 001 246 128| |000 000 000 032| |000 000 000 103| |000 000 000 111| |000 000 000 101| |000 000 000 115| |000 000 000 032| |000 000 000 105| |000 000 000 110| |000 000 000 032| |000 001 246 128| |000 000 039 040|', Unisec::Decdump.utf32be('🧑‍🚀 goes in 🚀✨'))
  end

  def test_unisec_decdump_utf32le
    assert_equal('|147 249 001 000|', Unisec::Decdump.utf32le('🦓'))
    assert_equal('|209 249 001 000| |013 032 000 000| |128 246 001 000| |032 000 000 000| |103 000 000 000| |111 000 000 000| |101 000 000 000| |115 000 000 000| |032 000 000 000| |105 000 000 000| |110 000 000 000| |032 000 000 000| |128 246 001 000| |040 039 000 000|', Unisec::Decdump.utf32le('🧑‍🚀 goes in 🚀✨'))
  end
end
