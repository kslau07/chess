# frozen_string_literal: true

# This class represents the rook in chess
class Rook < Piece
  def post_initialize
    @unmoved = true
    @long_reach = true
  end

  def to_s
    color == 'white' ? "\u2656" : "\u265C"
  end

  def moved
    @unmoved = false
  end

  def possible_moves
    move_set
  end

  private

  def move_set
    [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze
  end
end
