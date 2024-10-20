# frozen_string_literal: true

module Battleship
  module Terminal
    class Presenter
      SYMBOLS_TO_CHARACTERS = {
        water: ".",
        ship: "o",
        hit: "x",
        miss: "m"
      }.freeze

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

      def display_player_turn(player)
        puts "🚢 #{player.name}, place your ships."
      end

      def display_invalid_placement_message
        puts "Invalid placement. Try again."
      end

      def display_grids(player, opponent)
        puts "#{player.name}'s board:"
        display_grid(player.grid)

        puts "#{opponent.name}'s board (hidden ships):"
        display_grid(opponent.grid, hide_ships: true)
      end

      def display_attack_result(result)
        puts result ? "💥 Hit!" : "🌊 Miss!"
      end

      def display_switch_turn
        puts "Switching turns... Press enter to continue."
      end

      def display_winner(winner)
        end_game_animation
        puts "\nGame over! 🎖️ #{winner.name} wins! 🎖️"
      end

      def display_current_board(grid)
        puts "🗺️  This is how your board looks like now:"
        display_grid(grid)
      end

      def clear_screen
        system("clear") || system("cls")
      end

      def display_grid(grid, hide_ships: false)
        puts "  1 2 3 4 5"
        ("A".."E").each_with_index do |row_label, i|
          row = grid.cells[i].map do |cell|
            if hide_ships && cell.state == :ship
              SYMBOLS_TO_CHARACTERS[:water]
            else
              display_cell(cell)
            end
          end.join(" ")
          puts "#{row_label} #{row}"
        end
        puts "-" * 11
      end

      private

      def display_cell(cell)
        SYMBOLS_TO_CHARACTERS[cell.state]
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
