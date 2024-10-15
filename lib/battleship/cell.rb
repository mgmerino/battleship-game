# frozen_string_literal: true

module Battleship
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

    def place_ship_unit
      @state = STATE[:ship]
    end

    def hit
      if @state == STATE[:ship]
        @state = STATE[:hit]
        true
      else
        @state = STATE[:miss]
        false
      end
    end

    def hit_or_miss?
      @state == STATE[:ship] || @state == STATE[:miss]
    end

    def to_s
      STATE[@state].to_s
    end
  end
end
