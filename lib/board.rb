# frozen_string_literal: true

require 'pry-byebug' # debug, delete me
require 'json'
require_relative './library' # delete me?

# This is the chess board
class Board
  include Serializable
  include ChessTools
  include Check

  attr_reader :grid, :pc_factory, :wht_pawn, :wht_bishop, :wht_rook, :wht_knight,
              :wht_queen, :wht_king, :blk_pawn, :blk_bishop, :blk_rook, :blk_knight,
              :blk_queen, :blk_king

  # When we initialize Board, we will start with a standard layout
  # If a new layout is required, the new layout method will
  # 1) clear the board, 2) set up the board, 3) apply a new move_list
  def initialize(pc_factory = PieceFactory)
    @pc_factory = pc_factory
    create_new_grid
    create_pieces(pc_factory)
    setup_normal_layout
  end

  # delete me? we may move this to spec file for testing special moves
  # Game pieces used in tests
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

  def setup_normal_layout
    white_set = pc_factory.create_set('white')
    black_set = pc_factory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }

    (0..7).each do |sq|
      grid[1][sq] = pieces[:white_pcs][sq]
      grid[6][sq] = pieces[:black_pcs][sq]
      grid[0][sq] = pieces[:white_pcs][sq + 8]
      grid[7][sq] = pieces[:black_pcs][sq + 8]
    end
  end

  def object(coord)
    grid[coord[0]][coord[1]] unless coord.nil?
  end

  def squares
    arr_of_squares = []
    8.times do |x|
      8.times do |y|
        arr_of_squares << [x, y]
      end
    end
    arr_of_squares
  end

  def create_new_grid
    @grid = []

    8.times do
      @grid.push Array.new(8, 'unoccupied')
    end
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
  end

  def path_obstructed?(path)
    return pawn_path_obstructed?(path) if object(path.first).is_a?(Pawn)
    return true if friendly?(object(path.first).color, path.last)

    search_path = path[1..-2] # squares inbetween start/end
    search_path.any? do |sq|
      object(sq).is_a?(Piece)
    end
  end

  def friendly?(player_color, end_sq)
    return true if object(end_sq).is_a?(Piece) && object(end_sq).color == player_color

    false
  end

  def pawn_path_obstructed?(path)
    cond1 = object(path[1]) == 'unoccupied'
    cond2 = path[2].nil? || object(path[2]) == 'unoccupied'
    # cond2 = object(path[2]) == 'unoccupied' || nil # delete me if code works
    return false if cond1 && cond2

    true
  end

  def load_grid(grid_obj)
    @grid = grid_obj
  end

  def promotion?(new_move)
    cond1 = new_move.end_sq[0] == 7 && new_move.start_piece.instance_of?(Pawn) # wht pawn
    cond2 = new_move.end_sq[0] == 0 && new_move.start_piece.instance_of?(Pawn) # blk pawn
    cond1 || cond2
  end

  def promote_pawn(new_move)
    puts Display.pawn_promotion(new_move.player)
    loop do
      input = gets.chomp
      return change_pawn(new_move, input) if input.match(/^[1-4]{1}$/)

      puts 'Not valid input!'
    end
  end

  def change_pawn(new_move, input, pc_fact = PieceFactory)
    promotion = { 'Queen': '1', 'Rook': '2', 'Bishop': '3', 'Knight': '4' }.key(input)
    new_piece = pc_fact.create(promotion, new_move.player.color)
    update_square(new_move.end_sq, new_piece)
  end

  def enemy_piece?(player_color, board_obj)
    return false if board_obj.is_a?(String)

    player_color != board_obj.color
  end

  def names_of_pcs_remaining
    all_pcs = all_pc_objects_remaining
    all_pcs.flatten.map(&:class)
  end

  def all_pc_objects_remaining
    grid.map do |row|
      row.filter do |square|
        square.is_a?(Piece)
      end
    end
  end

  def squares_of_player(target_color)
    squares.filter do |square|
      object(square).is_a?(Piece) && object(square).color == target_color
    end
  end
end


    # pcs_objects_remaining.flatten.map do |piece_obj|
    #   piece_obj.class
    # end
