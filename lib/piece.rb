# frozen_string_literal: true

# This is the super class for all chess pieces
class Piece
  # first we use initialize with super
  # later we will switch to post_initialization

  def initialize(**args)
    @color = args[:color] || 'white'
    post_initialization(**args)
  end

  def post_initialization(**args)
    raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def find_route(start_sq, end_sq)
    case self.class.name
    when 'Pawn'
      stage_piece(start_sq, end_sq)
    when 'Bishop'
      stage_piece(start_sq, end_sq)
    end
  end

  def stage_piece(start_sq, end_sq)
    generate_path(start_sq, end_sq)
  end

  def invert(move)
    move.map { |num| num * -1 }
  end

  def generate_path(start_sq, end_sq)
    path = []
    board_squares = Board.board_squares
    predefined_moves.each do |predefined_move|
      predefined_move = invert(predefined_move) if color == 'black' && instance_of?(Pawn)
      next_sq = start_sq
      loop do
        next_sq = [next_sq[0] + predefined_move[0], next_sq[1] + predefined_move[1]]
        break unless board_squares.include?(next_sq)

        path << next_sq
        return path if next_sq == end_sq
        # break if next_sq == end_sq
      end
      # path = []
      # path.include?(end_sq) ? (return path) : (path = [])
    end
    path = []
  end
end
# path = [] unless path.include?(end_sq)
# return path if path.include?(end_sq) # break iteration early for queen, bishop, rook

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved

  def post_initialization(**args)
    @unmoved = true
  end

  # def initialize(**args)
  #   super
  #   @unmoved = true
  # end

  def to_s
    color == 'white' ? '♙' : '♟'
  end

  def moved
    @unmoved = false
  end

  private

  def predefined_moves
    if unmoved
      [[1, 0], [2, 0]]
    else
      [[1, 0]]
    end
  end

  def predefined_capture_moves
    [[1, -1], [1, 1]]
  end
end

# This class represents bishops in chess
class Bishop < Piece
  attr_reader :color, :unmoved

  def post_initialization(**args)
    @unmoved = true
  end

  # def initialize(**args)
  #   super
  #   @unmoved = true
  #   # @long_distance_traveler = true # keep this variable? rename?
  # end

  def to_s
    color == 'white' ? '♗' : '♝'
  end

  def moved
    @unmoved = false
  end

  private # try this first

  def predefined_moves
    [[1, -1], [1, 1], [-1, -1], [-1, 1]]
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

  # def predefined_moves
  #   move_directions = [[1, -1], [1, 1], [-1, -1], [-1, 1]]
  #   generate_path(move_directions)
  # end


  # def capturable_squares(start_sq, color, board_squares)
  #   predefined_capture_moves.map do |predefined_capture_move|
  #     predefined_capture_move = invert(predefined_capture_move) if color == 'black'
  #     move = [predefined_capture_move[0] + start_sq[0], predefined_capture_move[1] + start_sq[1]]
  #     board_squares.include?(move) ? move : nil
  #   end
  # end

    # path_one: pawns, knights, the king
  # What do we want from this method?
  # We already check if start/end are in bounds earlier. No need to do that.
  # With pawn: take its path, which could be one or two moves,
  # match it with end_sq, then return that path. The path could contain
  # one or two arrays, depending on if pawn moves 1 or 2 spaces.
  # def path_one(start_sq, end_sq, board_squares)
  #   path = []
  #   predefined_moves.each do |predefined_step|
  #     next_move = [predefined_step[0] + start_sq[0], predefined_step[1] + start_sq[1]]
  #     path << next_move
  #     break if next_move == end_sq

  #     path = [] # clear path if it's not one that includes end_sq
  #   end
  #   path
  # end
