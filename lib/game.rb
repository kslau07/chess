# frozen_string_literal: true

# This is the class for chess
class Game
  attr_reader :board, :player1, :player2, :current_player, :move

  def initialize(**args)
    @board = args[:board] || Board.new
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
  end

  def setup_board(chess_pieces)

    # # bishops
    # board.grid[2][3] = PieceFactory.create('Bishop', 'white')
    # board.grid[4][3] = PieceFactory.create('Bishop', 'black')

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
    create_move # use factory later
    Display.draw_board(board)
    switch_players
  end

  # use to factory later
  def create_move
    @move = Move.new(current_player: current_player, board: board)
  end

  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end
