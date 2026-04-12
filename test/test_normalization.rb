# frozen_string_literal: false

require 'minitest/autorun'
require 'unisec'

class UnisecTest < Minitest::Test
  def test_unisec_normalization
    assert_equal("\u{1E9B 0323}", Unisec::Normalization.nfc("\u{1E9B 0323}"))
    assert_equal("\u{1E69}", Unisec::Normalization.nfkc("\u{1E9B 0323}"))
    assert_equal("\u{017F 0323 0307}", Unisec::Normalization.nfd("\u{1E9B 0323}"))
    assert_equal("\u{0073 0323 0307}", Unisec::Normalization.nfkd("\u{1E9B 0323}"))
    assert_equal("\u{2126}", Unisec::Normalization.new("\u{2126}").original)

    payload = "<svg onload=\"alert('XSS')\">"
    assert_equal(payload, Unisec::Normalization.replace_bypass(payload).unicode_normalize(:nfkc))
  end

  def test_unisec_normalization_reverse_normalize
    # skip because it adds 15 seconds
    #assert_equal({nfc: [], nfd: [], nfkc: ["﹤", "＜"], nfkd: ["﹤", "＜"]}, Unisec::Normalization.reverse_normalize('<'))
    #assert_equal({nfkc: ["․", "﹒", "．"], nfkd: ["․", "﹒", "．"]}, Unisec::Normalization.reverse_normalize('.', forms: [:nfkc, :nfkd]))
    #assert_equal({nfkc: ["ﬃ"]}, Unisec::Normalization.reverse_normalize('ffi', forms: :nfkc))
    #assert_equal({nfd: ["≯"]}, Unisec::Normalization.reverse_normalize('≯', forms: 'nfd'))
    #assert_equal({nfc: [], nfd: []}, Unisec::Normalization.reverse_normalize('ô', forms: 'nfc,nfd'))
  end
end
