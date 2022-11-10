# frozen_string_literal: true

# require_relative 'main'
require 'json'
require_relative 'piece'
require_relative 'test_check'
# require_relative 'pieces/pawn'

# This is the chess board
class Board
  include Serializable
  include ChessTools
  include TestCheck

  attr_reader :grid

  def initialize(layout)
    generate_grid
    @board_config = BoardConfig.new(self, layout)
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

  def generate_grid
    @grid = []

    8.times do
      @grid.push Array.new(8, 'unoccupied')
    end
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end

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
    @grid = grid_obj
  end

  def promotion?(new_move)
    new_move.end_sq[0] == 7 && new_move.start_piece.instance_of?(Pawn)
  end

  def promote_pawn(new_move, input = '')
    puts "#{new_move.player.color.capitalize}, your pawn has been promoted!"
    puts "Pick the promotion:\n   1. Queen\n   2. Rook\n   3. Bishop\n   4. Knight"
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
