# frozen_string_literal: true

module Battleship
  module Terminal
    RSpec.describe Interface do
      let(:player1) { Player.new("Player 1") }
      let(:player2) { Player.new("Player 2") }
      let(:players) { [player1, player2] }
      let(:presenter) { double("Presenter") }
      let(:input_handler) { double("InputHandler") }
      let(:game_engine) { double("Engine") }
      let(:interface) { Interface.new(players, presenter, input_handler) }

      before do
        allow(Engine).to receive(:new).and_return(game_engine)
        allow(presenter).to receive(:display_welcome_message)
        allow(presenter).to receive(:display_player_turn)
        allow(presenter).to receive(:display_invalid_placement_message)
        allow(presenter).to receive(:clear_screen)
        allow(presenter).to receive(:display_grids)
        allow(presenter).to receive(:display_attack_result)
        allow(presenter).to receive(:display_current_board)
        allow(input_handler).to receive(:ship_placement_input)
        allow(input_handler).to receive(:pause_for_user)
        allow(input_handler).to receive(:get_attack_coordinates)
        allow(game_engine).to receive(:players).and_return(players)
        allow(game_engine).to receive(:current_player).and_return(player1)
        allow(game_engine).to receive(:opponent).and_return(player2)
        allow(game_engine).to receive(:game_over?).and_return(false, true)
        allow(game_engine).to receive(:spawn_ship).and_return(true)
        allow(game_engine).to receive(:attack).and_return(true)
      end

      describe "#run" do
        it "runs the game" do
          expect(interface).to receive(:setup_game)
          expect(interface).to receive(:play_game)
          expect(interface).to receive(:end_game)

          interface.run
        end
      end
    end
  end
end
