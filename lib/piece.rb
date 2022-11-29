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

  # This method is used by Castle only
  def invert(move)
    return move.map { |num| num * -1 } if move.is_a?(Array)
  end

  # We have completely taken Pawn related code out of make_path
  def make_path(board, start_sq, end_sq)
    path = [start_sq]
    move_set.each do |single_move|
      next_sq = start_sq
      loop do
        next_sq = [next_sq[0] + single_move[0], next_sq[1] + single_move[1]]
        break unless board.squares.include?(next_sq)

        path << next_sq
        return path if next_sq == end_sq
        break unless long_reach
      end
      path = [start_sq]
    end
    []
  end

  def make_capture_path(board, start_sq, end_sq)
    make_path(board, start_sq, end_sq)
  end
end

  # refactor
  # Ok, ideas on how we can break up this monstrosity.
  # One way would be to take start_obj and invert out, go through invert
  # first then send the inverted/non-inverted move_set to #make_path, 
  # that would take out one unrelated responsibility.
  # mv_set is used ONLY for Pawn, we should get rid of it.
  # def make_path(board, start_sq, end_sq, mv_set = nil)
  #   mv_set ||= move_set # pawn only
  #   start_obj = board.object(start_sq) # pawn only
  #   path = [start_sq]
  #   mv_set.each do |single_move|
  #     single_move = invert(single_move) if color == 'black' && start_obj.instance_of?(Pawn) # pawn only
  #     next_sq = start_sq
  #     loop do
  #       next_sq = [next_sq[0] + single_move[0], next_sq[1] + single_move[1]]
  #       break unless board.squares.include?(next_sq)

  #       path << next_sq
  #       return path if next_sq == end_sq
  #       break unless long_reach # pawn only
  #     end
  #     path = [start_sq]
  #   end
  #   []
  # end
