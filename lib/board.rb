# frozen_string_literal: true

require 'enumerable'
require 'forwardable'

# This is the chess board
class Board
  attr_reader :grid

  def initialize
    generate_board
  end

  def generate_board
    @grid = []

    8.times do
      @grid.push Array.new(8, nil)
    end
  end
end

# p Board.new.grid
