# frozen_string_literal: true

module Battleship
  RSpec.describe Grid do
    let(:grid) { described_class.new }
    let(:start_coordinate) { "A1" }
    let(:orientation) { :horizontal }
    let(:ship) { Ship.new(3, start_coordinate, orientation) }

    describe "#initialize" do
      it "creates a grid with default size of 5x5" do
        expect(grid.cells.size).to eq 5
        expect(grid.cells.all? { |row| row.size == 5 }).to eq true
      end
    end

    describe "#place_ship" do
      context "when ship is placed horizontally" do
        let(:orientation) { :horizontal }

        it "places the ship on the grid" do
          grid.place_ship(ship)

          expect(grid.cells[0][0].state).to eq :ship
          expect(grid.cells[0][1].state).to eq :ship
          expect(grid.cells[0][2].state).to eq :ship
        end
      end

      context "when ship is placed vertically" do
        let(:orientation) { :vertical }

        it "places the ship on the grid" do
          grid.place_ship(ship)

          expect(grid.cells[0][0].state).to eq :ship
          expect(grid.cells[1][0].state).to eq :ship
          expect(grid.cells[2][0].state).to eq :ship
        end
      end

      context "when ship is out of bounds" do
        let(:ship) { Ship.new(5, "E5", :horizontal) }

        it "returns false" do
          expect(grid.place_ship(ship)).to eq false
        end
      end

      context "when ship is on top of another ship" do
        it "returns false" do
          grid.place_ship(ship)

          expect(grid.place_ship(ship)).to eq false
        end
      end
    end

    describe "#attack" do
      context "when attack hits a ship" do
        it "returns true and parsed coordinates" do
          grid.place_ship(ship)

          expect(grid.attack("A1")).to eq [true, [0, 0]]
        end

        it "changes the state of the cell to hit" do
          grid.place_ship(ship)
          grid.attack("A1")

          expect(grid.cells[0][0].state).to eq :hit
        end
      end

      context "when attack misses a ship" do
        it "returns false and parsed coordinates" do
          expect(grid.attack("A1")).to eq [false, [0, 0]]
        end

        it "changes the state of the cell to miss" do
          grid.attack("A1")

          expect(grid.cells[0][0].state).to eq :miss
        end
      end
    end

    describe ".calculate_coordinates" do
      context "when ship is placed horizontally" do
        let(:orientation) { :horizontal }

        it "returns expected array of coordinates" do
          expect(described_class.calculate_coordinates(ship)).to eq [[0, 0], [0, 1], [0, 2]]
        end
      end

      context "when ship is placed vertically" do
        let(:orientation) { :vertical }

        it "returns expected array of coordinates" do
          expect(described_class.calculate_coordinates(ship)).to eq [[0, 0], [1, 0], [2, 0]]
        end
      end
    end
  end
end
