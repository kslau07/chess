# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :current_player, :board

  def test; end

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

  def initialize(**args)
    @current_player = args[:current_player] || Player.new
    @board = args[:board] || Board.new

    move_sequence # rename?
  end

  def move_sequence # rename?
    start_sq, end_sq = input_move
    transfer_piece(start_sq, end_sq)
  end

  def input_move
    # start_sq = gets.chomp.split('').map(&:to_i)
    # end_sq = gets.chomp.split('').map(&:to_i)
    # return
    
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
    return false unless capturable?(start_sq, end_sq) # include result of reachable somehow
    return false if path_blocked?(start_sq, end_sq)

    true

    # false if second input is not one of piece's next moves
    # false if puts own king into check
  end

  def reachable?(start_sq, end_sq)
    piece = board_object(start_sq)

    reachable_squares = piece.simple_path(start_sq, piece.color, board_squares)
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
  def capturable?(start_sq, end_sq, reachable = nil)
    own_obj = board_object(start_sq)
    other_obj = board_object(end_sq)
    return false if other_obj == 'unoccupied'
    return false if own_obj.color == other_obj.color
    return true unless own_obj.instance_of?(Pawn)
    # return reachable || reachable?(start_sq, end_sq) unless own_obj.instance_of?(Pawn)
    
    
    # puts own_obj.color
    true



    # return true if own_obj.color != other_obj.color


    # piece = board_object(start_sq)

    # capturable_squares = piece.capturable_squares(start_sq, piece.color, board_squares)
    # capturable_squares.include?(end_sq) ? true : false
  end

  def pawn_captures(pawn, )

  end

  # later use knight_moves algo for path lookup, find first object in path
  def path_blocked?(start_sq, end_sq)
    piece = board_object(start_sq)

    # You will have multiple arrays that represent multiple paths
    # A knight can never be blocked, except by its own piece
    # If the end sq is player's own color, it is blocked
    # You have to use something like knight_moves to create ONE path for
    # pieces that can travel: queen, rook, bishop



    # fix path. it's not what it should be.
    # it should be an array of squares starting AFTER start_sq
    # and it should end on end_sq.
    # use push, then use break to end do early when end_sq is matched in path.
    # simple_path must be rewritten like above description.
    path = piece.simple_path(start_sq, piece.color, board_squares)

    p path

    false

    # if pawn wants move 2 spaces, but is blocked by another pawn:
    # use its path to find first path_object
    # we need a path_taken method

    # check all squares after start_sq for objects
    # first object you encounter: check if end_sq = object_sq
    # check if end_sq, object_sq is capturable, that's a valid turn
    # if end_sq == path_object but is NOT capturable, that's invalid (pawns)
    # if end_sq == capturable but NOT path_object, that's invalid (path is not clear)

    # maybe use this if we get stuck, but 'break' is better than this
    # Find index of end_sq
    # Find index of obj
    # If obj is before end_sq, path is blocked
  end

  def transfer_piece(start_sq, end_sq)
    piece = board_object(start_sq)
    piece.moved
    board.update_square(end_sq, piece) # send message, do not change other's variables
    # board.grid[end_sq[0]][end_sq[1]] = piece
    board.update_square(start_sq, 'unoccupied') # send message, do not change other's variables
    # board.grid[start_sq[0]][start_sq[1]] = 'unoccupied'
  end
end

