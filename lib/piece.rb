# frozen_string_literal: true

# This is the super class for all chess pieces
class Piece
  # first we use initialize with super
  # later we will switch to post_initialization

  def initialize(**args)
    @color = args[:color] || 'white'
  end

  def generate_path(start_sq, end_sq, pc_color, board_squares)
    case self.class.name
    when 'Pawn'
      path_one(start_sq, end_sq, pc_color, board_squares)
    when 'Bishop'
      path_two(start_sq, end_sq, pc_color, board_squares)
    end
  end

  def invert(move)
    move.map { |num| num * -1 }
  end

  # path_one: pawns, knights, the king
  def path_one(start_sq, end_sq, pc_color, board_squares)
    predefined_moves.map do |predefined_move|
      predefined_move = invert(predefined_move) if pc_color == 'black' && instance_of?(Pawn)

      move = [predefined_move[0] + start_sq[0], predefined_move[1] + start_sq[1]]
      board_squares.include?(move) ? move : nil
    end
  end

  # path_two: bishop, rook, the queen
  def path_two(start_sq, end_sq, pc_color, board_squares)
    var_name = travel_directions
    line_arrays(var_name, start_sq, end_sq, board_squares)
  end

  # to keep symmetry and reusability at a maximum
  # we will forgo some optimization
  # do not stop when we find end_sq
  # simply produce all predefined paths
  # we will create another method
  # which will filter out the bad paths
  # for ALL pieces

  # Right now this stops when we match end_sq
  # Forget about that, it adds complexity to our method
  # and the moves are few enough where it doesn't matter now.
  def line_arrays(travel_directions, start_sq, end_sq, board_squares)
    subarray = []
    travel_directions.each do |travel_direction|
      next_sq = start_sq
      loop do
        next_sq = [next_sq[0] + travel_direction[0], next_sq[1] + travel_direction[1]]
        break unless board_squares.include?(next_sq)

        subarray << next_sq
        break if next_sq == end_sq
      end
      subarray = [] unless subarray.include?(end_sq)

      # Change to one-liner
      if subarray.include?(end_sq)
        p subarray
        return subarray
      end
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

  # def capturable_squares(start_sq, color, board_squares)
  #   predefined_capture_moves.map do |predefined_capture_move|
  #     predefined_capture_move = invert(predefined_capture_move) if color == 'black'
  #     move = [predefined_capture_move[0] + start_sq[0], predefined_capture_move[1] + start_sq[1]]
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

  # def predefined_moves
  #   move_directions = [[1, -1], [1, 1], [-1, -1], [-1, 1]]
  #   line_arrays(move_directions)
  # end

  def travel_directions
    p 'travel directions'
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
