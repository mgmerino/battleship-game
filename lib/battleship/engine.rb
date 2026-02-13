# frozen_string_literal: true

module Battleship
  # Core game engine that manages players, turns, and game state.
  class Engine
    DEFAULT_NUMBER_OF_SHIPS = 1

    attr_reader :players, :current_player, :opponent, :number_of_ships

    # @param players [Array<Player>] the two players
    # @param number_of_ships [Integer] ships each player must place
    def initialize(players, number_of_ships: DEFAULT_NUMBER_OF_SHIPS)
      @players = players
      @current_player = players[0]
      @opponent = players[1]
      @number_of_ships = number_of_ships
    end

    # Creates and places a ship for a player.
    # @param player [Player] the player placing the ship
    # @param size [Integer] ship size
    # @param start_coord [String] starting coordinate (e.g. "A1")
    # @param orientation [String] "h" for horizontal, "v" for vertical
    # @return [Boolean] true if placement succeeded
    def spawn_ship(player, size, start_coord, orientation)
      ship = Ship.new(size, start_coord, parse_orientation(orientation))
      player.place_ship(ship)
    end

    # Swaps the current player and opponent.
    def switch_turn
      @current_player, @opponent = @opponent, @current_player
    end

    # Attacks the opponent at the given coordinates.
    # @param coordinates [String] the coordinate to attack
    # @return [Boolean, Symbol] true for hit, false for miss, :already_attacked if repeated
    def attack(coordinates)
      Player.attack_to(@opponent, coordinates)
    end

    # @return [Boolean] true if any player has all ships sunk
    def game_over?
      players.any?(&:all_ships_sunk?)
    end

    # @return [Player, nil] the player who has not lost, or nil if game is not over
    def winner
      players.find { |player| !player.all_ships_sunk? }
    end

    private

    def parse_orientation(orientation)
      orientation == "h" ? :horizontal : :vertical
    end
  end
end
