# frozen_string_literal: true

# This class represents the king in chess
class King < Piece
  attr_reader :color, :unmoved, :long_reach

  def post_initialize(**args)
    @unmoved = true
    @long_reach = false
  end

  def to_s
    color == 'white' ? '♔' : '♚'
  end

  def moved
    @unmoved = false
  end

  def possible_moves
    predefined_moves
  end

  private

  def predefined_moves
    [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
  end
end
