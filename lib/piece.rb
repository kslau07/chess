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

  def post_initialize(args)
    raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def invert(move)
    # return
    return move.map { |num| num * -1 } if move.is_a?(Array)
  end

  # Unwieldy method, not sure if it can be split
  def generate_path(board, start_sq, end_sq, pdf_moves = nil)
    # puts "\n\t#{self.class}##{__method__}\n "
    pdf_moves ||= move_set # we may not use this
    start_obj = board.object(start_sq)
    path = [start_sq]
    pdf_moves.each do |pdf_move|
      pdf_move = invert(pdf_move) if color == 'black' && start_obj.instance_of?(Pawn)
      next_sq = start_sq
      # i = 0
      loop do
        # i += 1
        # puts ">>> counter: #{i}"
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
    # print 'attack_path', generate_path(board, start_sq, end_sq); puts
    generate_path(board, start_sq, end_sq)
  end
end
