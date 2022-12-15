# frozen_string_literal: true

# This class represents the queen in chess
class Queen < Piece
  def post_initialize
    @unmoved = true
    @long_reach = true
  end

  def to_s
    color == 'white' ? "\u2655" : "\u265B"
  end

  def moved
    @unmoved = false
  end

  def possible_moves
    move_set
  end

  private

  def move_set
    [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]].freeze
  end
end
