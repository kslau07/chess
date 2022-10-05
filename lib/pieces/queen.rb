# frozen_string_literal: true

# This class represents the queen in chess
class Queen < Piece
  # include Serializable
  attr_reader :color, :unmoved, :long_reach

  def post_initialize(args)
    @class_name = self.class
    @unmoved = true
    @long_reach = true
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
