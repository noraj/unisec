# frozen_string_literal: false

require 'minitest/autorun'
require 'unisec'

class UnisecTest < Minitest::Test
  def test_unisec_planes_list
    list_default = Unisec::Planes.list
    # type of output
    assert_kind_of(Array, list_default)
    assert_kind_of(Hash, list_default.first)
    # plane properties
    assert_kind_of(Range, list_default.first[:range])
    assert_kind_of(String, list_default.first[:name])
    assert_kind_of(Array, list_default.first[:blocks])
    assert_kind_of(Hash, list_default.first[:blocks].first)
    # block properties
    assert_kind_of(Range, list_default.first[:blocks].first[:range])
    assert_kind_of(String, list_default.first[:blocks].first[:name])
    assert_nil(list_default.first[:blocks].first[:range_size])
    assert_nil(list_default.first[:blocks].first[:char_count])
    # no test with :with_count as it's too slow
  end

  def test_unisec_planes_plane
    # search by plane number
    a1 = Unisec::Planes.plane(3)
    assert_kind_of(Hash, a1)
    assert_kind_of(Range, a1[:range])
    assert_kind_of(String, a1[:name])
    assert_kind_of(Array, a1[:blocks])
    assert_kind_of(Hash, a1[:blocks].first)
    assert_kind_of(Range, a1[:blocks].first[:range])
    assert_kind_of(String, a1[:blocks].first[:name])
    assert_nil(a1[:blocks].first[:range_size])
    assert_nil(a1[:blocks].first[:char_count])
    # search by plane name
    a2 = Unisec::Planes.plane('Supplementary Ideographic Plane')
    assert_kind_of(Hash, a2)
    assert_kind_of(Range, a2[:range])
    assert_kind_of(String, a2[:name])
    assert_kind_of(Array, a2[:blocks])
    assert_kind_of(Hash, a2[:blocks].first)
    # search by plane name with different casing
    a3 = Unisec::Planes.plane('SuPPlemENtary IdeogrAPhic PlAne')
    assert_kind_of(String, a3[:name])
    # search by plane name with several results
    a4 = Unisec::Planes.plane('unassigned')
    assert_kind_of(Array, a4)
    assert_kind_of(Range, a4.first[:range])
    assert_kind_of(String, a4.first[:name])
    assert_kind_of(Array, a4.first[:blocks])
    assert_empty(a4.first[:blocks]) # unassigned planes should be empty
    # search by INVALID plane number
    assert_nil(Unisec::Planes.plane(18))
    # search by INVALID plane name
    assert_nil(Unisec::Planes.plane('invalid name'))
    # search by INVALID argument type
    assert_raises(ArgumentError) { Unisec::Planes.plane({test: 'a'}) }
    # no test with :with_count as it's too slow
  end

  def test_unisec_planes_plane2blocks
    # not used alone, only called from plane()
  end

  def test_unisec_planes_abbr
    assert_equal('BMP', Unisec::Planes.abbr('Basic Multilingual Plane'))
    assert_equal('PUA', Unisec::Planes.abbr('supplement­ary Private Use Area planes'))
  end
end
