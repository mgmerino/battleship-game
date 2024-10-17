# frozen_string_literal: true

module Battleship
  module Terminal
    class Presenter
      SYMBOLS_TO_CHARACTERS = {
        water: ".",
        ship: "o",
        hit: "x",
        miss: "m"
      }.freeze

      def display_cell(cell)
        SYMBOLS_TO_CHARACTERS[cell.state]
      end

      def display_grid(grid, hide_ships: false)
        puts "  1 2 3 4 5"
        ("A".."E").each_with_index do |row_label, i|
          row = grid.cells[i].map do |cell|
            if hide_ships && cell.state == :ship
              SYMBOLS_TO_CHARACTERS[:water]
            else
              display_cell(cell)
            end
          end.join(" ")
          puts "#{row_label} #{row}"
        end
      end
    end
  end
end
