# frozen_string_literal: true

# This is the class for chess
class Game
  attr_reader :board, :player1, :player2, :current_player, :move, :move_list

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
    # layout_normal(chess_pieces)
    # layout_pawn_vs_pawn
    # layout_en_passant_white_version1
    # layout_en_passant_white_version2
    # layout_en_passant_black
    layout_castle
    # layout_w_pawn_capture
    # layout_b_pawn_capture

  end

  # delete layouts later
  def layout_normal(chess_pieces)
    (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] } # front row
    (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] } # front row
    (0..7).each { |x| board.grid[0][x] = chess_pieces[:white_pcs][x+8] } # back row
    (0..7).each { |x| board.grid[7][x] = chess_pieces[:black_pcs][x+8] } # back row
  end

  def layout_pawn_vs_pawn
    @current_player = @player2
    board.grid[6][1] = PieceFactory.create('Pawn', 'black')
    board.grid[5][0] = PieceFactory.create('Pawn', 'white')
  end
  
  def layout_castle
    @current_player = @player2

    # white
    board.grid[0][0] = PieceFactory.create('Rook', 'white')
    board.grid[0][4] = PieceFactory.create('King', 'white')
    board.grid[0][7] = PieceFactory.create('Rook', 'white')

    # black
    board.grid[7][0] = PieceFactory.create('Rook', 'black')
    board.grid[7][4] = PieceFactory.create('King', 'black')
    board.grid[7][7] = PieceFactory.create('Rook', 'black')
  end

  def layout_en_passant_white_version1
    puts "\n\t#{self.class}##{__method__}\n "

    @current_player = @player1

    # white, black pass on right
    seq = ["Pd2d4+", "Pa7a6+", "Pd4d5+", "Pe7e5+"] # valid en passant
    # seq = ["Pd2d4+", "Pe7e6+", "Pd4d5+", "Pe6e5+"] # invalid, blk pawn moved twice in list
    board.grid[4][3] = PieceFactory.create('Pawn', 'white')
    board.grid[4][4] = PieceFactory.create('Pawn', 'black')

    # white, black pass on left
    # seq = ["Pd2d4+", "Ph7h6+", "Pd4d5+", "Pc7c5+"] # valid en passant
    # seq =  ["Pd2d4+", "Pc7c6+", "Pd4d5+", "Pc6c5+"] # invalid, blk pawn moved twice in list
    # board.grid[4][3] = PieceFactory.create('Pawn', 'white')
    # board.grid[4][2] = PieceFactory.create('Pawn', 'black')

    move_list.instance_variable_set(:@all_moves, seq)
  end

  def layout_en_passant_white_version2
    puts "\n\t#{self.class}##{__method__}\n "

    @current_player = @player1

    # white, black passes on right
    # seq = ["Pg2g4+", "Pc7c6+", "Pg4g5+", "Ph7h5+"] # valid en passant
    # seq = ["Pg2g4+", "Ph7h6+", "Pg4g5+", "Ph6h5+"] # invalid, blk pawn moved twice in list
    # board.grid[4][6] = PieceFactory.create('Pawn', 'white')
    # board.grid[4][7] = PieceFactory.create('Pawn', 'black')

    # white, black passes on left
    # seq = ["Pg2g4+", "Pc7c6+", "Pg4g5+", "Pf7f5+"] # valid en passant
    seq = ["Pg2g4+", "Ph7h6+", "Pg4g5+", "Pf6f5+"] # invalid, blk pawn moved twice in list
    board.grid[4][6] = PieceFactory.create('Pawn', 'white')
    board.grid[4][5] = PieceFactory.create('Pawn', 'black')

    move_list.instance_variable_set(:@all_moves, seq)
  end

  def layout_w_pawn_capture
    @current_player = @player1

    # white, black right side
    board.grid[3][3] = PieceFactory.create('Pawn', 'white')
    board.grid[4][2] = PieceFactory.create('Pawn', 'black')
  end

  def layout_b_pawn_capture
    @current_player = @player2

    board.grid[5][6] = PieceFactory.create('Pawn', 'black')
    board.grid[4][5] = PieceFactory.create('Pawn', 'white')

    board.object([5, 6]).instance_variable_set(:@unmoved, false)
  end

  def layout_en_passant_black
    @current_player = @player2

    # black, white passes on right
    # seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pe2e4+"] # valid
    # seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pe3e4+"] # invalid
    # board.grid[3][4] = PieceFactory.create('Pawn', 'white')
    # board.grid[3][3] = PieceFactory.create('Pawn', 'black')

    # black, white passes on left
    seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pc2c4+"] # valid
    # seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pe3e4+"] # invalid
    board.grid[3][2] = PieceFactory.create('Pawn', 'white')
    board.grid[3][3] = PieceFactory.create('Pawn', 'black')

    move_list.instance_variable_set(:@all_moves, seq)
  end

  def play
    Display.greeting    # change Display to display somehow
    Display.draw_board(board)

    40.times { turn_loop }
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
    # puts "\n\t#{self.class}##{__method__}\n "

    # p move_list

    loop do
      new_move = move.prefactory(current_player, board, move_list) # rename
      break if new_move.validated

      Display.invalid_input_message
    end

    move_list.add(new_move)

    puts "\n\tmove_list: #{move_list}\n"
    # puts "\n\tlast_move: #{move_list.last_move}\n"
  end


  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end

# new_move = Move.new(current_player: current_player, board: board, move_list: move_list)