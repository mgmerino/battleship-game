# frozen_string_literal: true

module Battleship
  class Grid
    DEFAULT_SIZE = 5

    attr_reader :cells, :size

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
        col = coordinate[1..].to_i - 1

        [row, col]
      end
    end

    def initialize(size = DEFAULT_SIZE)
      @size = size
      @cells = Array.new(size) { Array.new(size) { Cell.new } }
    end

    def place_ship(ship)
      coordinates = self.class.calculate_coordinates(ship)
      validate_placement(coordinates)

      coordinates.each { |row, col| @cells[row][col].place_ship_unit }
      true
    rescue ArgumentError
      false
    end

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
