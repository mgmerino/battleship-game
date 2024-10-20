# frozen_string_literal: true

require_relative "battleship/version"
require_relative "battleship/grid"
require_relative "battleship/cell"
require_relative "battleship/ship"
require_relative "battleship/player"
require_relative "battleship/engine"
require_relative "battleship/terminal/interface"
require_relative "battleship/terminal/presenter"
require_relative "battleship/terminal/input_handler"

require "pry"

module Battleship
  class Error < StandardError; end
end
