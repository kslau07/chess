# frozen_string_literal: true

# This class represents bishops in chess
class Bishop < Piece
  def post_initialize
    @unmoved = true
    @long_reach = true
  end

  def to_s
    color == 'white' ? "\u2657" : "\u265D"
  end

  def moved
    @unmoved = false
  end

  def possible_moves
    move_set
  end

  private

  def move_set
    [[1, -1], [1, 1], [-1, -1], [-1, 1]].freeze
  end
end
