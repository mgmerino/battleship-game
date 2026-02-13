# frozen_string_literal: true

module Battleship
  # Represents the game board as a 2D grid of cells.
  # Handles ship placement and attack resolution.
  class Grid
    DEFAULT_SIZE = 5

    attr_reader :cells, :size

    class << self
      # Calculates all grid coordinates a ship occupies.
      # @param ship [Ship] the ship to calculate coordinates for
      # @return [Array<Array(Integer, Integer)>] array of [row, col] pairs
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

      # Converts a string coordinate (e.g. "A1") to row/col indices.
      # @param coordinate [String] the coordinate string
      # @return [Array(Integer, Integer)] [row, col] zero-indexed
      def parse_coordinates(coordinate)
        row = coordinate[0].ord - "A".ord
        col = coordinate[1..].to_i - 1

        [row, col]
      end
    end

    # @param size [Integer] the grid dimension (size x size)
    def initialize(size = DEFAULT_SIZE)
      @size = size
      @cells = Array.new(size) { Array.new(size) { Cell.new } }
    end

    # Places a ship on the grid.
    # @param ship [Ship] the ship to place
    # @return [Boolean] true if placement succeeded, false if invalid
    def place_ship(ship)
      coordinates = self.class.calculate_coordinates(ship)
      validate_placement(coordinates)

      coordinates.each { |row, col| @cells[row][col].place_ship_unit }
      true
    rescue ArgumentError
      false
    end

    # Attacks a cell at the given coordinate.
    # @param coordinate [String] the coordinate to attack (e.g. "A1")
    # @return [Array] [:already_attacked, [row, col]] if already attacked,
    #   or [Boolean, [row, col]] where Boolean indicates hit (true) or miss (false)
    def attack(coordinate)
      row, col = self.class.parse_coordinates(coordinate)
      cell = @cells[row][col]

      return [:already_attacked, [row, col]] if cell.attacked?

      result = cell.hit
      [result, [row, col]]
    end

    private

    def validate_placement(coordinates)
      return if coordinates.all? { |row, col| within_bounds?(row, col) && water?(row, col) }

      raise ArgumentError, "Invalid ship placement!"
    end

    def water?(row, col)
      @cells[row][col].state == :water
    end

    def within_bounds?(row, col)
      row.between?(0, @size - 1) && col.between?(0, @size - 1)
    end
  end
end
