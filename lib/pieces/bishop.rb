# frozen_string_literal: true

# This class represents bishops in chess
class Bishop < Piece
  # include Serializable
  # attr_reader :color, :unmoved, :long_reach

  def post_initialize
    # @class_name = self.class
    # @unmoved = true
    @long_reach = true
  end

  def to_s
    color == 'white' ? "\u2657" : "\u265D"
  end

  def moved
    @unmoved = false
  end

  private

  def move_set
    [[1, -1], [1, 1], [-1, -1], [-1, 1]].freeze
  end
end
