# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :current_player, :board

  def test; end

  # Array of all 64 squares in index notation
  def board_squares
    Board.board_squares
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

  # add string matching later
  def input_move
    # start_sq = gets.chomp.split('').map(&:to_i)
    # end_sq = gets.chomp.split('').map(&:to_i)
    # return

    loop do
      Display.input_start_msg
      start_sq = gets.chomp.split('').map(&:to_i)
      Display.input_end_msg
      end_sq = gets.chomp.split('').map(&:to_i)
      return [start_sq, end_sq] if move_valid?(start_sq, end_sq)

      Display.invalid_input_message
    end
  end

  def board_object(position_arr)
    return nil if position_arr.nil?

    board.grid[position_arr[0]][position_arr[1]]
  end

  # fetch uses value for lookup -> .fetch(value, dft)
  # dig uses (index), will not raise error, returns nil on no match

  def move_valid?(start_sq, end_sq)
    return false if out_of_bound?(start_sq, end_sq)

    board_obj = board_object(start_sq)
    return false if board_obj == 'unoccupied' # start must not be empty
    return false if board_obj.color != current_player.color # piece must be player's own

    path = board_obj.find_route(start_sq, end_sq)
    return false unless reachable?(end_sq, path) # false if piece cannot reach end square

    # p 'path_obstructed?'
    # p path_obstructed?(path, end_sq)

    return false if path_obstructed?(path, start_sq, end_sq)

    # return false if pawn_capture (or something like that)


    # bishop capture
    # then pawn capture



    # After that, we can write capturable. Tricky for pawn.
    # Then we can attempt En Passant for pawn. (move list needed)

    # Way later:
    # castle, both types, check if unmoved
    # check: put opponent in check, do not put self in check
    # checkmate
    # tie (use move list)

    # return false unless capturable?(start_sq, end_sq) # include result of reachable somehow
    # return false if path_blocked?(start_sq, end_sq)

    true
  end

  def out_of_bound?(start_sq, end_sq)
    board_squares.include?(start_sq) && board_squares.include?(end_sq) ? false : true
  end

  def reachable?(end_sq, path)
    path.include?(end_sq) ? true : false
  end
  # puts 'legal move!' if reachable_squares.include?(end_sq)

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
  end

  # rework some of this logic, seems overly complicated
  def path_obstructed?(path, start_sq, end_sq)
    start_piece = board_object(start_sq)
    first_occupied_sq = path.find { |coord| board.grid[coord[0]][coord[1]].is_a?(Piece) }
    # piece_at_occupied_sq = board_object(first_occupied_sq)
    piece_at_end_sq = board_object(end_sq)

    return false if first_occupied_sq.nil? # path is clear
    return true if end_sq != first_occupied_sq

    if first_occupied_sq == end_sq
      return true if start_piece.color == piece_at_end_sq.color # same color obstruction
    end
    false
  end

  def transfer_piece(start_sq, end_sq)
    return capture_piece(start_sq, end_sq) if board_object(end_sq).is_a?(Piece)

    piece = board_object(start_sq)
    piece.moved
    board.update_square(end_sq, piece)
    board.update_square(start_sq, 'unoccupied')

    # p 'transfer piece'
  end

  def capture_piece(start_sq, end_sq)
    current_piece = board_object(start_sq)
    captured_piece = board_object(end_sq) # Keep track of captures
    current_piece.moved
    board.update_square(end_sq, current_piece)
    board.update_square(start_sq, 'unoccupied')

    # p 'capture piece'
  end
end

