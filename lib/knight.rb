# frozen_string_literal: true

# This class represents knights in chess
class Knight < Piece
  attr_reader :color, :unmoved

  def post_initialization(**args)
    @unmoved = true
  end

  def to_s
    color == 'white' ? '♘' : '♞'
  end

  def moved
    @unmoved = false
  end

  private

  def predefined_moves
    [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
  end
end
