# frozen_string_literal: true

# This creates moves in chess
class Move
  attr_reader :current_player, :board

  def initialize(current_player, board)
    @current_player = current_player
    @board = board
    move_sequence
  end

  # Array of all 64 squares in index notation
  def board_squares
    squares = []
    8.times do |x|
      8.times do |y|
        squares << [x, y]
      end
    end
    squares
  end

  def move_sequence # rename?
    start_sq, end_sq = input_move
    transfer_piece(start_sq, end_sq)
  end

  def transfer_piece(start_sq, end_sq)
    start_piece = board_object(start_sq)
    start_piece.moved
    board.grid[end_sq[0]][end_sq[1]] = start_piece
    board.grid[start_sq[0]][start_sq[1]] = 'unoccupied'
  end

  def input_move
    loop do
      Display.input_start_msg
      start_sq = gets.chomp.split('').map(&:to_i)
      Display.input_end_msg
      end_sq = gets.chomp.split('').map(&:to_i)
      return [start_sq, end_sq] if valid?(start_sq, end_sq)

      Display.invalid_input_message
    end
  end

  def board_object(position_arr)
    board.grid[position_arr[0]][position_arr[1]]
  end

  # fetch uses value for lookup
  # dig uses (value), will not raise error, returns nil on no match

  def valid?(start_sq, end_sq)

    board_obj = board_object(start_sq)
    return false unless board_squares.include?(start_sq) && board_squares.include?(end_sq) # both inputs must be on the board
    return false if board_obj == 'unoccupied' # board sq must not be empty
    return false if board_obj.color != current_player.color # piece must be player's own
    return false unless reachable?(start_sq, end_sq) # false if piece cannot reach end square
    # capturable?
    # return false if path_blocked?(start_sq, end_sq)

    true

    # false if second input is not one of piece's next moves
    # false if puts own king into check
  end

  def reachable?(start_sq, end_sq)
    piece = board_object(start_sq)

    reachable_squares = piece.legal_next_moves(start_sq, piece.color, board_squares)
    puts 'legal move!' if reachable_squares.include?(end_sq)
    reachable_squares.include?(end_sq) ? true : false
  end

  # two types of valid moves:
  # both are identical, except for pawns
  # valid move: end_sq is capturable + path_not_blocked
  # also valid: end_sq is reachable + path_not_blocked

  # you need all 3 methods:
  # reachable?
  # path_blocked?
  # capturable?

  # check if any piece objects (non-capturable) blocking path to end_sq
  def capturable?(start_sq, end_sq)
    piece = board_object(start_sq)

    capturable_squares = piece.capturable_squares(start_sq, piece.color, board_squares)
    capturable_squares.include?(end_sq) ? true : false
  end

  # later use knight_moves algo for path lookup, find first object in path
  def path_blocked?(start_sq, end_sq)
    # if pawn wants move 2 spaces, but is blocked by another pawn:
    # use its path to find first path_object
    # we need a path_taken method

    # check all squares after start_sq for objects
    # first object you encounter: check if end_sq = object_sq
    # check if end_sq, object_sq is capturable, that's a valid turn
    # if end_sq == path_object but is NOT capturable, that's invalid (pawns)
    # if end_sq == capturable but NOT path_object, that's invalid (path is not clear)
  end
end

