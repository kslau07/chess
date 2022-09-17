# This is the super class for all chess pieces
class Piece

  def initialize(color)
    @color = color
  end

  def invert(move)
    move.map { |num| num * -1 }
  end

  def legal_next_moves(start_pt, color, board_squares)
    predefined_moves.map do |predefined_move|
      predefined_move = invert(predefined_move) if color == 'black'
      move = [predefined_move[0] + start_pt[0], predefined_move[1] + start_pt[1]]
      board_squares.include?(move) ? move : nil
    end
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

  def moved
    @unmoved = false
  end

  private # try this first

  def predefined_moves
    if unmoved
      [[1, 0], [2, 0]]
    else
      [[1, 0]]
    end
  end

  def capturable_squares
    [[1, -1], [1, 1]]
  end
end
