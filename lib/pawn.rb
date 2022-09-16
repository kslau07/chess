# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color

  def initialize(color)
    @color = color
    @has_moved = false
  end

  def move_pattern
    [1][0]
  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end
end