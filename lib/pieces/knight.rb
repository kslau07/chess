# frozen_string_literal: true

# This class represents knights in chess
class Knight < Piece
  def post_initialize
    @unmoved = true
    @long_reach = false
  end

  def to_s
    color == 'white' ? "\u2658" : "\u265E"
  end

  def moved
    @unmoved = false
  end

  def possible_moves
    move_set
  end

  private

  def move_set
    [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]].freeze
  end
end
