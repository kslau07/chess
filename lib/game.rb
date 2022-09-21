# frozen_string_literal: true

# This is the class for chess
class Game
  attr_reader :board, :player1, :player2, :current_player, :move_list

  def initialize(**args)
    @board = args[:board] || Board.new
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
    post_initialize(**args)
  end

  def post_initialize(**args)
    @move_list = args[:move_list] || MoveList.new
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
  end

  def setup_board(chess_pieces)
    # delete layouts later

    # layout_normal(chess_pieces)
    layout_en_passant


    # board.grid[3][4] = PieceFactory.create('Queen', 'white')
    # board.grid[4][3] = PieceFactory.create('Queen', 'black')

    # board.grid[5][6] = PieceFactory.create('Pawn', 'white')
    # board.grid[3][7] = PieceFactory.create('Pawn', 'black')
  end

  # delete layouts later
  def layout_normal(chess_pieces)
    (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] } # front row
    (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] } # front row
    (0..7).each { |x| board.grid[0][x] = chess_pieces[:white_pcs][x+8] } # back row
    (0..7).each { |x| board.grid[7][x] = chess_pieces[:black_pcs][x+8] } # back row
  end

  # delete layouts later
  def layout_en_passant
    move_list.instance_variable_set(:@all_moves, ["Pa0+ Pe4+", "Pa0+ Pb1+"])
    board.grid[4][3] = PieceFactory.create('Pawn', 'white')
    board.grid[4][4] = PieceFactory.create('Pawn', 'black')
  end

  def play
    Display.greeting
    Display.draw_board(board)

    5.times { turn_loop }
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
    move = Move.new(current_player: current_player, board: board, move_list: move_list)
    move_list.add(move)
    # print "move_list: #{move_list}\n"
    puts ">>> last_move: #{move_list.last_move}"
  end


  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end
