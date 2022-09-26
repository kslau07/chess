# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_piece, :captured_piece, :move_list, :castle, :move_legal


  # rename
  # add string matching later
  def self.prefactory(player, board, move_list) 
    @player = player
    @board = board
    @move_list = move_list

    loop do
      Display.input_start_msg
      @start_sq = gets.chomp.split('').map(&:to_i)
      Display.input_end_msg
      @end_sq = gets.chomp.split('').map(&:to_i)
      break if check_input

      Display.invalid_input_message
    end
    factory
  end

  def self.check_input
    return false if out_of_bound?
    # return false if @board.object(@start_sq) == 'unoccupied'
    return false if @board.object(@end_sq).is_a?(Piece) && @board.object(@end_sq).color == @player.color
    return true if @board.object(@start_sq).is_a?(Piece) && @board.object(@start_sq).color == @player.color
  end

  def self.out_of_bound?
    @board.spaces.include?(@start_sq) && @board.spaces.include?(@end_sq) ? false : true
  end

  def self.factory
    current = { player: @player, board: @board, start_sq: @start_sq, end_sq: @end_sq, move_list: @move_list }
    registry.find { |candidate| candidate.handles?(current) }.new(current)
  end

  def self.registry
    @registry ||= []
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  Move.register(self)

  def self.handles?(current)
    true
  end

  def initialize(args)
    # puts "\n\t#{self.class}##{__method__}\n "

    @player = args[:player] # || Player.new
    @board = args[:board] # || Board.new
    @move_list = args[:move_list] # || MoveList.new
    @start_sq = args[:start_sq]
    @end_sq = args[:end_sq]
    @start_piece = @board.object(start_sq)
    @end_piece = @board.object(end_sq)

    post_initialize
  end

  # delete if not in use
  def post_initialize
    @path = start_piece.generate_path(start_sq, end_sq)
    move_sequence # rename?
    
    # raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def move_sequence
    @move_legal = true if move_valid? && not_in_check?

    transfer_piece if move_legal
  end

  def not_in_check?
    puts "\n\t#{self.class}##{__method__}\n "
    false if check_condition
    # What is the first step?
    # Let's create a layout for self-check'

    true
  end

  def check_condition
    # here we must loop through bishop, rook, and queen, generate path
    # loop through board
    # look for opponent's color
    # look for multi_stepper
    
    board.spaces do |space|
      p board.object(space)
      # p attacks_other_king?(board_object)
    end
    
    # board.grid.each do |row|
    #   row.each do |board_object|
    #   end
    # end
  end

  def opponent_color
    player.color == 'white' ? 'black' : 'white'
  end

  def opponent_king_square
    board.squares do |square|
      p board.object(square)
    end
  end

  def attacks_other_king?(board_object)
    other_king_sq = other_king_sq
    # work out logic first
    # then figure out if we should only include multi-steppers
    if board_object.is_a?(Piece) && board_object.color == opponent_color
      board_object.generate_path(end_sq)
    end

  end

  # delegate for now, replace soon
  def board_object(target_sq)
    board.object(target_sq)
  end

  def move_valid?
    return false unless reachable?
    return true unless path_obstructed?(path, start_sq, end_sq) # this condition returns true
  end

  def reachable?
    path.include?(end_sq) ? true : false
  end

  def base_move
    # i.e. 2 steps forward would be [2, 0] for either color
    case start_piece.color
    when 'black'
      [start_sq[0] - end_sq[0], start_sq[1] - end_sq[1]]
    when 'white'
      [end_sq[0] - start_sq[0], end_sq[1] - start_sq[1]]
    end
  end

  # rework some of this logic, seems overly complicated
  # pawn_double_step will override this
  # return false if castle
  def path_obstructed?(path, start_sq, end_sq)
    start_piece = board_object(start_sq)
    end_piece = board.object(end_sq)
    first_occupied_sq = path.find { |curr_sq| board.object(curr_sq).is_a?(Piece) }
    piece_at_occupied_sq = board.object(first_occupied_sq)
    return false if first_occupied_sq.nil? # no piece found in path using .find
    return true if end_sq != first_occupied_sq

    if first_occupied_sq == end_sq
      return true if start_piece.instance_of?(Pawn) && piece_at_occupied_sq.is_a?(Piece)
      return true if start_piece.color == end_piece.color # same color obstruction
    end
    false
  end

  def transfer_piece
    # return perform_castle if castle
    # return en_passant_capture if move_list.all_moves.size.positive? && en_passant?

    @captured_piece = end_piece if end_piece.is_a?(Piece)
    start_piece.moved
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end
end

# Can we remove Display concretion


