# frozen_string_literal: false

require 'minitest/autorun'
require 'unisec'

class UnisecTest < Minitest::Test
  def test_unisec_properties_list
    assert_kind_of(Array, Unisec::Properties.list)
    assert_kind_of(String, Unisec::Properties.list.first)
  end

  def test_unisec_properties_codepoints
    cps = Unisec::Properties.codepoints('Quotation_Mark')
    assert_kind_of(Array, cps)
    assert_kind_of(Hash, cps.first)
    assert(cps.first.has_key?(:char))
    assert(cps.first.has_key?(:codepoint))
    assert(cps.first.has_key?(:name))
  end

  def test_unisec_properties_char
    data = Unisec::Properties.char('é')
    assert_kind_of(Hash, data)
    assert(data.has_key?(:age))
    assert(data.has_key?(:block))
    assert(data.has_key?(:category))
    assert(data.has_key?(:subcategory))
    assert(data.has_key?(:codepoint))
    assert(data.has_key?(:name))
    assert(data.has_key?(:script))
    assert(data.has_key?(:case))
    assert(data.has_key?(:normalization))
    assert(data.has_key?(:other_properties))
    assert_equal('LATIN SMALL LETTER E WITH ACUTE', data[:name])
    assert_equal('U+00E9', data[:codepoint])
  end
end
