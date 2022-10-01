# frozen_string_literal: true

require_relative 'piece'
require_relative 'pieces/pawn'

require 'json'

# This is the chess board
class Board
  attr_reader :grid

  def initialize
    generate_board
  end

  def object(coord)
    grid[coord[0]][coord[1]] unless coord.nil?
  end

  def squares
    arr_of_squares = []
    8.times do |x|
      8.times do |y|
        arr_of_squares << [x, y]
      end
    end
    arr_of_squares
  end

  def generate_board
    @grid = []

    8.times do
      @grid.push Array.new(8, 'unoccupied')
    end

    @grid << Pawn.new
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end

  # def to_json
  #   JSON.dump ({
  #     grid: @grid
  #   })
  # end
end

