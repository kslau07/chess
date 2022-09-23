# frozen_string_literal: true

# This is the class for chess
class Game
  attr_reader :board, :player1, :player2, :current_player, :move_list

  def initialize(**args)
    @board = args[:board] || Board.new
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
    @move = Move
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
    layout_castle
    # layout_normal(chess_pieces)

  end

  def layout_castle
    # white
    board.grid[0][0] = PieceFactory.create('Rook', 'white')
    board.grid[0][4] = PieceFactory.create('King', 'white')
    board.grid[0][7] = PieceFactory.create('Rook', 'white')

    # black
    board.grid[7][0] = PieceFactory.create('Rook', 'black')
    board.grid[7][4] = PieceFactory.create('King', 'black')
    board.grid[7][7] = PieceFactory.create('Rook', 'black')
  end

  # delete layouts later
  def layout_normal(chess_pieces)
    (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] } # front row
    (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] } # front row
    (0..7).each { |x| board.grid[0][x] = chess_pieces[:white_pcs][x+8] } # back row
    (0..7).each { |x| board.grid[7][x] = chess_pieces[:black_pcs][x+8] } # back row
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

  # We need to basically immediately get to the Move factory, which will choose
  # among regular move, en passant, castle (and maybe more). We do NOT want to
  # instantiate Move. We will do as Metz did, we will first go through Move
  # class methods, the factory will also be a class method. The factory brings
  # us the instance we need. 

  # We loop new_move if it is not valid, as it's more difficult for us to 
  # know if a move is valid without going through a Move or Move variant instance.

  # create factory for this
  def create_move(new_move = nil)
    loop do
      # new_move = Move.new(current_player: current_player, board: board, move_list: move_list)
      new_move = Move.user_input
      break
    end

    move_list.add(new_move)
    
    # print "move_list: #{move_list}\n"
    puts ">>> last_move: #{move_list.last_move}"
  end


  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end
