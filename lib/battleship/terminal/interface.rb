# frozen_string_literal: true

module Battleship
  module Terminal
    class Interface
      def initialize(players)
        @game_engine = Engine.new(players)
        @presenter = Presenter.new
      end

      def run
        setup_game
        play_game
        end_game
      end

      def setup_game
        @game_engine.players.each do |player|
          puts "WELCOME TO BATTLESHIP!"
          puts "*" * 25
          puts "~-~-~-~-~-~\\-I--/~-~-~-~-~-~-~-~"
          puts "#{player.name}, place your ships."
          Engine::NUMBER_OF_SHIPS.times do
            place_ship_for_player(player)
            clear_screen
          end
        end
      end

      def place_ship_for_player(player)
        valid = false
        
        until valid
          puts "This is how your board looks like now:"
          @presenter.display_grid(player.grid)
          print "Enter the ship size: "
          size = gets.chomp.to_i
          print "Enter the starting coordinate (<[A-E][1-5]>): "
          coord = gets.chomp.upcase
          print "Enter direction (horizontal/vertical): "
          orientation = gets.chomp.downcase

          valid = @game_engine.spawn_ship(player, size, coord, orientation)
          puts "Invalid placement. Try again." unless valid

          puts "This is how your board looks like now:"
          @presenter.display_grid(player.grid)
          gets
        end
      end

      def play_game
        until @game_engine.game_over?
          player = @game_engine.current_player
          opponent = @game_engine.opponent
          
          puts "#{player.name}'s board:"
          @presenter.display_grid(player.grid)

          puts "#{opponent.name}'s board (hidden ships):"
          @presenter.display_grid(opponent.grid, hide_ships: true)

          puts "#{player.name}, let's attack!"
          print "Enter coordinate (<[A-E][1-5]>): "
          coordinates = gets.chomp.upcase

          handle_attack(@game_engine.attack(coordinates))
          @game_engine.switch_turn
        end
      end

      def handle_attack(result)
        if result
          puts "Hit!"
        else
          puts "Miss!"
        end
        puts "Switching turns... Press enter to continue."
        gets
        clear_screen
      end

      def end_game
        puts "Game over! #{@game_engine.winner.name} wins!"
      end

      def clear_screen
        system("clear") || system("cls")
      end
    end
  end
end
