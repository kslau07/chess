# frozen_string_literal: true

# This class represents the rook in chess
class Rook < Piece
  # include Serializable
  # attr_reader :color, :unmoved, :long_reach

  def post_initialize
    # @class_name = self.class # some variables and attrs can be moved to superclass
    # @unmoved = true
    @long_reach = true
  end

  def to_s
    color == 'white' ? '♖' : '♜'
  end

  def moved
    @unmoved = false
  end

  private

  def move_set
    [[1, 0], [0, 1], [-1, 0], [0, -1]]
  end
end
