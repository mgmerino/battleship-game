# frozen_string_literal: true

module Battleship
  class Engine
    NUMBER_OF_SHIPS = 1

    attr_reader :players, :current_player, :opponent
    
    class << self
      def spawn_ship(player, size, start_coord, orientation)
        ship = Ship.new(size, start_coord, parse_orientation(orientation))
        player.place_ship(ship)
      end

      private
  
      def parse_orientation(orientation)
        orientation == "h" ? :horizontal : :vertical
      end
    end

    def initialize(players)
      @players = players
      @current_player = players[0]
      @opponent = players[1]
    end

    def switch_turn
      @current_player, @opponent = @opponent, @current_player
    end

    def attack(coordinates)
      Player.attack_to(@opponent, coordinates)
    end

    def game_over?
      players.any? { |player| player.all_ships_sunk? }
    end
  
    def winner
      players.find { |player| !player.all_ships_sunk? }
    end
  end
end
