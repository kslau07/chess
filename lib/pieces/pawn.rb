# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved

  def post_initialization(**args)
    @unmoved = true
  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end

  def moved
    @unmoved = false
  end

  private

  def predefined_moves
    [[1, 0]]
    # special pawn moves handled by factory now
    # [[1, 0], [1, -1], [1, 1]]
  end
end
