# frozen_string_literal: true

module Battleship
  # Represents a single cell on the game grid.
  # Each cell tracks its state: water, ship, hit, or miss.
  class Cell
    attr_accessor :state

    STATE = {
      water: :water,
      ship: :ship,
      hit: :hit,
      miss: :miss
    }.freeze

    def initialize
      @state = STATE[:water]
    end

    # Marks this cell as containing a ship unit.
    def place_ship_unit
      @state = STATE[:ship]
    end

    # Processes an attack on this cell.
    # @return [Boolean] true if a ship was hit, false if it was a miss
    def hit
      if @state == STATE[:ship]
        @state = STATE[:hit]
        true
      else
        @state = STATE[:miss]
        false
      end
    end

    # Checks whether this cell has already been attacked.
    # @return [Boolean] true if the cell is in :hit or :miss state
    def attacked?
      @state == STATE[:hit] || @state == STATE[:miss]
    end

    # @return [String] string representation of the cell state
    def to_s
      STATE[@state].to_s
    end
  end
end
