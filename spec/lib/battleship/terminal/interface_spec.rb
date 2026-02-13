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
        allow(presenter).to receive(:display_switch_turn)
        allow(presenter).to receive(:display_winner)
        allow(presenter).to receive(:display_already_attacked)
        allow(input_handler).to receive(:ship_placement_input).and_return([2, "A1", "h"])
        allow(input_handler).to receive(:pause_for_user)
        allow(input_handler).to receive(:attack_coordinates).and_return("A1")
        allow(game_engine).to receive(:players).and_return(players)
        allow(game_engine).to receive(:current_player).and_return(player1)
        allow(game_engine).to receive(:opponent).and_return(player2)
        allow(game_engine).to receive(:game_over?).and_return(false, true)
        allow(game_engine).to receive(:spawn_ship).and_return(true)
        allow(game_engine).to receive(:attack).and_return(true)
        allow(game_engine).to receive(:number_of_ships).and_return(1)
        allow(game_engine).to receive(:winner).and_return(player1)
        allow(game_engine).to receive(:switch_turn)
      end

      describe "#run" do
        it "calls setup_game, play_game, and end_game in order" do
          expect(interface).to receive(:setup_game).ordered
          expect(interface).to receive(:play_game).ordered
          expect(interface).to receive(:end_game).ordered

          interface.run
        end

        it "runs a complete game flow" do
          interface.run

          expect(presenter).to have_received(:display_welcome_message)
          expect(presenter).to have_received(:display_winner).with(player1)
        end
      end

      describe "setup phase" do
        it "displays welcome and asks each player to place ships" do
          allow(game_engine).to receive(:game_over?).and_return(true)

          interface.run

          expect(presenter).to have_received(:display_welcome_message)
          expect(presenter).to have_received(:display_player_turn).with(player1)
          expect(presenter).to have_received(:display_player_turn).with(player2)
          expect(game_engine).to have_received(:spawn_ship).twice
        end

        it "retries when ship placement is invalid" do
          allow(game_engine).to receive(:spawn_ship).and_return(false, true, true)
          allow(game_engine).to receive(:game_over?).and_return(true)

          interface.run

          expect(presenter).to have_received(:display_invalid_placement_message).once
          expect(game_engine).to have_received(:spawn_ship).exactly(3).times
        end
      end

      describe "play phase" do
        it "displays grids before each attack" do
          interface.run

          expect(presenter).to have_received(:display_grids).with(player1, player2)
        end

        it "handles a hit result" do
          allow(game_engine).to receive(:attack).and_return(true)
          allow(game_engine).to receive(:game_over?).and_return(false, false, true)

          interface.run

          expect(presenter).to have_received(:display_attack_result).with(true)
        end

        it "handles a miss result" do
          allow(game_engine).to receive(:attack).and_return(false)
          allow(game_engine).to receive(:game_over?).and_return(false, false, true)

          interface.run

          expect(presenter).to have_received(:display_attack_result).with(false)
          expect(game_engine).to have_received(:switch_turn)
        end

        it "handles duplicate attack" do
          allow(game_engine).to receive(:attack).and_return(:already_attacked, true)
          allow(game_engine).to receive(:game_over?).and_return(false, false, true)

          interface.run

          expect(presenter).to have_received(:display_already_attacked).once
        end
      end

      describe "end phase" do
        it "displays the winner" do
          interface.run

          expect(presenter).to have_received(:display_winner).with(player1)
        end
      end
    end
  end
end
