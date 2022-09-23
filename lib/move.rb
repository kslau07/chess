# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_piece, :captured_piece, :move_list, :castle, :validated

  # DataClump = Struct.new(:player, :board, :start_sq, :end_sq)

  def self.test_number
    puts '42'
  end

  # rename
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
    return false if @board.object(@start_sq) == 'unoccupied'
    return true if @player.color == @board.object(@start_sq).color
  end

  def self.out_of_bound?
    @board.spaces.include?(@start_sq) && @board.spaces.include?(@end_sq) ? false : true
  end

  def self.factory
    current = { player: @player, board: @board, start_sq: @start_sq, end_sq: @end_sq }
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
    p self.class.to_s
    p __method__

    @player = args[:player] # || Player.new
    @board = args[:board] # || Board.new
    @move_list = args[:move_list] # || MoveList.new

    @start_sq = args[:start_sq]
    @end_sq = args[:end_sq]
    @start_piece = @board.object(start_sq)
    @end_piece = @board.object(end_sq)
    
    move_sequence # rename?
    
    return
    post_initialize(**args)
  end

  # delete if not in use
  def post_initialize(**args)
    raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def move_sequence
    @validated = true if move_valid?

    p 'validated', validated
    # transfer_piece if validated
  end

  # delegate for now, replace soon
  def board_object(target_sq)
    # return nil if sq_coord.nil? # checks for nil input, maybe delete later

    # board.grid.dig(sq_coord[0], sq_coord[1])

    board.object(target_sq)
  end

  # when EnPassant, we do not want to send :generate_path,
  # Should we override move_valid?
  

  def move_valid?
    @path = start_piece.generate_path(start_sq, end_sq)
    # p ">>> path inside #move_valid? : #{path}"

    return false unless reachable?
    return true unless path_obstructed?(path, start_sq, end_sq) # this condition returns true
  end

  def reachable?
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

  # NOTE: We may not have to delegate if subclasses respond now
  # refactor properly
  # delegate messages to the new classes, then comment out old code
  
  # possibly unused
  # def reachable_by_pawn?
  #   return true if move_list.all_moves.size.positive? && en_passant?
  #   return false if end_piece == 'unoccupied' && (base_move == [1, -1] || base_move == [1, 1])

  #   path.include?(end_sq) ? (return true) : (return false)
  # end

  # def castle?
  # end

  # def reachable_by_pawn?
  # end

  # def perform_castle
  # end

  # def en_passant?
  # end

  # def en_passant_capture
  # end
end


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