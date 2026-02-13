# frozen_string_literal: true

module Battleship
  module Terminal
    # Handles all user input: ship placement, attack coordinates, and pausing.
    # Validates and coerces input before returning.
    class InputHandler
      # @param grid_size [Integer] the grid dimension for input validation
      def initialize(grid_size = Grid::DEFAULT_SIZE)
        @grid_size = grid_size
      end

      # Prompts the user for ship placement details.
      # @return [Array(Integer, String, String)] [size, coordinate, orientation]
      def ship_placement_input
        max_letter = ("A".ord + @grid_size - 1).chr
        coord_hint = "<[A-#{max_letter}][1-#{@grid_size}]>"

        size = request_input("Enter the ship size: ", method(:valid_size?), :to_i, "Invalid size!")
        coord = request_input("Enter the starting coordinate (#{coord_hint}): ", method(:valid_coordinate?), :upcase,
                              "Invalid coordinate!")
        orientation = request_input("Enter direction (h/v): ", method(:valid_direction?), :to_s,
                                    "Invalid direction!")

        [size, coord, orientation]
      end

      # Prompts a player for attack coordinates.
      # @param player [Player] the attacking player
      # @return [String] validated coordinate string (e.g. "A1")
      def attack_coordinates(player)
        max_letter = ("A".ord + @grid_size - 1).chr
        coord_hint = "<[A-#{max_letter}][1-#{@grid_size}]>"

        request_input("#{player.name}, enter coordinate to attack (#{coord_hint}): ",
                      method(:valid_coordinate?),
                      :upcase,
                      "Invalid coordinate!")
      end

      # Waits for the user to press Enter.
      def pause_for_user
        gets
      end

      private

      def request_input(prompt, validation_method, coerce_method, error_message)
        loop do
          print prompt
          input = gets.chomp.send(coerce_method)
          return input if validation_method.call(input)

          puts error_message
        end
      end

      def valid_size?(size)
        size.between?(1, @grid_size)
      end

      def valid_coordinate?(coord)
        return false unless coord.match?(/^[A-Z]\d+$/)

        max_letter = ("A".ord + @grid_size - 1).chr
        row = coord[0]
        col = coord[1..].to_i

        row.between?("A", max_letter) && col.between?(1, @grid_size)
      end

      def valid_direction?(orientation)
        %w[h v].include?(orientation)
      end
    end
  end
end
