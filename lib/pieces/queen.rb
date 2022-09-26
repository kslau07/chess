# frozen_string_literal: true

# This class represents the queen in chess
class Queen < Piece
  attr_reader :color, :unmoved

  def post_initialize(**args)
    @unmoved = true
    @multi_stepper = true
  end

  def to_s
    color == 'white' ? '♕' : '♛'
  end

  def moved
    @unmoved = false
  end

  private

  def predefined_moves
    [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
  end
end
