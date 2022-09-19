# frozen_string_literal: true

# This is the super class for all chess pieces
class Piece
  # first we use initialize with super
  # later we will switch to post_initialization

  def initialize(**args)
    @color = args[:color] || 'white'
  end

  def invert(move)
    move.map { |num| num * -1 }
  end

  def simple_path(start_pt, color, board_squares)
    predefined_moves.map do |predefined_move|
      predefined_move = invert(predefined_move) if color == 'black'
      move = [predefined_move[0] + start_pt[0], predefined_move[1] + start_pt[1]]
      board_squares.include?(move) ? move : nil
    end
  end

  def line_arrays(move_directions)
    return move_directions if self.instance_of?(Pawn)

    # goal is to return an array of arrays with 4 directions for the bishop
    array_rename = []
    move_directions.map do |direction|

    end

  end

end

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved

  def initialize(**args)
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
    # move_directions = unmoved ? [[1, 0], [2, 0]] : [[1, 0]]
    # line_arrays(move_directions)

    if unmoved
      [[1, 0], [2, 0]]
    else
      [[1, 0]]
    end
  end

  def predefined_capture_moves
    [[1, -1], [1, 1]]
  end

  # def capturable_squares(start_pt, color, board_squares)
  #   predefined_capture_moves.map do |predefined_capture_move|
  #     predefined_capture_move = invert(predefined_capture_move) if color == 'black'
  #     move = [predefined_capture_move[0] + start_pt[0], predefined_capture_move[1] + start_pt[1]]
  #     board_squares.include?(move) ? move : nil
  #   end
  # end
end

# This class represents bishops in chess
class Bishop < Piece
  attr_reader :color, :unmoved

  # first we use initialize with super
  # later we will switch to post_initialization

  def initialize(**args)
    super
    @unmoved = true
    @long_distance_traveler = true # keep this variable? rename?
  end

  def to_s
    color == 'white' ? '♗' : '♝'
  end

  def moved
    @unmoved = false
  end

  private # try this first

  def predefined_moves
    move_directions = [[1, -1], [1, 1], [-1, -1], [-1, 1]]
    line_arrays(move_directions)
  end
end


"
Fixed-movers
pawns, knights, and the king

Long-distance travelers
bishops, rooks, and the queen

Pawns are especially tricky. They're the only piece whose capture
direction is different from its move direction.

We can use predefined_moves for pawns, knights, and the king. That method
name is perfect. But it doesn't fit bishops, rooks, and the queen.

The king and knight are not exactly like the pawn. They can move in any
direction, but only ONE unit.

The pawn can move forward only, and its first move can be 1 or 2 squares.

The reason I am conflating the pawn, the knight, and the king, I believe is
because the size of their move array is small.
"
