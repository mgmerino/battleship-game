# frozen_string_literal: true

module Battleship
  class Grid
    GRID_SIZE = 5

    attr_reader :cells
    
    class << self
      def calculate_coordinates(ship)
        row, col = parse_coordinates(ship.start_coordinate)
        coordinates = []

        if ship.orientation == :horizontal
          ship.size.times { |i| coordinates << [row, col + i] } 
        elsif ship.orientation == :vertical
          ship.size.times { |i| coordinates << [row + i, col] }
        end

        coordinates
      end
  
      def parse_coordinates(coordinate)
        row = coordinate[0].ord - "A".ord
        col = coordinate[1..-1].to_i - 1
  
        [row, col]
      end
    end

    def initialize
      @cells = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { Cell.new } }
    end

    def place_ship(ship)
      coordinates = self.class.calculate_coordinates(ship)
      check_out_of_bounds(coordinates)
      check_valid_placement(coordinates)

      coordinates.each { |row, col| @cells[row][col].place_ship_unit }
      true
    rescue ArgumentError
      false
    end

    def attack(coordinate)
      row, col = self.class.parse_coordinates(coordinate)
      result = @cells[row][col].hit

      [result, [row, col]]
    end

    private

    def check_out_of_bounds(coordinates)      
      return if coordinates.all? { |row, col| row.between?(0, GRID_SIZE - 1) && col.between?(0, GRID_SIZE - 1) }
      
      raise ArgumentError, "Ship outside grid"
    end

    def check_valid_placement(coordinates)
      return if coordinates.all? { |row, col| @cells[row][col].state == :water }

      raise ArgumentError, "Ship on top of another ship"
    end
  end
end
