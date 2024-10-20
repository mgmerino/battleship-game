# frozen_string_literal: true

module Battleship
  RSpec.describe Player do
    let(:player) { described_class.new("Player 1") }
    let(:opponent) { described_class.new("Player 2") }

    describe "#place_ship" do
      subject { player.place_ship(ship) }

      context "when ship placement is valid" do
        let(:ship) { Ship.new(2, "A1", :horizontal) }

        it "places the ship on the grid" do
          expect { subject }.to change { player.ships.count }.by(1)
        end

        it "returns true" do
          expect(subject).to eq(true)
        end
      end

      context "when ship placement is invalid" do
        let(:ship) { Ship.new(2, "A1", :horizontal) }

        before do
          player.place_ship(ship)
        end

        it "does not place the ship on the grid" do
          expect { subject }.not_to(change { player.ships.count })
        end

        it "returns false" do
          expect(subject).to eq(false)
        end
      end
    end

    describe "#find_ship" do
      subject { player.find_ship(coordinates) }

      context "when ship is found" do
        let(:ship) { Ship.new(2, "A1", :horizontal) }
        let(:coordinates) { [0, 0] }

        before do
          player.place_ship(ship)
        end

        it "returns the ship" do
          expect(subject).to eq(ship)
        end
      end

      context "when ship is not found" do
        let(:ship) { Ship.new(2, "A1", :horizontal) }
        let(:coordinates) { [1, 1] }

        before do
          player.place_ship(ship)
        end

        it "returns nil" do
          expect(subject).to be_nil
        end
      end
    end

    describe "#all_ships_sunk?" do
      subject { player.all_ships_sunk? }

      context "when all ships are sunk" do
        let(:ship) { Ship.new(2, "A1", :horizontal) }

        before do
          player.place_ship(ship)
          ship.hit
          ship.hit
        end

        it "returns true" do
          expect(subject).to eq(true)
        end
      end
    end

    describe ".attack_to" do
      subject { described_class.attack_to(opponent, "A1") }

      context "when attack is successful" do
        let(:ship) { Ship.new(2, "A1", :horizontal) }

        before do
          opponent.place_ship(ship)
        end

        it "reduces the opponent's ship health points" do
          expect { subject }.to change { ship.hp }.by(-1)
        end

        it "returns true" do
          expect(subject).to eq(true)
        end
      end

      context "when attack is unsuccessful" do
        it "returns false" do
          expect(subject).to eq(false)
        end
      end
    end
  end
end
