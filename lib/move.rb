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
    @end_piece = @board.object(end_sq)

    post_initialize
  end

  def post_initialize
    @path = start_piece.generate_path(board, start_sq, end_sq)
    move_sequence # rename?

    # raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def move_sequence
    @move_legal = true if move_valid? && not_in_check?

    transfer_piece if move_legal
  end

  def not_in_check?
    puts "\n\t#{self.class}##{__method__}\n "

    p sq_of_current_player_king

    # what is our goal?
    # we want to make sure current player's king is NOT in check
    # We need current player king's square
    # Then we take each of opponent's pieces and see if it can attack current player's king.
    
    # How do we look at each of opponent's pieces?
    # We can use board.grid or board.squares
    # board.grid is the live board, we can use it to return a square using x/y
    # using board.grid, we can generate the piece, the start_sq as [x, y]
    # and we have sq_of_current_player_king.

    any_piece_that_can_check_king
    
    # After that we can look at more factors
    true
  end

  def any_piece_that_can_check_king
    # p board.grid[0][4]
    # return

    board.grid.each_with_index do |ary, y|
      ary.each_with_index do |board_obj, x|
        if board_obj.is_a?(Piece) && board_obj.color == opponent_color
          start_sq = [y, x]
          end_sq = sq_of_current_player_king
          p start_sq
          p end_sq
          p board_obj.class
          path = board_obj.generate_path(board, start_sq, end_sq)
          p path
        end
      end
    end
  end

  def sq_of_current_player_king
    puts "\n\t#{self.class}##{__method__}\n "

    board.squares.find do |square|
      board.object(square).instance_of?(King) && board.object(square).color == player.color
    end
  end
  
  def opponent_color
    player.color == 'white' ? 'black' : 'white'
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
    start_piece = board_object(start_sq) # delete redundant assignments if we do not repurpose this method
    end_piece = board.object(end_sq) # perhaps redundant
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
    @captured_piece = end_piece if end_piece.is_a?(Piece)
    start_piece.moved
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end
end


