# frozen_string_literal: true

# This is the class for chess
class Chess
  attr_reader :board, :player1, :player2, :current_player

  def initialize(board = nil, player1 = nil, player2 = nil)
    @board = board || Board.new
    @player1 = player1 || Player.new(color: 'white')
    @player2 = player2 || Player.new(color: 'black')
    @current_player = @player1
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
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

  def setup_board(chess_pieces)
    (0..1).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] }
    (0..1).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] }

    # We can combine these 2 lines somehow. Do it later.
    # (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] }
    # (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] }
  end

  def play
    Display.greeting
    Display.draw_board(board)

    4.times { turn_loop }

    # turn_loop until game_over?
  end

  def game_over?
    false
  end

  def turn_loop
    Display.turn_message(current_player.color)
    move_sequence
    Display.draw_board(board)
    switch_players
  end

  def move_sequence
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
  # dig uses (), returns nil, no error raised

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

  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end
