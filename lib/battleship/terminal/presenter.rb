# frozen_string_literal: true

module Battleship
  module Terminal
    # Handles all terminal display output for the game.
    # Renders grids, messages, and animations.
    class Presenter
      SYMBOLS_TO_CHARACTERS = {
        water: ".",
        ship: "o",
        hit: "x",
        miss: "m"
      }.freeze

      # Displays the welcome screen with ASCII art.
      def display_welcome_message
        clear_screen
        puts "*" * 18
        puts "*** BATTLESHIP ***"
        puts "*" * 18
        puts "~-~~-~🚢~-~-🚢-~-~"
        puts "~~~~~~~~💥~~~~~~~~"
        puts "~~~~~~🚢~~~~~~~~~~"
        puts "\nWelcome to Battleship! 🌊🚢🌊 \n Press enter to start the game."
        gets
      end

      # Prompts a player to place their ships.
      # @param player [Player] the player placing ships
      def display_player_turn(player)
        puts "🚢 #{player.name}, place your ships."
      end

      # Displays an invalid placement warning.
      def display_invalid_placement_message
        puts "Invalid placement. Try again."
      end

      # Displays both player's and opponent's grids side by side.
      # @param player [Player] the current player
      # @param opponent [Player] the opponent (ships hidden)
      def display_grids(player, opponent)
        puts "#{player.name}'s board:"
        display_grid(player.grid)

        puts "#{opponent.name}'s board (hidden ships):"
        display_grid(opponent.grid, hide_ships: true)
      end

      # Displays the result of an attack.
      # @param result [Boolean] true for hit, false for miss
      def display_attack_result(result)
        puts result ? "💥 Hit!" : "🌊 Miss!"
      end

      # Displays a message when attacking a previously attacked cell.
      def display_already_attacked
        puts "You already attacked this coordinate! Try again."
      end

      # Displays a turn switch prompt.
      def display_switch_turn
        puts "Switching turns... Press enter to continue."
      end

      # Displays the winner with an animation.
      # @param winner [Player] the winning player
      def display_winner(winner)
        end_game_animation
        puts "\nGame over! 🎖️ #{winner.name} wins! 🎖️"
      end

      # Displays the current player's board during ship placement.
      # @param grid [Grid] the grid to display
      def display_current_board(grid)
        puts "🗺️  This is how your board looks like now:"
        display_grid(grid)
      end

      # Clears the terminal screen.
      def clear_screen
        system("clear") || system("cls")
      end

      # Renders a grid with row/column labels.
      # @param grid [Grid] the grid to render
      # @param hide_ships [Boolean] if true, ships appear as water
      def display_grid(grid, hide_ships: false)
        print_grid_header(grid.size)
        max_letter = ("A".ord + grid.size - 1).chr
        ("A"..max_letter).each_with_index do |row_label, i|
          puts "#{row_label} #{format_row(grid.cells[i], hide_ships)}"
        end
        puts "-" * ((grid.size * 2) + 1)
      end

      private

      def print_grid_header(grid_size)
        puts "  #{(1..grid_size).map(&:to_s).join(" ")}"
      end

      def format_row(cells, hide_ships)
        cells.map do |cell|
          if hide_ships && cell.state == :ship
            SYMBOLS_TO_CHARACTERS[:water]
          else
            SYMBOLS_TO_CHARACTERS[cell.state]
          end
        end.join(" ")
      end

      def end_game_animation
        4.times do
          print "💥"
          sleep 0.5
          print "🚢"
          sleep 0.5
          print "\b\b\b" # remove last char
        end
      end
    end
  end
end
