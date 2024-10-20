# frozen_string_literal: true

module Battleship
  RSpec.describe Engine do
    let(:player1) { Player.new("Player 1") }
    let(:player2) { Player.new("Player 2") }
    let(:engine) { described_class.new([player1, player2]) }

    describe "#initialize" do
      it "sets the current player" do
        expect(engine.current_player).to eq(player1)
      end

      it "sets the opponent" do
        expect(engine.opponent).to eq(player2)
      end
    end

    describe "#spawn_ship" do
      let(:size) { 2 }
      let(:start_coord) { "A1" }
      let(:orientation) { "h" }

      it "places a ship on the player's grid" do
        expect(player1).to receive(:place_ship).with(instance_of(Ship))

        engine.spawn_ship(player1, size, start_coord, orientation)
      end
    end

    describe "#switch_turn" do
      it "switches the current player and opponent" do
        engine.switch_turn

        expect(engine.current_player).to eq(player2)
        expect(engine.opponent).to eq(player1)
      end
    end

    describe "#attack" do
      let(:coordinates) { "A1" }

      it "attacks the opponent's grid" do
        expect(Player).to receive(:attack_to).with(player2, coordinates)

        engine.attack(coordinates)
      end
    end

    describe "#game_over?" do
      context "when a player has all ships sunk" do
        before do
          player1.ships << double(:ship, sunk?: true)
        end

        it "returns true" do
          expect(engine.game_over?).to eq(true)
        end
      end
    end

    describe "#winner" do
      context "when a player has all ships sunk" do
        before do
          player1.ships << double(:ship, sunk?: false)
          player2.ships << double(:ship, sunk?: true)
        end

        it "returns the winner" do
          expect(engine.winner).to eq(player1)
        end
      end

      context "when no player has all ships sunk" do
        it "returns nil" do
          expect(engine.winner).to be_nil
        end
      end
    end
  end
end
