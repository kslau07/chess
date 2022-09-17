# This is the super class for all chess pieces
class Piece

  def initialize(color)
    @color = color
  end

  def move
    p move_pattern
  end
end
