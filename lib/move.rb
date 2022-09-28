# frozen_string_literal: true

require_relative 'board'
require_relative 'player'

# This creates moves in chess
class Move
  attr_reader :player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_obj, :captured_piece, :move_list, :castle, :validated

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
    @board.squares.include?(@start_sq) && @board.squares.include?(@end_sq) ? false : true
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
    @end_obj = @board.object(end_sq)

    post_initialize
  end

  def post_initialize
    @path = start_piece.generate_path(board, start_sq, end_sq)

    move_sequence # rename?

    # raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def revert_board
    puts "\n\t#{self.class}##{__method__}\n "
    board.update_square(end_sq, end_obj)
    board.update_square(start_sq, start_piece)
  end

  def move_sequence

    p ['move_permitted?', move_permitted?]

    move_permitted? ? transfer_piece : return

    p ['current_player_in_check?', current_player_in_check?]

    if current_player_in_check?
      revert_board
    else
      @validated = true
      start_piece.moved
    end
  end

  def current_player_in_check?
    attack_paths = paths_that_attack_king(sq_of_current_player_king)
    p ['attack_paths', attack_paths]
    return false if attack_paths.empty?

    attack_paths.none? do |attack_path|
      path_obstructed?(attack_path)
    end
  end

  def paths_that_attack_king(sq_of_king)
    attack_paths = []
    board.squares.each do |square|
      board_obj = board.object(square)
      next unless board_obj.is_a?(Piece) && board_obj.color == opposing_color

      start_sq = square
      end_sq = sq_of_king
      attack_path = board_obj.generate_attack_path(board, start_sq, end_sq)
      attack_paths << attack_path unless attack_path.empty?
    end
    attack_paths
  end

  def sq_of_current_player_king
    # puts "\n\t#{self.class}##{__method__}\n "

    board.squares.find do |square|
      board.object(square).instance_of?(King) && board.object(square).color == player.color
    end
  end

  def opposing_color
    player.color == 'white' ? 'black' : 'white'
  end

  # delegate for now, replace soon
  def board_object(target_sq)
    board.object(target_sq)
  end

  def move_permitted?
    # puts "\n\t#{self.class}##{__method__}\n "
    return false unless reachable?
    return true unless path_obstructed?(path) # this condition returns true
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
  def path_obstructed?(path)
    puts "\n\t#{self.class}##{__method__}\n "
    
    begin_sq = path.shift
    finish_sq = path[-1]

    begin_piece = board_object(begin_sq)
    finish_obj = board.object(finish_sq)
    first_occupied_sq = path.find { |curr_sq| board.object(curr_sq).is_a?(Piece) }
    piece_at_occupied_sq = board.object(first_occupied_sq)
    return false if first_occupied_sq.nil? # no piece found in path using .find
    return true if finish_sq != first_occupied_sq

    if first_occupied_sq == finish_sq
      return false if begin_piece.instance_of?(Pawn) && (base_move == [1, 1] || base_move == [1, -1]) # other piece is diagonal to pawn
      return true if begin_piece.instance_of?(Pawn) && piece_at_occupied_sq.is_a?(Piece) # other piece is in front of pawn
      return true if begin_piece.color == finish_obj.color # same color obstruction
    end
    false
  end

  def transfer_piece
    @captured_piece = end_obj if end_obj.is_a?(Piece)
    # start_piece.moved
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end
end
