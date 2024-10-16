# frozen_string_literal: true

module Battleship
  RSpec.describe Ship do
    let(:ship) { described_class.new(3, "A5", :horizontal) }

    describe "#initialize" do
      it "has a size" do
        expect(ship.size).to eq 3
      end

      it "has hp equal to size" do
        expect(ship.hp).to eq 3
      end

      it "has a start coordinate" do
        expect(ship.start_coordinate).to eq "A5"
      end

      it "has an orientation" do
        expect(ship.orientation).to eq :horizontal
      end
    end

    describe "#hit" do
      context "when ship is not sunk" do
        it "decreases hp by 1" do
          ship.hit

          expect(ship.hp).to eq 2
        end

        it "returns false" do
          expect(ship.hit).to eq false
        end
      end

      context "when ship is sunk" do
        let(:ship) { described_class.new(1, "A1", :horizontal) }

        before do
          ship.hit
        end

        it "raises an error" do
          expect { ship.hit }.to raise_error(RuntimeError, "Ship already sunk")
        end
      end
    end
  end
end
