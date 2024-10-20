# frozen_string_literal: true

module Battleship
  module Terminal
    class Interface
      def initialize(players, presenter = Presenter.new, input_handler = InputHandler.new)
        @game_engine = Engine.new(players)
        @presenter = presenter
        @input_handler = input_handler
      end

      def run
        setup_game
        play_game
        end_game
      end

      private

      def setup_game
        @presenter.display_welcome_message
        @game_engine.players.each do |player|
          @presenter.display_player_turn(player)
          Engine::NUMBER_OF_SHIPS.times do
            place_ship_for_player(player)
            @presenter.clear_screen
          end
        end
      end

      def place_ship_for_player(player)
        valid = false

        until valid
          @presenter.display_current_board(player.grid)
          size, coord, orientation = @input_handler.ship_placement_input

          valid = @game_engine.spawn_ship(player, size, coord, orientation)
          @presenter.display_invalid_placement_message unless valid
          @presenter.display_current_board(player.grid)
          @input_handler.pause_for_user
        end
      end

      def play_game
        until @game_engine.game_over?
          player = @game_engine.current_player
          opponent = @game_engine.opponent

          @presenter.display_grids(player, opponent)

          coordinates = @input_handler.attack_coordinates(player)
          handle_attack(@game_engine.attack(coordinates))
        end
      end

      def handle_attack(result)
        @presenter.display_attack_result(result)

        if @game_engine.game_over?
          @input_handler.pause_for_user
        else
          @game_engine.switch_turn
          @presenter.display_switch_turn
          @input_handler.pause_for_user
          @presenter.clear_screen
        end
      end

      def end_game
        @presenter.display_winner(@game_engine.winner)
      end
    end
  end
end
