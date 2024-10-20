# frozen_string_literal: true

module Battleship
  module Terminal
    class InputHandler
      def get_ship_placement_input
        size = request_input("Enter the ship size: ", method(:valid_size?), :to_i, "Invalid size!")
        coord = request_input("Enter the starting coordinate (<[A-E][1-5]>): ", method(:valid_coordinate?), :upcase,
                              "Invalid coordinate!")
        orientation = request_input("Enter direction (horizontal/vertical): ", method(:valid_direction?), :to_s,
                                    "Invalid direction!")

        [size, coord, orientation]
      end

      def attack_coordinates(player) 
        request_input("#{player.name}, enter coordinate to attack (<[A-E][1-5]>): ", 
                      method(:valid_coordinate?),
                      :upcase,
                      "Invalid coordinate!")
      end

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
        size.between?(1, 5)
      end

      def valid_coordinate?(coord)
        coord.match?(/^[A-E][1-5]$/)
      end

      def valid_direction?(orientation)
        %w[h v].include?(orientation)
      end
    end
  end
end
