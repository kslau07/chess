# frozen_string_literal: true

# This class is mainly used for testing
# This class configures different layouts for the Board class
class BoardConfig
  attr_reader :board, :current_player, :move_list, :game,
              :wht_pawn, :wht_bishop, :wht_rook, :wht_knight,
              :wht_queen, :wht_king, :blk_pawn, :blk_bishop,
              :blk_rook, :blk_knight, :blk_queen, :blk_king

  def initialize(board, layout, move_list = nil)
    @board = board
    @board.create_new_grid # clears grid
    @move_list = move_list
    create_pieces(PieceFactory)
    send(layout)
  end

  def create_pieces(pc_factory)
    @wht_pawn = pc_factory.create('Pawn', 'white')
    @wht_bishop = pc_factory.create('Bishop', 'white')
    @wht_rook = pc_factory.create('Rook', 'white')
    @wht_knight = pc_factory.create('Knight', 'white')
    @wht_queen = pc_factory.create('Queen', 'white')
    @wht_king = pc_factory.create('King', 'white')
    @blk_pawn = pc_factory.create('Pawn', 'black')
    @blk_bishop = pc_factory.create('Bishop', 'black')
    @blk_rook = pc_factory.create('Rook', 'black')
    @blk_knight = pc_factory.create('Knight', 'black')
    @blk_queen = pc_factory.create('Queen', 'black')
    @blk_king = pc_factory.create('King', 'black')
  end

  def standard
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }

    (0..7).each do |sq|
      board.grid[1][sq] = pieces[:white_pcs][sq]
      board.grid[6][sq] = pieces[:black_pcs][sq]
      board.grid[0][sq] = pieces[:white_pcs][sq + 8]
      board.grid[7][sq] = pieces[:black_pcs][sq + 8]
    end
  end
   
  def pawn_checks_king
    board.grid[6][2] = blk_pawn
    board.grid[2][3] = blk_pawn
    board.grid[5][3] = wht_queen
    board.grid[0][4] = wht_king
    board.grid[7][4] = blk_king
    mv_list = %w[Qh2c2]
    move_list.set(mv_list)
  end

  def fix_check_checkmate
    board.grid[1][3] = wht_rook
    board.grid[3][3] = blk_rook
    board.grid[0][4] = wht_king
    board.grid[7][5] = blk_king
  end

  def pawn_move
    board.grid[1][3] = wht_pawn
    board.grid[6][3] = blk_pawn
    # board.grid[4][3] = wht_pawn # wht pawn blocks blk pawn
    # board.grid[2][3] = blk_pawn # blk pawn blocks wht pawn
    board.grid[0][4] = wht_king
    board.grid[7][5] = blk_king
    mv_list = %w[Kg8f8]
    move_list.set(mv_list)
  end

  def path_obstruction_wht
    board.grid[1][3] = wht_rook
    board.grid[3][3] = blk_rook
    board.grid[0][4] = wht_king
    board.grid[7][5] = blk_king
    # mv_list = %w[Kg8f8 Rc7c6 Kf8g8 Rd5d6 Kg8f8 Rc6c7]
    # move_list.set(mv_list)
  end

  def obstruct_path_pawn_wht
    board.grid[1][1] = wht_pawn
    board.grid[1][3] = wht_pawn
    board.grid[2][1] = blk_pawn
    board.grid[3][3] = blk_pawn
    board.grid[0][4] = wht_king
    board.grid[7][5] = blk_king
    # mv_list = %w[Kg8f8 Rc7c6 Kf8g8 Rd5d6 Kg8f8 Rc6c7]
    # move_list.set(mv_list)
  end

  def obstruct_path_pawn_blk
    board.grid[4][1] = wht_pawn
    board.grid[5][3] = wht_pawn
    board.grid[5][4] = wht_pawn
    board.grid[6][1] = blk_pawn
    board.grid[6][3] = blk_pawn
    board.grid[6][7] = blk_pawn
    board.grid[0][4] = wht_king
    board.grid[7][5] = blk_king
    mv_list = %w[Kg8f8]
    move_list.set(mv_list)
  end

  def pawn_capture_wht
    board.grid[5][1] = wht_pawn
    board.grid[6][2] = blk_queen
    board.grid[0][4] = wht_king
    board.grid[7][4] = blk_king
  end

  def pawn_capture_blk
    board.grid[6][2] = blk_pawn
    board.grid[2][3] = blk_pawn
    board.grid[5][3] = wht_queen
    board.grid[0][4] = wht_king
    board.grid[7][4] = blk_king
    mv_list = %w[Qh2c2]
    move_list.set(mv_list)
  end
  
  def checkmate_wht_1
    board.grid[5][0] = wht_king
    board.grid[6][2] = wht_rook
    board.grid[5][3] = wht_rook
    board.grid[7][5] = blk_king
    mv_list = %w[Kg8f8 Rc7c6 Kf8g8 Rd5d6 Kg8f8 Rc6c7]
    move_list.set(mv_list)
  end
  
  def checkmate_blk_1
    board.grid[2][2] = blk_rook
    board.grid[3][3] = blk_rook
    board.grid[5][0] = blk_king
    board.grid[0][5] = wht_king
    mv_list = %w[Ke1f1]
    move_list.set(mv_list)
  end

  def pawn_promotion
    board.grid[6][2] = wht_pawn
    board.grid[5][7] = wht_king
    board.grid[1][1] = blk_pawn
    board.grid[5][0] = blk_king
  end

  # Test that player cannot self-check
  def check_self_wht
    board.grid[0][5] = wht_rook
    board.grid[0][2] = blk_rook
    board.grid[0][7] = wht_king
    board.grid[6][7] = blk_king
    mv_list = %w[Re1d1 Ra1b1 Rd1f1 Rb1c1]
    move_list.set(mv_list)
  end

  def check_self_blk
    board.grid[0][5] = blk_rook
    board.grid[0][2] = wht_rook
    board.grid[0][7] = blk_king
    board.grid[6][7] = wht_king
    mv_list = %w[Re1d1 Ra1b1 Rd1f1 Rb1c1 Kh2h1]
    move_list.set(mv_list)
  end



  def castling_valid_wht
    board.grid[0][0] = wht_rook
    board.grid[0][4] = wht_king
    board.grid[0][7] = wht_rook
    board.grid[7][4] = blk_king
  end

  # Invalid castling because bishop will check king
  def castling_invalid_wht
    board.grid[0][0] = wht_rook
    board.grid[0][4] = wht_king
    board.grid[0][7] = wht_rook
    board.grid[2][4] = blk_bishop
    board.grid[7][0] = blk_rook
    board.grid[7][4] = blk_king
    board.grid[7][7] = blk_rook
  end

  def castling_valid_blk
    board.grid[0][4] = wht_king
    board.grid[7][0] = blk_rook
    board.grid[7][4] = blk_king
    board.grid[7][7] = blk_rook
    mv_list = %w[Qh2c2]
    move_list.set(mv_list)
  end

  def castling_invalid_blk
    board.grid[5][4] = wht_bishop
    board.grid[0][4] = wht_king
    board.grid[7][0] = blk_rook
    board.grid[7][4] = blk_king
    board.grid[7][7] = blk_rook
    mv_list = %w[Qh2c2]
    move_list.set(mv_list)
  end

  def castling_invalid_blk2
    board.grid[7][6] = wht_knight
    board.grid[0][4] = wht_king
    board.grid[7][0] = blk_rook
    board.grid[7][4] = blk_king
    board.grid[7][7] = blk_rook
    mv_list = %w[Qh2c2]
    move_list.set(mv_list)
  end

  def en_passant_wht_right
    mv_list = ['Pd2d4', 'Pa7a6+', 'Pd4d5', 'Pe7e5'] # valid en passant
    # mv_list = ['Pd2d4+', 'Pe7e6+', 'Pd4d5+', 'Pe6e5+'] # invalid, blk pawn moved twice in list
    board.grid[4][3] = wht_pawn
    board.grid[4][4] = blk_pawn
    board.grid[4][2] = blk_pawn # this pawn shouldn't be able to be captured

    move_list.set(mv_list)
  end

  def en_passant_wht_left
    # white, black pass on left
    mv_list = ['Pd2d4+', 'Ph7h6+', 'Pd4d5+', 'Pc7c5+'] # valid en passant
    # mv_list =  ['Pd2d4+', 'Pc7c6+', 'Pd4d5+', 'Pc6c5+'] # invalid, blk pawn moved twice in list    # board.grid[4][3] = wht_pawn
    board.grid[4][2] = blk_pawn
    board.grid[0][3] = wht_king
    board.grid[7][4] = blk_king
    move_list.set(mv_list)
  end

  def en_passant_black_right
    # black, white passes on right
    mv_list = ['Pa2a3+', 'Pd7d5+', 'Pg2g4+', 'Pd5d4+', 'Pe2e4+'] # valid
    # mv_list = ['Pa2a3+', 'Pd7d5+', 'Pg2g4+', 'Pd5d4+', 'Pe3e4+'] # invalid
    board.grid[3][4] = wht_pawn
    board.grid[3][3] = blk_pawn # en passant -> d4e3
    board.grid[0][4] = wht_king
    board.grid[7][3] = blk_king

    move_list.set(mv_list)
  end

  def en_passant_black_left
    # black, white passes on left
    mv_list = ['Pa2a3+', 'Pd7d5+', 'Pg2g4+', 'Pd5d4+', 'Pc2c4+'] # valid
    # mv_list = ['Pa2a3+', 'Pd7d5+', 'Pg2g4+', 'Pd5d4+', 'Pe3e4+'] # invalid
    board.grid[3][2] = wht_pawn
    board.grid[3][3] = blk_pawn
    move_list.set(mv_list)
  end

  def three_fold_repetition
    # input: c3d3, d3c3 // f6g6, g6f6
    board.grid[2][2] = wht_rook
    board.grid[0][4] = wht_king

    board.grid[5][5] = blk_rook
    board.grid[7][4] = blk_king
  end

  def fix_king_cannot_move?
    board.grid[2][2] = wht_pawn
    board.grid[4][1] = wht_bishop
    board.grid[0][4] = wht_king

    board.grid[5][2] = blk_pawn
    board.grid[3][1] = blk_bishop
    board.grid[7][4] = blk_king
  end

  def insuff_material_scenario1
    board.grid[0][4] = wht_king
    board.grid[7][4] = blk_king
  end

  def insuff_material_scenario2
    board.grid[0][4] = wht_king
    board.grid[0][2] = wht_bishop
    board.grid[7][4] = blk_king
  end

  def insuff_material_scenario3
    board.grid[0][4] = wht_king
    board.grid[1][1] = wht_bishop
    board.grid[0][2] = blk_knight
    board.grid[7][4] = blk_king
  end

  def fifty_move_rule
    board.grid[1][1] = wht_bishop
    board.grid[0][2] = blk_knight
    board.grid[3][2] = blk_bishop
    board.grid[0][4] = wht_king
    board.grid[7][4] = blk_king
  end

  def rework_check
    board.grid[5][3] = wht_rook
    board.grid[6][2] = wht_rook # uncomment to test checkmate
    board.grid[5][0] = wht_king
    # board.grid[0][4] = blk_rook # disable to test checkmate
    board.grid[7][5] = blk_king
    mv_list = %w[Kg8f8 Rc7c6 Kf8g8 Rd5d6 Kg8f8 Rc6c7]
    move_list.set(mv_list)
  end

  def all_pieces_stuck
    # wht_king is trapped in corner
    board.grid[1][5] = blk_rook
    board.grid[2][6] = blk_rook
    board.grid[7][4] = blk_king
    board.grid[4][2] = blk_pawn
    board.grid[2][2] = wht_pawn
    board.grid[0][7] = wht_king
  end

  def fix_pawn_double_step
    # When move d2d3, throws error
    board.grid[1][3] = wht_pawn
    board.grid[1][5] = wht_knight
    board.grid[0][6] = wht_bishop
    board.grid[0][7] = wht_king
    board.grid[5][1] = blk_pawn
    board.grid[4][5] = blk_rook
    board.grid[3][0] = blk_queen
    board.grid[7][4] = blk_king
  end

  def vs_computer
    board.grid[1][3] = wht_pawn
    board.grid[1][5] = wht_knight
    board.grid[0][6] = wht_bishop
    board.grid[0][7] = wht_king
    board.grid[5][1] = blk_pawn
    board.grid[4][5] = blk_rook
    board.grid[3][0] = blk_queen
    board.grid[7][4] = blk_king
  end

  def fix_pawn_cannot_check
    board.grid[5][3] = wht_pawn
    board.grid[4][5] = wht_bishop
    board.grid[0][7] = wht_king
    board.grid[2][3] = blk_pawn
    board.grid[7][4] = blk_king
  end

  def fix_pawn_captures_king
    board.grid[0][0] = wht_rook
    board.grid[7][7] = wht_rook
    board.grid[1][6] = wht_pawn
    board.grid[1][2] = wht_pawn
    board.grid[2][2] = wht_king
    board.grid[2][4] = blk_pawn

    board.grid[2][6] = blk_king # original spot, uncomment later
    # board.grid[3][6] = blk_king # king is 1 spot further back
    # board.grid[4][7] = blk_king # king is 2 spots further back, 1 to right

    # board.grid[2][6] = blk_rook # comment out later
    # board.grid[3][6] = blk_king # alternate location, comment out later

    # new scenario, whtpawn checks blkking
    # board.grid[3][6] = blk_king
    # board.grid[1][5] = wht_pawn


  end
end
