# frozen_string_literal: true

# require_relative 'main'
require_relative 'piece'
require_relative 'test_check'
# require_relative 'pieces/pawn'

require 'json'

# This is the chess board
class Board
  include Serializable
  include ChessTools
  include TestCheck
  
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
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end

  # def transfer_piece(move)
  #   move.capture_piece
  #   update_square(move.end_sq, move.start_piece)
  #   update_square(move.start_sq, 'unoccupied')
  # end

  # rewrite path_obstructed
  def path_obstructed?(path)
    # puts "\n\t#{self.class}##{__method__}\n "
    # p ['path', path]

    begin_sq = path.first
    finish_sq = path.last

    begin_piece = object(begin_sq)
    finish_obj = object(finish_sq)
    base_move = base_move(begin_sq, finish_sq)

    first_occupied_sq = path.find.with_index do |curr_sq, idx|
      next if idx.zero? # do not check begin_sq

      object(curr_sq).is_a?(Piece)
    end

    piece_at_occupied_sq = object(first_occupied_sq)
    return false if first_occupied_sq.nil? # no piece found in path using .find
    return true if finish_sq != first_occupied_sq

    if first_occupied_sq == finish_sq
      # return false if begin_piece.instance_of?(Pawn) && (base_move == [1, 1] || base_move == [1, -1]) # other piece is diagonal to pawn
      return true if begin_piece.instance_of?(Pawn) && piece_at_occupied_sq.is_a?(Piece) && base_move[1].zero? # other piece is in front of pawn
      return true if begin_piece.color == finish_obj.color # same color obstruction
    end
    false
  end

  def load_grid(grid_obj)
    # board.instance_variable_set(:@grid, loaded_grid) # perhaps create method in Board (i.e. Board#load_grid)
    @grid = grid_obj
  end
end
