# frozen_string_literal: true

module Battleship
  class Ship
    attr_reader :size, :hp, :orientation, :start_coordinate

    def initialize(size, start_coordinate, orientation)
      @size = size
      @hp = size
      @start_coordinate = start_coordinate
      @orientation = orientation
    end

    def hit
      raise "Ship already sunk" if sunk?

      @hp -= 1
      sunk?
    end

    def sunk?
      @hp.zero?
    end
  end
end
