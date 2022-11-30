# frozen_string_literal: true

# This class represents knights in chess
class Knight < Piece
  # include Serializable
  # attr_reader :color, :unmoved, :long_reach

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

  private

  def move_set
    [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]].freeze
  end
end
