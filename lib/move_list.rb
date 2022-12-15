# frozen_string_literal: true

require_relative 'chess_tools'
require_relative 'serializable'

# This class creates all_movess
class MoveList
  include ChessTools
  include Serializable
  attr_reader :all_moves # :last_move_cleaned

  def initialize(mv_list = nil)
    @all_moves = []
    set(mv_list) unless mv_list.nil?
  end

  def set(mv_list)
    @all_moves = mv_list
  end

  def add(new_move)
    return notate_castling(new_move) if new_move.instance_of?(Castling)

    notate(new_move)
  end

  def notate_castling(new_move)
    all_moves << '0-0' if new_move.end_sq[1] == 6
    all_moves << '0-0-0' if new_move.end_sq[1] == 2
  end

  def notate(new_move)
    # add promotion
    # add checkmate
    notation = []
    notation << piece_code(new_move)
    notation << (new_move.start_sq[1] + 97).chr
    notation << new_move.start_sq[0] + 1
    notation << 'x' if new_move.captured_piece
    notation << (new_move.end_sq[1] + 97).chr
    notation << new_move.end_sq[0] + 1
    notation << '+' if new_move.checks
    all_moves << notation.join
  end

  def piece_code(new_move)
    new_move.start_piece.instance_of?(Knight) ? 'N' : new_move.start_piece.class.name[0]
  end

  def last_move_cleaned
    all_moves[-1].gsub(/[^0-9A-Za-h]/, '') unless all_moves.empty? # carat(^) will invert match
  end

  def prev_sq
    translate_notation_to_square_index(last_move_cleaned)
  end

  def prev_move
    all_moves[-1] unless all_moves.empty?
  end

  def prev_move_check?
    prev_move[-1] == '+' unless all_moves.empty?
  end

  def to_s
    @all_moves.to_s
  end
end
