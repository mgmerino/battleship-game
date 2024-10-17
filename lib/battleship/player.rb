# frozen_string_literal: true

module Battleship
  class Player
    attr_reader :name, :grid, :ships

    class << self
      def attack_to(opponent, coordinate)
        success, parsed_coordinates = opponent.grid.attack(coordinate)
  
        hit_opponent_ship(opponent, parsed_coordinates) if success
        
        success
      end

      private

      def hit_opponent_ship(opponent, parsed_coordinates)
        ship = opponent.find_ship(parsed_coordinates)
        ship.hit
      end
    end

    def initialize(name, grid = Grid.new)
      @name = name
      @grid = grid
      @ships = []
    end

    def place_ship(ship)
      valid_placement = grid.place_ship(ship)

      ships << ship if valid_placement
      valid_placement
    end

    def find_ship(coordinates)
      ships.find do |ship|
        ship_coords = Grid.calculate_coordinates(ship)
        ship_coords.include? coordinates
      end
    end

    def all_ships_sunk?
      ships.all?(&:sunk?)
    end
  end
end
