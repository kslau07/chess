# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color


  def initialize(color)
    @color = color
  end

  def char

  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end
end