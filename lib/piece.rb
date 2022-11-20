# frozen_string_literal: true

require 'json'
require_relative 'serializable'
require_relative 'chess_tools'

# This is the superclass for all chess pieces
class Piece
  include Serializable
  include ChessTools
  attr_reader :color, :unmoved, :long_reach

  def initialize(**args)
    @color = args[:color] || 'white'
    @class_name = self.class
    @unmoved = true
    post_initialize
  end

  def post_initialize
    raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def invert(move)
    return move.map { |num| num * -1 } if move.is_a?(Array)
  end

  def pre_gen_path(board, start_sq, end_sq, pdf_moves = nil)

  end

  # break up into smaller methods
  # Ok, ideas on how we can break up this monstrosity.
  # One way would be to take start_obj and invert out, go through invert
  # first then send the inverted/non-inverted move_set to #generate_path, 
  # that would take out one unrelated responsibility.
  # pdf_moves is used ONLY for Pawn
  def generate_path(board, start_sq, end_sq, pdf_moves = nil)
    pdf_moves ||= move_set # we may not use this
    start_obj = board.object(start_sq)
    path = [start_sq]
    pdf_moves.each do |pdf_move|
      pdf_move = invert(pdf_move) if color == 'black' && start_obj.instance_of?(Pawn)
      next_sq = start_sq
      loop do
        next_sq = [next_sq[0] + pdf_move[0], next_sq[1] + pdf_move[1]]
        break unless board.squares.include?(next_sq)

        path << next_sq
        return path if next_sq == end_sq
        break unless long_reach
      end
      path = [start_sq]
    end
    []
  end

  def generate_attack_path(board, start_sq, end_sq)
    generate_path(board, start_sq, end_sq)
  end
end
