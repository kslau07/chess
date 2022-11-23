# frozen_string_literal: true

# require_relative 'main'
require 'json'
require_relative 'piece'
require_relative 'check'
require_relative 'display'
# require_relative 'pieces/pawn'

# This is the chess board
class Board
  include Serializable
  include ChessTools
  include Check

  attr_reader :grid

  def initialize(layout = 'standard', move_list = nil)
    create_new_grid
    @board_config = BoardConfig.new(self, layout, move_list)
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

  def create_new_grid
    @grid = []

    8.times do
      @grid.push Array.new(8, 'unoccupied')
    end
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end

  # path from 1..-1 cannot contain same colored piece
  # path from 1..-2 cannot contain opposing piece
  def path_obstructed?(path)
    return pawn_path_obstructed?(path) if object(path.first).is_a?(Pawn)
    return true if friendly?(object(path.first).color, path.last)

    search_path = path[1..-2] # squares inbetween start/end
    search_path.each do |sq|
      return true if object(sq).is_a?(Piece)
    end
  end

  def friendly?(player_color, end_sq)
    true if object(end_sq).is_a?(Piece) && object(end_sq).color == player_color
  end

  def pawn_path_obstructed?(path)
    cond1 = object(path[1]) == 'unoccupied'
    cond2 = object(path[2]) == 'unoccupied' || nil
    return false if cond1 && cond2

    true
  end

  def load_grid(grid_obj)
    @grid = grid_obj
  end

  def promotion?(new_move)
    cond1 = new_move.end_sq[0] == 7 && new_move.start_piece.instance_of?(Pawn) # wht pawn
    cond2 = new_move.end_sq[0] == 0 && new_move.start_piece.instance_of?(Pawn) # blk pawn
    cond1 || cond2
  end

  def promote_pawn(new_move, input = '')
    puts Display.pawn_promotion(new_move.player)
    loop do
      input = gets.chomp
      break if input.match(/^[1-4]{1}$/)

      puts 'Not valid input!'
    end
    change_pawn(new_move, input)
  end

  def change_pawn(new_move, input)
    promotion = { 'Queen': '1', 'Rook': '2', 'Bishop': '3', 'Knight': '4' }.key(input)
    new_piece = PieceFactory.create(promotion, new_move.player.color)
    update_square(new_move.end_sq, new_piece)
  end
end


# def path_obstructed?(path) # path contains start_sq and end_sq
#   return pawn_path_obstructed?(path) if object(path.first).is_a?(Pawn)

#   start_sq = path.first
#   end_sq = path.last
#   start_obj = object(start_sq)
#   finish_obj = object(end_sq)

#   first_occupied_sq = path.find.with_index do |curr_sq, idx|
#     next if idx.zero? # do not check start_sq

#     object(curr_sq).is_a?(Piece)
#   end

#   # piece_at_occupied_sq = object(first_occupied_sq)
#   return false if first_occupied_sq.nil? # no piece found in path using .find
#   return true if end_sq != first_occupied_sq

#   if first_occupied_sq == end_sq
#     return true if start_obj.color == finish_obj.color # same color obstruction
#   end
#   false
# end