# frozen_string_literal: true

# This is the chess board
class Board
  attr_reader :grid

  # Array of all 64 squares in index notation
  def self.board_squares
    squares = []
    8.times do |x|
      8.times do |y|
        squares << [x, y]
      end
    end
    squares
  end

  def initialize
    generate_board
  end

  def object(coord)
    grid[coord[0]][coord[1]] unless coord.nil?
  end

  def spaces
    squares = []
    8.times do |x|
      8.times do |y|
        squares << [x, y]
      end
    end
    squares
  end

  def generate_board
    @grid = []

    8.times do
      @grid.push Array.new(8, 'unoccupied')
    end
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end
end
