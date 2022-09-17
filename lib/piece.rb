# This is the super class for all chess pieces
class Piece

  def initialize(color)
    @color = color
  end

  def legal_next_moves(start_pt)
    move_pattern.each
  end
end

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved

  # first we use initialize with super
  # later we will switch to post_initialization

  def initialize(color)
    super
    @unmoved = true
  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end

  private # try this first

  def move_pattern
    if unmoved
      [[1, 0], [2, 0]]
    else
      [[1, 0]]
    end
  end
end
