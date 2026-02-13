# frozen_string_literal: true

module Battleship
  # Represents a player with a name, grid, and collection of ships.
  class Player
    attr_reader :name, :grid, :ships

    class << self
      # Attacks an opponent at the given coordinate.
      # @param opponent [Player] the player being attacked
      # @param coordinate [String] the coordinate to attack (e.g. "A1")
      # @return [Boolean, Symbol] true for hit, false for miss, :already_attacked if repeated
      def attack_to(opponent, coordinate)
        result, parsed_coordinates = opponent.grid.attack(coordinate)

        return :already_attacked if result == :already_attacked

        hit_opponent_ship(opponent, parsed_coordinates) if result

        result
      end

      private

      def hit_opponent_ship(opponent, parsed_coordinates)
        ship = opponent.find_ship(parsed_coordinates)
        ship.hit
      end
    end

    # @param name [String] the player's display name
    # @param grid [Grid] the player's game board
    def initialize(name, grid = Grid.new)
      @name = name
      @grid = grid
      @ships = []
    end

    # Places a ship on the player's grid.
    # @param ship [Ship] the ship to place
    # @return [Boolean] true if placement succeeded
    def place_ship(ship)
      valid_placement = grid.place_ship(ship)

      ships << ship if valid_placement
      valid_placement
    end

    # Finds the ship occupying the given grid coordinates.
    # @param coordinates [Array(Integer, Integer)] [row, col] to search
    # @return [Ship, nil] the ship at those coordinates, or nil
    def find_ship(coordinates)
      ships.find do |ship|
        ship_coords = Grid.calculate_coordinates(ship)
        ship_coords.include? coordinates
      end
    end

    # @return [Boolean] true if every ship has been sunk
    def all_ships_sunk?
      ships.all?(&:sunk?)
    end
  end
end
