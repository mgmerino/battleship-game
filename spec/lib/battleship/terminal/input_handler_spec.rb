# frozen_string_literal: true

module Battleship
  module Terminal
    RSpec.describe InputHandler do
      let(:input_handler) { described_class.new }

      describe "#ship_placement_input" do
        it "returns the ship size, starting coordinate, and orientation" do
          allow(input_handler).to receive(:request_input).and_return(3, "A1", "h")

          expect(input_handler.ship_placement_input).to eq([3, "A1", "h"])
        end
      end

      describe "#attack_coordinates" do
        let(:player) { double("Player", name: "Player 1") }

        it "returns a valid coordinate" do
          allow(input_handler).to receive(:request_input).and_return("B3")

          expect(input_handler.attack_coordinates(player)).to eq("B3")
        end
      end

      describe "input validation" do
        describe "valid_size?" do
          it "accepts sizes between 1 and grid size" do
            (1..5).each do |size|
              allow(input_handler).to receive(:gets).and_return("#{size}\n")
              allow(input_handler).to receive(:print)

              expect(input_handler.send(:valid_size?, size)).to be true
            end
          end

          it "rejects size 0" do
            expect(input_handler.send(:valid_size?, 0)).to be false
          end

          it "rejects negative sizes" do
            expect(input_handler.send(:valid_size?, -1)).to be false
          end

          it "rejects sizes larger than grid size" do
            expect(input_handler.send(:valid_size?, 6)).to be false
          end
        end

        describe "valid_coordinate?" do
          it "accepts valid uppercase coordinates" do
            %w[A1 B3 C5 E5 A5 E1].each do |coord|
              expect(input_handler.send(:valid_coordinate?, coord)).to be true
            end
          end

          it "rejects lowercase coordinates" do
            expect(input_handler.send(:valid_coordinate?, "a1")).to be false
          end

          it "rejects out-of-range row letters" do
            expect(input_handler.send(:valid_coordinate?, "F1")).to be false
          end

          it "rejects out-of-range column numbers" do
            expect(input_handler.send(:valid_coordinate?, "A6")).to be false
          end

          it "rejects column 0" do
            expect(input_handler.send(:valid_coordinate?, "A0")).to be false
          end

          it "rejects empty string" do
            expect(input_handler.send(:valid_coordinate?, "")).to be false
          end

          it "rejects single character" do
            expect(input_handler.send(:valid_coordinate?, "A")).to be false
          end
        end

        describe "valid_direction?" do
          it "accepts 'h' for horizontal" do
            expect(input_handler.send(:valid_direction?, "h")).to be true
          end

          it "accepts 'v' for vertical" do
            expect(input_handler.send(:valid_direction?, "v")).to be true
          end

          it "rejects full word 'horizontal'" do
            expect(input_handler.send(:valid_direction?, "horizontal")).to be false
          end

          it "rejects invalid direction" do
            expect(input_handler.send(:valid_direction?, "x")).to be false
          end
        end
      end

      describe "with custom grid size" do
        let(:input_handler) { described_class.new(10) }

        it "accepts coordinates up to J10" do
          expect(input_handler.send(:valid_coordinate?, "J10")).to be true
        end

        it "rejects coordinates beyond grid size" do
          expect(input_handler.send(:valid_coordinate?, "K1")).to be false
        end

        it "accepts ship sizes up to grid size" do
          expect(input_handler.send(:valid_size?, 10)).to be true
        end

        it "rejects ship sizes beyond grid size" do
          expect(input_handler.send(:valid_size?, 11)).to be false
        end
      end
    end
  end
end
