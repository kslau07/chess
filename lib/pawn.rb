# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved

  def initialize(color)
    @color = color
    @unmoved = true
  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end

  private # try this first

  def move_pattern
    unmoved ? [[1, 0], [2, 0]] : [[1, 0]]
  end
end
