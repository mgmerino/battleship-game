# frozen_string_literal: true

module Battleship
  RSpec.describe Cell do
    let(:cell) { described_class.new }

    describe "#initialize" do
      it "cell is in :water state" do
        expect(cell.state).to eq :water
      end
    end

    describe "#place_ship_unit" do
      it "places a ship unit" do
        cell.place_ship_unit

        expect(cell.state).to eq :ship
      end
    end

    describe "#hit" do
      context "when it is water" do
        it "converts to :miss" do
          cell.hit

          expect(cell.state).to eq :miss
        end

        it "returns false" do
          expect(cell.hit).to eq false
        end
      end

      context "when it is a ship unit" do
        before do
          cell.place_ship_unit
        end

        it "converts to :hit" do
          cell.hit

          expect(cell.state).to eq :hit
        end

        it "returns true" do
          expect(cell.hit).to eq true
        end
      end
    end

    describe "#hit_or_miss?" do
      context "when it is a ship unit" do
        before do
          cell.place_ship_unit
        end

        it "returns true" do
          expect(cell.hit_or_miss?).to eq true
        end
      end

      context "when it is a miss" do
        before do
          cell.hit
        end

        it "returns true" do
          expect(cell.hit_or_miss?).to eq true
        end
      end

      context "when it is water" do
        it "returns false" do
          expect(cell.hit_or_miss?).to eq false
        end
      end
    end
  end
end
