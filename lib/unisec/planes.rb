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
      { range: 0x20000..0x2ffff, name: 'Supplementary Ideographic Plane' },
      { range: 0x30000..0x3ffff, name: 'unassigned' },
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
    # @return [Array<Hash>] blocks name, range and character and blocks count
    #   as well as abbreviation
    # @example
    #   Unisec::Planes.list # => FIXME
    def self.list
      raise NotImplementedError # see if useful?, maybe plane2blocks(PLANES)
    end

    # List details about target plane including the list of associated blocks
    # @param plane [String|Integer] name or number of the plane
    # @return [Hash|Array<Hash>|nil] nil if no match, Hash of the plane if one match,
    #   Array of planes' Hash if several matches
    def self.plane(plane_arg)
      case plane_arg
      when Integer
        res = PLANES[plane_arg]
      when String
        res = PLANES.select { |plane| plane[:name].downcase == plane_arg.downcase }
        return nil if res.empty?

        res.size == 1 ? res.first : res
      else
        raise ArgumentError
      end
      res.nil? ? nil : plane2blocks(res)
    end

    # Find the blocks included in a given plane
    # @param plane [Hash|Array<Hash>] plane hash or array of plane hash
    # @return [Hash|Array<Hash>] plane(s) enriched with blocks data
    def self.plane2blocks(plane)
      case plane
      when Hash
        raise NotImplementedError # read Blocks.txt
      when Array
        res = []
        plane.each do |pl|
          res += plane2blocks(pl)
        end
      else
        raise ArgumentError
      end
      res
    end

    # Abbreviate a plane name (based on uppercase letters)
    # @param name [String] plane name
    # @return [String] plane abbreviation
    def self.abbr(name)
      name.scan(/\p{Upper}/).join
    end

    # Display a CLI-friendly output listing all planes
    def self.char_display
      raise NotImplementedError
    end
  end
end
