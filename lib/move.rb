# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  # attr_reader 
  attr_reader :player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_piece, :captured_piece, :move_list, :castle

  # Array of all 64 squares in index notation
  # def board_squares
  #   Board.board_squares
  # end

  # DataClump = Struct.new(:player, :board, :start_sq, :end_sq)

  def self.test_number
    puts '42'
  end

  def self.prefactory(player, board, move_list) # rename
    @player = player
    @board = board
    @move_list = move_list
    # data = DataClump.new(player, [0,0], [1,0])
    # p data.start_sq

    loop do
      Display.input_start_msg
      @start_sq = gets.chomp.split('').map(&:to_i)
      Display.input_end_msg
      @end_sq = gets.chomp.split('').map(&:to_i)
      # current = DataClump.new(player, board, start_sq, end_sq)
      break if check_input

      Display.invalid_input_message
    end
    mid_factory
  end

  def self.check_input
    return false if out_of_bound?
    return false if @board.object(@start_sq) == 'unoccupied'
    return true if @board.object(@start_sq).color == @player.color
  end

  def self.out_of_bound?
    @board.spaces.include?(@start_sq) && @board.spaces.include?(@end_sq) ? false : true
  end

  def self.mid_factory
    factory
  end

  def self.factory
    current = { player: @player, board: @board, start_sq: @start_sq, end_sq: @end_sq }

    found_obj = registry.find { |candidate| candidate.handles?(current) }#.new(current)
    pp found_obj


    # found_obj = registry.find(&:handles?(@start_sq, @end_sq)) # cannot send arguments with symbol

    # found_obj =registry.find { |candidate| candidate.handles?(number) }.new(number)
  end

  def self.registry
    @registry ||= []
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  Move.register(self)

  def self.handles?(current)
    # pp 'Move#handles?'
    true
  end

  def initialize(**args)
    @player = args[:player] || Player.new
    @board = args[:board] || Board.new
    @move_list = args[:move_list] || MoveList.new
    move_sequence # rename?
  end

  def move_sequence # rename?
    input_move
    transfer_piece
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

    @path = start_piece.generate_path(start_sq, end_sq)
    # p ">>> path inside #move_valid? : #{path}"
    return false unless reachable?
    return false if path_obstructed?(path, start_sq, end_sq)
    true
  end



  def reachable?

    return castle? if start_piece.instance_of?(King) && (base_move == [0, 2] || base_move == [0, -2])
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
    return true if move_list.all_moves.size.positive? && en_passant?
    return false if end_piece == 'unoccupied' && (base_move == [1, -1] || base_move == [1, 1])

    path.include?(end_sq) ? (return true) : (return false)
  end



  # rework some of this logic, seems overly complicated
  def path_obstructed?(path, start_sq, end_sq)
    return false if castle

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
    return perform_castle if castle
    return en_passant_capture if move_list.all_moves.size.positive? && en_passant?

    @captured_piece = end_piece if end_piece.is_a?(Piece)
    start_piece.moved
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end

  # refactor properly
  # delegate messages to the new classes, then comment out old code
  def castle?

    # forward message to Castle#castle?
    # how?

    # Look into how Metz performed a class extraction, how she refactored
    # step by step in a painless and easy way.
  end

  def perform_castle
  
  end


  def en_passant?

  end

  def en_passant_capture

  end
end

  # Figure out how @ works when used by classes

  # Can we remove Display concretion
  # add string matching later
  # def input_move
  #   loop do
  #     Display.input_start_msg
  #     @start_sq = gets.chomp.split('').map(&:to_i)
  #     Display.input_end_msg
  #     @end_sq = gets.chomp.split('').map(&:to_i)
  #     return if move_valid?

  #     # return [start_sq, end_sq] if move_valid?(start_sq, end_sq)

  #     Display.invalid_input_message
  #   end
  # end