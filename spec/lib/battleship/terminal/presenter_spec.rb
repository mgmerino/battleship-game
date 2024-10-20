# frozen_string_literal: true

module Battleship
  module Terminal
    RSpec.describe Presenter do
      let(:presenter) { Presenter.new }

      describe "#display_welcome_message" do
        it "displays the welcome message" do
          expect(presenter).to receive(:clear_screen)
          expect(presenter).to receive(:puts).with("*" * 18)
          expect(presenter).to receive(:puts).with("*** BATTLESHIP ***")
          expect(presenter).to receive(:puts).with("*" * 18)
          expect(presenter).to receive(:puts).with("~-~~-~🚢~-~-🚢-~-~")
          expect(presenter).to receive(:puts).with("~~~~~~~~💥~~~~~~~~")
          expect(presenter).to receive(:puts).with("~~~~~~🚢~~~~~~~~~~")
          expect(presenter).to receive(:puts).with("~~~~~~~~~~💥~~~~~~")
          expect(presenter).to receive(:puts).with("\nWelcome to Battleship! 🌊🚢🌊")
          expect(presenter).to receive(:puts).with("Press enter to start the game.")
          expect(presenter).to receive(:gets)
          expect(presenter).to receive(:clear_screen)

          presenter.display_welcome_message
        end
      end

      describe "#display_player_turn" do
        it "displays the player's turn message" do
          player = double("Player", name: "Player 1")

          expect(presenter).to receive(:puts).with("🚢 Player 1, place your ships.")

          presenter.display_player_turn(player)
        end
      end

      describe "#display_invalid_placement_message" do
        it "displays the invalid placement message" do
          expect(presenter).to receive(:puts).with("Invalid placement. Try again.")

          presenter.display_invalid_placement_message
        end
      end
    end
  end
end
