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

    @grid.push 'unoccupied'

    @grid.push Pawn.new
    # 2.times do
    #   @grid.push Array.new(2, 'unoccupied')
    # end
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end

  def to_json
    JSON.dump ({
      grid: @grid
    })
  end

  def self.from_json(string)
    data = JSON.load string # this is a hash, you access info like this: data['grid']
    board_inst = self.new
    board_inst.instance_variable_set(:@grid, data['grid'])
    board_inst
  end
end

# First let's try to serialize and unserialize a blank board
# Second, we will try to serialize it with ONE pawn
# We will add more pieces after that
# NOTE: the clone contains an instance of Pawn whereas the JSON.dump contains
# the same instance but its to_s form (a string).
# How do we serialize the pawn inside the array here?
# Let's unserialize Board first, then go from there.
# I think the solution will be that we will have to identify a keyword like Pawn,
# followed by its instance variables, we will instantiate as we need to.
# When we go to load a saved game, we can identify whose turn it is by
# whether there is an even number or odd number of games in the move_list.

board = Board.new
board_clone = board.clone
board_json = board.to_json


p board_clone
p board_json

reconstituted_board = Board.from_json(board_json)
p 'reconstituted_board'
p reconstituted_board

p 'original board'
p board