# frozen_string_literal: true

module Battleship
  module Terminal
    RSpec.describe InputHandler do
      let(:input_handler) { described_class.new }

      describe "#get_ship_placement_input" do
        it "returns the ship size, starting coordinate, and orientation" do
          allow(input_handler).to receive(:request_input).and_return(3, "A1", "h")

          expect(input_handler.get_ship_placement_input).to eq([3, "A1", "h"])
        end
      end
    end
  end
end
