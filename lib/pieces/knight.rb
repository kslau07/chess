# frozen_string_literal: true

# This class represents knights in chess
class Knight < Piece
  attr_reader :color, :unmoved, :long_reach

  def post_initialize(**args)
    @unmoved = true
    @long_reach = false
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
