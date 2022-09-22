# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :current_player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_piece, :captured_piece, :move_list

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
    # start_sq = gets.chomp.split('').map(&:to_i)
    # end_sq = gets.chomp.split('').map(&:to_i)
    # return

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
    # p 'start_piece', start_piece

    # puts 'out_of_bound?'
    return false if out_of_bound?

    # puts 'unoccupied'
    return false if start_piece == 'unoccupied' # start must not be empty

    # puts 'current_player.color'
    # puts start_piece.color != current_player.color
    return false if start_piece.color != current_player.color # start must be player's own piece

    @path = start_piece.generate_path(start_sq, end_sq)
    # p "path inside #move_valid? : #{path}"

    puts 'reachable?'
    return false unless reachable?

    puts 'path_obstructed?'
    return false if path_obstructed?(path, start_sq, end_sq)

    puts '>>> ALL CLEAR MOVE VALID'
    true
  end

  def out_of_bound?
    board_squares.include?(start_sq) && board_squares.include?(end_sq) ? false : true
  end

  # Maybe we use this for king check later
  # add this later -> path = nil, path ||= reachable
  def reachable?
    return reachable_by_pawn? if start_piece.instance_of?(Pawn)

    path.include?(end_sq) ? true : false
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
    # puts 'move_list.all_moves.size.positive?', move_list.all_moves.size.positive?
    return true if move_list.all_moves.size.positive? && en_passant?

    return false if end_piece == 'unoccupied' && (base_move == [1, -1] || base_move == [1, 1])

    path.include?(end_sq) ? (return true) : (return false)
  end

  def en_passant?



    prev_sq = move_list.prev_sq
    relative_diff = [prev_sq[0] - start_sq[0], prev_sq[1] - start_sq[1]]
    # puts 'WE HAVE EN PASSANT' if move_list.last_move[0] == 'P' && relative_diff == [0, 1] && base_move == [1, 1]
    
    p ">>>Move#enpassant relative_diff : #{relative_diff}"
    p ">>>Move#enpassant base_move : #{base_move}"
    p ">>>Move#enpassant last_move : #{move_list.last_move}"

    
    return true if move_list.last_move[0] == 'P' && relative_diff == [0, 1] && base_move == [1, 1]

    return true if move_list.last_move[0] == 'P' && relative_diff == [0, -1] && base_move == [1, -1]

    false
    
    # get last move
    # translate it to index notation

    # check even or odd
    # p ">>>Move#en_passant #{move_list.all_moves}"
    # p ">>>Move#enpassant last_move : #{move_list.last_move}" #unless move_list.all_moves.empty?
    # puts '>>> last move was Pe4' if move_list.last_move == 'Pe4'
    # right_sq = [start_sq[0] + 0, start_sq[1] + 1]
    # left_sq = [start_sq[0] + 0, start_sq[1] - 1]

    # board_object(right_sq)


    # if move_list.last_move == 'Pe4' && base_move == [1, 1]
      # return true
    # end


    # @captured_piece = 'pawn that is beside players own pawn'

    # white, left e.p.
    # return true if end_piece == 'unoccupied' && base_move == [1, -1] # && other pawn's last move was 2 spaces and it sits adjacent left
    # white, right e.p.
    # return true if end_piece == 'unoccupied' && base_move == [1, 1] # && other pawn's last move was 2 spaces and it sits adjacent left
  end

  # rework some of this logic, seems overly complicated
  def path_obstructed?(path, start_sq, end_sq)
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
    return en_passant_capture if move_list.all_moves.size.positive? && en_passant?

    @captured_piece = end_piece if end_piece.is_a?(Piece)

    # p 'end_piece', end_piece
    # p 'captured_piece', captured_piece

    # p "end_piece: #{end_piece}"
    # p "captured_piece: #{captured_piece}"

    start_piece.moved
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end

  def en_passant_capture
    @captured_piece = board_object(move_list.prev_sq)
    board.update_square(end_sq, start_piece)
    board.update_square(move_list.prev_sq, 'unoccupied')
    board.update_square(start_sq, 'unoccupied')
  end
end

# # check if any piece objects (non-capturable) blocking path to end_sq
# def capturable?(start_sq, end_sq, reachable = nil)
#   own_obj = board_object(start_sq)
#   other_obj = board_object(end_sq)
#   return false if other_obj == 'unoccupied'
#   return false if own_obj.color == other_obj.color
#   return true unless own_obj.instance_of?(Pawn)
#   # return reachable || reachable?(start_sq, end_sq) unless own_obj.instance_of?(Pawn)
#   # puts own_obj.color
#   true
# end


# by the time pawn gets here, it should be a valid move (it passed #valid?)
# def capture_piece(start_sq, end_sq)
#   current_piece = board_object(start_sq)
#   captured_piece = board_object(end_sq) # Keep track of captures
#   current_piece.moved
#   board.update_square(end_sq, current_piece)
#   board.update_square(start_sq, 'unoccupied')
# end