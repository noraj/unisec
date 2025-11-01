# frozen_string_literal: true

require 'paint'
require 'unisec/utils'

module Unisec
  class Planes
    # Data about the planes
    PLANES = [
      { range: 0x0..0xffff, name: 'Basic Multilingual Plane' },
      { range: 0x10000..0x1ffff, name: 'Supplementary Multilingual Plane' },
      { range: 0x20000..0x2ffff, name: 'Supplementary Ideographic Plane' },
      { range: 0x30000..0x3ffff, name: 'Tertiary Ideographic Plane' },
      { range: 0x40000..0x4ffff, name: 'unassigned' },
      { range: 0x50000..0x5ffff, name: 'unassigned' },
      { range: 0x60000..0x6ffff, name: 'unassigned' },
      { range: 0x70000..0x7ffff, name: 'unassigned' },
      { range: 0x80000..0x8ffff, name: 'unassigned' },
      { range: 0x90000..0x9ffff, name: 'unassigned' },
      { range: 0xa0000..0xaffff, name: 'unassigned' },
      { range: 0xb0000..0xbffff, name: 'unassigned' },
      { range: 0xc0000..0xcffff, name: 'unassigned' },
      { range: 0xd0000..0xdffff, name: 'unassigned' },
      { range: 0xe0000..0xeffff, name: 'Supplement­ary Special-purpose Plane' },
      { range: 0xf0000..0xfffff, name: 'supplement­ary Private Use Area planes' },
      { range: 0x100000..0x10ffff, name: 'supplement­ary Private Use Area planes' }
    ].freeze

    # List Unicode planes name
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count? (warning: very slow, very unoptimized, see {Unisec::Blocks.list})
    # @return [Array<Hash>] blocks name, range and character and blocks count
    #   as well as abbreviation
    # @example
    #   Unisec::Planes.list # => FIXME
    def self.list(with_count: false)
      PLANES.zip(plane2blocks(PLANES, with_count: with_count)).map do |base, extra|
        base.merge(blocks: extra)
      end
    end

    # List details about target plane including the list of associated blocks
    # @param plane_arg [String|Integer] name or number of the plane
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count? (see {Unisec::Blocks.list})
    # @return [Hash|Array<Hash>|nil] nil if no match, Hash of the plane if one match,
    #   Array of planes' Hash if several matches
    # @example
    #   Unisec::Planes.plane(4) # =>
    #   # {range: 196608..262143,
    #   #  name: "unassigned",
    #   #  blocks:
    #   #   [{range: 196608..201551, name: "CJK Unified Ideographs Extension G", range_size: nil, char_count: nil},
    #   #    {range: 201552..205743, name: "CJK Unified Ideographs Extension H", range_size: nil, char_count: nil},
    #   #    {range: 205744..210047, name: "CJK Unified Ideographs Extension J", range_size: nil, char_count: nil}]}
    #   Unisec::Planes.plane('Supplementary Ideographic Plane') # =>
    #   # {range: 131072..196607,
    #   #  name: "Supplementary Ideographic Plane",
    #   #  blocks:
    #   #   [{range: 131072..173791, name: "CJK Unified Ideographs Extension B", range_size: nil, char_count: nil},
    #   #    {range: 173824..177983, name: "CJK Unified Ideographs Extension C", range_size: nil, char_count: nil},
    #   #    {range: 177984..178207, name: "CJK Unified Ideographs Extension D", range_size: nil, char_count: nil},
    #   #    {range: 178208..183983, name: "CJK Unified Ideographs Extension E", range_size: nil, char_count: nil},
    #   #    {range: 183984..191471, name: "CJK Unified Ideographs Extension F", range_size: nil, char_count: nil},
    #   #    {range: 191472..192095, name: "CJK Unified Ideographs Extension I", range_size: nil, char_count: nil},
    #   #    {range: 194560..195103, name: "CJK Compatibility Ideographs Supplement", range_size: nil, char_count: nil}]}
    #   Unisec::Planes.plane('unassigned') # =>
    #   # [{range: 262144..327679, name: "unassigned", blocks: []},
    #   #  {range: 327680..393215, name: "unassigned", blocks: []},
    #   #  {range: 393216..458751, name: "unassigned", blocks: []},
    #   #  {range: 458752..524287, name: "unassigned", blocks: []},
    #   #  {range: 524288..589823, name: "unassigned", blocks: []},
    #   #  {range: 589824..655359, name: "unassigned", blocks: []},
    #   #  {range: 655360..720895, name: "unassigned", blocks: []},
    #   #  {range: 720896..786431, name: "unassigned", blocks: []},
    #   #  {range: 786432..851967, name: "unassigned", blocks: []},
    #   #  {range: 851968..917503, name: "unassigned", blocks: []}]
    def self.plane(plane_arg, with_count: false) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
      case plane_arg
      when Integer # search by plane number
        res = PLANES[plane_arg]
      when String # search by plane name
        res = PLANES.select { |plane| plane[:name].downcase == plane_arg.downcase }
        return nil if res.empty?

        res = res.first if res.size == 1 # Hash if one, Array of Hash if multiples
      else
        raise ArgumentError
      end
      case res
      when nil
        nil # handle invalide search term
      # Enrich plane data with blocks
      when Hash # When 1 plane
        res[:blocks] = plane2blocks(res, with_count: with_count)
        res
      when Array # When multiple planes
        res.zip(plane2blocks(res, with_count: with_count)).map do |base, extra|
          base.merge(blocks: extra)
        end
      end
    end

    # Find the blocks included in a given plane
    # @param plane [Hash|Array<Hash>] plane hash or array of plane hash
    # @param with_count [TrueClass|FalseClass] calculate block's range size & char count? (see {Unisec::Blocks.list})
    # @return [Array<Hash>] plane(s) enriched with blocks data
    # @example
    #   Unisec::Planes.plane2blocks({ range: 0x20000..0x2ffff, name: 'Supplementary Ideographic Plane' }) # =>
    #   # [{range: 131072..173791, name: "CJK Unified Ideographs Extension B", range_size: nil, char_count: nil},
    #   #  {range: 173824..177983, name: "CJK Unified Ideographs Extension C", range_size: nil, char_count: nil},
    #   #  {range: 177984..178207, name: "CJK Unified Ideographs Extension D", range_size: nil, char_count: nil},
    #   #  {range: 178208..183983, name: "CJK Unified Ideographs Extension E", range_size: nil, char_count: nil},
    #   #  {range: 183984..191471, name: "CJK Unified Ideographs Extension F", range_size: nil, char_count: nil},
    #   #  {range: 191472..192095, name: "CJK Unified Ideographs Extension I", range_size: nil, char_count: nil},
    #   #  {range: 194560..195103, name: "CJK Compatibility Ideographs Supplement", range_size: nil, char_count: nil}]
    def self.plane2blocks(plane, with_count: false)
      blocks = []
      case plane
      when Hash
        Unisec::Blocks.list(with_count: with_count).each do |block|
          blocks << block if plane[:range].include_range?(block[:range])
        end
      when Array
        plane.each do |pl|
          blocks << plane2blocks(pl, with_count: with_count)
        end
      else
        raise ArgumentError
      end
      blocks
    end

    # Abbreviate a plane name (based on uppercase letters)
    # @param name [String] plane name (as in {PLANES} `:name`)
    # @return [String] plane abbreviation
    # @example
    #   Unisec::Planes.abbr('Basic Multilingual Plane') # => "BMP"
    #   Unisec::Planes.abbr('supplement­ary Private Use Area planes') # => "PUA"
    def self.abbr(name)
      name.scan(/\p{Upper}/).join
    end

    # Display a CLI-friendly output listing all planes
    def self.char_display
      raise NotImplementedError
    end
  end
end
