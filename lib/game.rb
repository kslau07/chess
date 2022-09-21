# frozen_string_literal: true

# This is the class for chess
class Game
  attr_reader :board, :player1, :player2, :current_player, :move_list

  def initialize(**args)
    @board = args[:board] || Board.new
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
    post_initialize
  end

  def post_initialize
    @move_list = []
  end

  def setup_board(chess_pieces)
    # board.grid[3][4] = PieceFactory.create('Queen', 'white')
    # board.grid[4][3] = PieceFactory.create('Queen', 'black')

    # board.grid[5][6] = PieceFactory.create('Pawn', 'white')
    # board.grid[3][7] = PieceFactory.create('Pawn', 'black')

    # front row
    (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] }
    (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] }

    # back row
    (0..7).each { |x| board.grid[0][x] = chess_pieces[:white_pcs][x+8] }
    (0..7).each { |x| board.grid[7][x] = chess_pieces[:black_pcs][x+8] }
  end

  def play
    Display.greeting
    Display.draw_board(board)

    50.times { turn_loop }
    # turn_loop until game_over?
  end

  def game_over?
    # check_mate
    # draw
    false
  end

  def turn_loop
    Display.turn_message(current_player.color)
    create_move # use factory later
    Display.draw_board(board)
    switch_players
  end

  # use to factory later
  def create_move
    move = Move.new(current_player: current_player, board: board)
    add_to_move_list(move)
  end

  # option to display move list in regular notation, or human readable format
  def add_to_move_list(move)
    move_list << [move.start_sq, move.end_sq]
    # p move_list
  end

  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end
