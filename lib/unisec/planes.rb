# frozen_string_literal: true

require 'paint'
require 'unisec/utils'

module Unisec
  class Planes
    # Data about the planes
    PLANES = [
      {
        range: 0x0..0xffff,
        name: 'Basic Multilingual Plane',
        abbr: 'BMP'
        # char_count: computed dynamically
        # block_count: computed dynamically
      },
      {
        range: 0x10000..0x1ffff,
        name: 'Supplementary Multilingual Plane',
        abbr: 'SMP'
      }
      # FIXME
    ]

    # List Unicode planes name
    # @return [Array<Hash>] blocks name, range and character and blocks count
    #   as well as abbreviation
    # @example
    #   Unisec::Planes.list # => FIXME
    def self.list
      raise NotImplementedError
    end

    # List details about target plane including the list of associated blocks
    # @param plane [String|Integer] name or number of the plane
    def self.plane(plane)
      raise NotImplementedError
    end

    # Display a CLI-friendly output listing all planes
    def self.char_display
      raise NotImplementedError
    end
  end
end
