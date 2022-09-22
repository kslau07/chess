# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :current_player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_piece, :captured_piece, :move_list, :castle

  # Array of all 64 squares in index notation
  def board_squares
    Board.board_squares
  end

  def initialize(**args)
    @current_player = args[:current_player] || Player.new
    @board = args[:board] || Board.new
    @move_list = args[:move_list] || MoveList.new
    move_sequence # rename?
  end

  def move_sequence # rename?
    input_move
    transfer_piece
  end

  # add string matching later
  def input_move

    loop do
      Display.input_start_msg
      @start_sq = gets.chomp.split('').map(&:to_i)
      Display.input_end_msg
      @end_sq = gets.chomp.split('').map(&:to_i)
      return if move_valid?

      # return [start_sq, end_sq] if move_valid?(start_sq, end_sq)

      Display.invalid_input_message
    end
  end

  def board_object(sq_coord)
    return nil if sq_coord.nil? # checks for nil input, maybe delete later

    board.grid.dig(sq_coord[0], sq_coord[1])
  end

  # fetch uses value for lookup -> .fetch(value, dft)
  # dig uses (index), will not raise error, returns nil on no match

  def move_valid?
    @start_piece = board_object(start_sq)
    @end_piece = board_object(end_sq)

    return false if out_of_bound?
    return false if start_piece == 'unoccupied' # start must not be empty
    return false if start_piece.color != current_player.color # start must be player's own piece
    @path = start_piece.generate_path(start_sq, end_sq)
    # p ">>> path inside #move_valid? : #{path}"
    return false unless reachable?
    return false if path_obstructed?(path, start_sq, end_sq)

    true
  end

  def out_of_bound?
    board_squares.include?(start_sq) && board_squares.include?(end_sq) ? false : true
  end

  def reachable?

    return castle? if start_piece.instance_of?(King) && (base_move == [0, 2] || base_move == [0, -2])
    return reachable_by_pawn? if start_piece.instance_of?(Pawn)

    path.include?(end_sq) ? true : false
  end

  def castle?

    corner_piece = ''
    # You cannot exit check with a castle
    # Both King and Rook must be unmoved
    # All spaces between must be empty

    if base_move == [0, 2]
      corner_piece = board_object([start_sq[0] + 0, start_sq[1] + 3])
      return false unless board_object([start_sq[0] + 0, start_sq[1] + 1]) == 'unoccupied'
      return false unless board_object([start_sq[0] + 0, start_sq[1] + 2]) == 'unoccupied'
    elsif base_move == [0, -2]
      corner_piece = board_object([start_sq[0] + 0, start_sq[1] - 4])
      return false unless board_object([start_sq[0] + 0, start_sq[1] - 1]) == 'unoccupied'
      return false unless board_object([start_sq[0] + 0, start_sq[1] - 2]) == 'unoccupied'
      return false unless board_object([start_sq[0] + 0, start_sq[1] - 3]) == 'unoccupied'
    end
    return false unless corner_piece.instance_of?(Rook)
    return false unless start_piece.unmoved && corner_piece.unmoved
    # return false unless

    # Should we transfer pieces here, or 
    # add a variable @castle = true
    # then allow transfer piece to operate
    @castle = true
    true
  end

  def base_move
    # i.e. 2 steps forward would be [2, 0]
    case start_piece.color
    when 'black'
      [start_sq[0] - end_sq[0], start_sq[1] - end_sq[1]]
    when 'white'
      [end_sq[0] - start_sq[0], end_sq[1] - start_sq[1]]
    end
  end

  def reachable_by_pawn?
    return true if move_list.all_moves.size.positive? && en_passant?
    return false if end_piece == 'unoccupied' && (base_move == [1, -1] || base_move == [1, 1])

    path.include?(end_sq) ? (return true) : (return false)
  end

  def en_passant?
    prev_sq = move_list.prev_sq
    relative_diff = [prev_sq[0] - start_sq[0], prev_sq[1] - start_sq[1]]
    if start_piece.color == 'white' && move_list.last_move[0] == 'P'
      return true if relative_diff == [0, 1] && base_move == [1, 1]
      return true if relative_diff == [0, -1] && base_move == [1, -1]
    elsif start_piece.color == 'black' && move_list.last_move[0] == 'P'
      return true if relative_diff == [0, -1] && base_move == [1, 1]
      return true if relative_diff == [0, 1] && base_move == [1, -1]
    end
    false
  end

  # rework some of this logic, seems overly complicated
  def path_obstructed?(path, start_sq, end_sq)
    return false if castle

    start_piece = board_object(start_sq)
    first_occupied_sq = path.find { |subary| board.grid[subary[0]][subary[1]].is_a?(Piece) }
    # piece_at_occupied_sq = board_object(first_occupied_sq)
    piece_at_end_sq = board_object(end_sq)
    return false if first_occupied_sq.nil? # no piece found in path using .find
    return true if end_sq != first_occupied_sq

    if first_occupied_sq == end_sq
      # if pawn is obstructed trying to move 1 or 2 steps forward
      return true if start_piece.instance_of?(Pawn) && first_occupied_sq && (base_move == [1, 0] || base_move == [2, 0])
      return true if start_piece.color == piece_at_end_sq.color # same color obstruction
    end
    false
  end

  def transfer_piece
    return perform_castle if castle
    return en_passant_capture if move_list.all_moves.size.positive? && en_passant?

    @captured_piece = end_piece if end_piece.is_a?(Piece)
    start_piece.moved
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end

  def perform_castle(rook = '', corner = [])
    board.update_square(end_sq, start_piece) # king
    board.update_square(start_sq, 'unoccupied')

    if base_move == [0, 2]
      corner = [start_sq[0] + 0, start_sq[1] + 3]
      new_sq = [start_sq[0] + 0, start_sq[1] + 1]
      rook = board_object(corner)
    elsif base_move == [0, -2]
      corner = [start_sq[0] + 0, start_sq[1] - 4]
      new_sq = [start_sq[0] + 0, start_sq[1] - 1]
      rook = board_object(corner)
    end

    board.update_square(new_sq, rook) # rook
    board.update_square(corner, 'unoccupied')
  end

  def en_passant_capture
    @captured_piece = board_object(move_list.prev_sq)
    board.update_square(end_sq, start_piece)
    board.update_square(move_list.prev_sq, 'unoccupied')
    board.update_square(start_sq, 'unoccupied')
  end
end
