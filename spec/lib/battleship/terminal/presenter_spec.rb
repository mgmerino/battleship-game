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
          expect(presenter).to receive(:puts).with("\nWelcome to Battleship! 🌊🚢🌊 \n Press enter to start the game.")
          expect(presenter).to receive(:gets)

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

      describe "#display_attack_result" do
        context "when attack is a hit" do
          it "displays hit message" do
            expect(presenter).to receive(:puts).with("💥 Hit!")

            presenter.display_attack_result(true)
          end
        end

        context "when attack is a miss" do
          it "displays miss message" do
            expect(presenter).to receive(:puts).with("🌊 Miss!")

            presenter.display_attack_result(false)
          end
        end
      end

      describe "#display_already_attacked" do
        it "displays already attacked message" do
          expect(presenter).to receive(:puts).with("You already attacked this coordinate! Try again.")

          presenter.display_already_attacked
        end
      end

      describe "#display_switch_turn" do
        it "displays the switch turn message" do
          expect(presenter).to receive(:puts).with("Switching turns... Press enter to continue.")

          presenter.display_switch_turn
        end
      end

      describe "#display_winner" do
        it "displays the winner message" do
          winner = double("Player", name: "Alice")
          allow(presenter).to receive(:end_game_animation)

          expect(presenter).to receive(:puts).with("\nGame over! 🎖️ Alice wins! 🎖️")

          presenter.display_winner(winner)
        end
      end

      describe "#display_grids" do
        let(:grid) { Grid.new }
        let(:player) { Player.new("Alice", grid) }
        let(:opponent) { Player.new("Bob", Grid.new) }

        it "displays both player and opponent boards" do
          allow(presenter).to receive(:puts)
          allow(presenter).to receive(:display_grid)

          expect(presenter).to receive(:puts).with("Alice's board:")
          expect(presenter).to receive(:puts).with("Bob's board (hidden ships):")
          expect(presenter).to receive(:display_grid).with(player.grid)
          expect(presenter).to receive(:display_grid).with(opponent.grid, hide_ships: true)

          presenter.display_grids(player, opponent)
        end
      end

      describe "#display_grid" do
        let(:grid) { Grid.new }

        it "renders a 5x5 grid with row and column labels" do
          output = capture_output { presenter.display_grid(grid) }

          expect(output).to include("1 2 3 4 5")
          expect(output).to include("A . . . . .")
          expect(output).to include("E . . . . .")
        end

        it "shows ship positions when not hidden" do
          ship = Ship.new(2, "A1", :horizontal)
          grid.place_ship(ship)

          output = capture_output { presenter.display_grid(grid) }

          expect(output).to include("A o o . . .")
        end

        it "hides ship positions when hide_ships is true" do
          ship = Ship.new(2, "A1", :horizontal)
          grid.place_ship(ship)

          output = capture_output { presenter.display_grid(grid, hide_ships: true) }

          expect(output).to include("A . . . . .")
        end

        it "shows hits and misses even when hiding ships" do
          ship = Ship.new(2, "A1", :horizontal)
          grid.place_ship(ship)
          grid.attack("A1")
          grid.attack("B1")

          output = capture_output { presenter.display_grid(grid, hide_ships: true) }

          expect(output).to include("A x")
          expect(output).to include("B m")
        end
      end

      private

      def capture_output
        original_stdout = $stdout
        $stdout = StringIO.new
        yield
        $stdout.string
      ensure
        $stdout = original_stdout
      end
    end
  end
end
