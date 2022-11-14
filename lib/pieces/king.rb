# frozen_string_literal: true

# This class represents the king in chess
class King < Piece
  # include Serializable
  # attr_reader :color, :unmoved, :long_reach

  def post_initialize
    # @class_name = self.class
    # @unmoved = true
    @long_reach = false
  end

  def to_s
    color == 'white' ? "\u2654" : "\u265A"
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
