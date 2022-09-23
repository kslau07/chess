# frozen_string_literal: true

# This class represents bishops in chess
class Bishop < Piece
  attr_reader :color, :unmoved

  def post_initialization(**args)
    @unmoved = true
  end
  
  def to_s
    color == 'white' ? '♗' : '♝'
  end

  def moved
    @unmoved = false
  end

  private

  def predefined_moves
    [[1, -1], [1, 1], [-1, -1], [-1, 1]]
  end
end