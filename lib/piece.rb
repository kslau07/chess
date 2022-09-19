# This is the super class for all chess pieces
class Piece
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
end

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved

  # first we use initialize with super
  # later we will switch to post_initialization

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
    if unmoved
      [[1, 0], [2, 0]]
    else
      [[1, 0]]
    end
  end

  def predefined_capture_moves
    [[1, -1], [1, 1]]
  end

  def capturable_squares(start_pt, color, board_squares)
    predefined_capture_moves.map do |predefined_capture_move|
      predefined_capture_move = invert(predefined_capture_move) if color == 'black'
      move = [predefined_capture_move[0] + start_pt[0], predefined_capture_move[1] + start_pt[1]]
      board_squares.include?(move) ? move : nil
    end
  end
end

# This class represents bishops in chess
class Bishop < Piece
  attr_reader :color, :unmoved

  # first we use initialize with super
  # later we will switch to post_initialization

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
    if unmoved
      [[1, 0], [2, 0]]
    else
      [[1, 0]]
    end
  end

  def predefined_capture_moves
    [[1, -1], [1, 1]]
  end

  def capturable_squares(start_pt, color, board_squares)
    predefined_capture_moves.map do |predefined_capture_move|
      predefined_capture_move = invert(predefined_capture_move) if color == 'black'
      move = [predefined_capture_move[0] + start_pt[0], predefined_capture_move[1] + start_pt[1]]
      board_squares.include?(move) ? move : nil
    end
  end
end