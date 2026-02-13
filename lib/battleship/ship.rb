# frozen_string_literal: true

module Battleship
  # Represents a ship on the grid with a size, position, and health points.
  # A ship is sunk when its HP reaches zero.
  class Ship
    # Raised when attempting to hit an already sunk ship.
    class AlreadySunkError < Battleship::Error; end

    attr_reader :size, :hp, :orientation, :start_coordinate

    # @param size [Integer] the number of cells the ship occupies
    # @param start_coordinate [String] the starting coordinate (e.g. "A1")
    # @param orientation [Symbol] :horizontal or :vertical
    def initialize(size, start_coordinate, orientation)
      @size = size
      @hp = size
      @start_coordinate = start_coordinate
      @orientation = orientation
    end

    # Registers a hit on this ship, reducing HP by 1.
    # @return [Boolean] true if the ship is now sunk
    # @raise [AlreadySunkError] if the ship is already sunk
    def hit
      raise AlreadySunkError, "Ship already sunk" if sunk?

      @hp -= 1
      sunk?
    end

    # @return [Boolean] true if the ship has zero HP
    def sunk?
      @hp.zero?
    end
  end
end
