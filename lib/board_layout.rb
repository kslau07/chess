# frozen_string_literal: true

# This class holds different board setups for chess
class BoardLayout
  attr_reader :board, :current_player, :move_list, :game

  def normal(chess_pieces)
    (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] } # front row
    (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] } # front row
    (0..7).each { |x| board.grid[0][x] = chess_pieces[:white_pcs][x+8] } # back row
    (0..7).each { |x| board.grid[7][x] = chess_pieces[:black_pcs][x+8] } # back row
  end

  def initialize(args)
    @board = args[:board]
    @current_player = args[:current_player]
    @move_list = args[:move_list]
    @game = args[:game]
  end

  def checkmate_scenarios
    # game.instance_variable_set(:@current_player, Player.new(color: 'black')) # player = black

    board.grid[5][0] = PieceFactory.create('King', 'white')
    board.grid[6][2] = PieceFactory.create('Rook', 'white')
    board.grid[5][3] = PieceFactory.create('Rook', 'white')

    board.grid[7][5] = PieceFactory.create('King', 'black')
    # board.grid[5][2] = PieceFactory.create('Knight', 'black')
    # board.grid[0][1] = PieceFactory.create('Rook', 'black')

    # seq = ["Pd2d4", "Pa7a6", "Pd4d5", "Pe7e5"]
    # move_list.instance_variable_set(:@all_moves, seq)
  end

  def self_check
    game.instance_variable_set(:@current_player, Player.new(color: 'black')) # player = black
    seq = ["Pd2d4", "Pa7a6", "Pd4d5", "Pe7e5"]

    board.grid[0][7] = PieceFactory.create('King', 'white')
    board.grid[7][1] = PieceFactory.create('Rook', 'white')
    # board.grid[7][3] = PieceFactory.create('Rook', 'white')

    board.grid[6][7] = PieceFactory.create('King', 'black')
    board.grid[1][0] = PieceFactory.create('Rook', 'black')
    board.grid[6][2] = PieceFactory.create('Rook', 'black') # both rooks create checkmate

    move_list.instance_variable_set(:@all_moves, seq)
  end

  def pawn_vs_pawn
    # game.instance_variable_set(:@current_player, Player.new(color: 'black'))
    board.grid[1][1] = PieceFactory.create('Pawn', 'white')
    board.grid[5][3] = PieceFactory.create('Pawn', 'white')
    board.grid[1][6] = PieceFactory.create('Pawn', 'white')
    board.grid[2][1] = PieceFactory.create('Pawn', 'black')
    board.grid[6][3] = PieceFactory.create('Pawn', 'black')
    board.grid[6][2] = PieceFactory.create('Pawn', 'black')

    board.grid[0][4] = PieceFactory.create('King', 'white')
    board.grid[7][4] = PieceFactory.create('King', 'black')
  end
  
  def castle
    game.instance_variable_set(:@current_player, Player.new(color: 'black'))
    
    # test check
    # board.grid[5][4] = PieceFactory.create('Bishop', 'white') # check black king, king side
    board.grid[2][4] = PieceFactory.create('Bishop', 'black') # check white king, king side

    # white
    board.grid[0][0] = PieceFactory.create('Rook', 'white')
    board.grid[0][4] = PieceFactory.create('King', 'white')
    board.grid[0][7] = PieceFactory.create('Rook', 'white')

    # black
    board.grid[7][0] = PieceFactory.create('Rook', 'black')
    board.grid[7][4] = PieceFactory.create('King', 'black')
    board.grid[7][7] = PieceFactory.create('Rook', 'black')
  end

  def en_passant_white_version1
    puts "\n\t#{self.class}##{__method__}\n "

    @current_player = @player1

    # white, black pass on right
    # seq = ["Pd2d4+", "Pa7a6+", "Pd4d5+", "Pe7e5+"] # valid en passant
    seq = ["Pd2d4+", "Pe7e6+", "Pd4d5+", "Pe6e5+"] # invalid, blk pawn moved twice in list
    board.grid[4][3] = PieceFactory.create('Pawn', 'white')
    board.grid[4][4] = PieceFactory.create('Pawn', 'black')

    # white, black pass on left
    # seq = ["Pd2d4+", "Ph7h6+", "Pd4d5+", "Pc7c5+"] # valid en passant
    # seq =  ["Pd2d4+", "Pc7c6+", "Pd4d5+", "Pc6c5+"] # invalid, blk pawn moved twice in list
    # board.grid[4][3] = PieceFactory.create('Pawn', 'white')
    # board.grid[4][2] = PieceFactory.create('Pawn', 'black')
    
    # test if self-check works
    # board.grid[5][3] = PieceFactory.create('Rook', 'black')

    board.grid[0][3] = PieceFactory.create('King', 'white')
    board.grid[7][4] = PieceFactory.create('King', 'black')
    move_list.instance_variable_set(:@all_moves, seq)
  end

  def en_passant_white_version2
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

    # kings
    board.grid[0][4] = PieceFactory.create('King', 'white')
    board.grid[7][3] = PieceFactory.create('King', 'black')
    move_list.instance_variable_set(:@all_moves, seq)
  end

  def w_pawn_attack
    @current_player = @player1

    # white, black right side
    board.grid[3][3] = PieceFactory.create('Pawn', 'white')
    board.grid[4][2] = PieceFactory.create('Pawn', 'black')
  end

  def b_pawn_attack
    @current_player = @player2

    board.grid[5][6] = PieceFactory.create('Pawn', 'black')
    board.grid[4][5] = PieceFactory.create('Pawn', 'white')

    board.object([5, 6]).instance_variable_set(:@unmoved, false)
  end

  def en_passant_black
    game.instance_variable_set(:@current_player, Player.new(color: 'black'))

    # black, white passes on right
    seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pe2e4+"] # valid
    # seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pe3e4+"] # invalid
    board.grid[3][4] = PieceFactory.create('Pawn', 'white')
    board.grid[3][3] = PieceFactory.create('Pawn', 'black') # en passant -> d4e3

    # black, white passes on left
    # seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pc2c4+"] # valid
    # seq = ["Pa2a3+", "Pd7d5+", "Pg2g4+", "Pd5d4+", "Pe3e4+"] # invalid
    # board.grid[3][2] = PieceFactory.create('Pawn', 'white')
    # board.grid[3][3] = PieceFactory.create('Pawn', 'black')

    # rooks test for self-check
    board.grid[2][3] = PieceFactory.create('Rook', 'white')
    board.grid[7][7] = PieceFactory.create('Rook', 'black')

    board.grid[0][4] = PieceFactory.create('King', 'white')
    board.grid[7][3] = PieceFactory.create('King', 'black')
    move_list.instance_variable_set(:@all_moves, seq)
  end
end
