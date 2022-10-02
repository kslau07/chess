# frozen_string_literal: true

# require_relative 'board'
# require_relative 'player'
require_relative 'chess_tools'

# This creates moves in chess
class Move
  include ChessTools

  attr_reader :current_player, :board, :start_sq, :end_sq, :path, :start_piece,
              :end_obj, :captured_piece, :move_list, :castle, :validated,
              :opposing_player, :check

  # rename
  # add string matching later
  def self.prefactory(current_player, opposing_player, board, move_list, game)
    @current_player = current_player
    @opposing_player = opposing_player
    @board = board
    @move_list = move_list

    Display.check if @move_list.prev_move_check?
    # loop do
    #   Display.input_start_msg
    #   first_input = gets.chomp.downcase.split('')

    #   Display.input_end_msg
    #   second_input = gets.chomp.downcase.split('')

    #   @start_sq, @end_sq = translate_input([first_input, second_input])
    #   break if check_input

    #   Display.invalid_input_message
    # end

    return

    factory
  end

  # rename later
  # def self.prefactory_test_mate(attributes)
  #   puts "\n\t#{self.class}##{__method__}\n "

  #   @current_player = attributes[:current_player]
  #   @opposing_player = attributes[:opposing_player]
  #   @board = attributes[:board]
  #   @move_list = attributes[:move_list]
  #   @start_sq = attributes[:begin_sq]
  #   @end_sq = attributes[:finish_sq]

    
  #   factory
  # end

  # def self.translate_input(input_ary)
  #   input_ary.map do |subary|
  #     [subary[1].to_i - 1, subary[0].ord - 97]
  #   end
  # end



  def self.factory
    current = { current_player: @current_player,
                opposing_player: @opposing_player,
                board: @board,
                start_sq: @start_sq,
                end_sq: @end_sq,
                move_list: @move_list }

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

    @current_player = args[:current_player] # || Player.new
    @opposing_player = args[:opposing_player] # || Player.new
    @board = args[:board] # || Board.new
    @move_list = args[:move_list] # || MoveList.new
    @start_sq = args[:start_sq]
    @end_sq = args[:end_sq]
    @start_piece = @board.object(start_sq)
    @end_obj = @board.object(end_sq)

    post_initialize
  end

  def post_initialize
    # puts "\n\t#{self.class}##{__method__}\n "

    @path = start_piece.generate_path(board, start_sq, end_sq)

    move_sequence # rename?

    # raise NotImplementedError, 'method should be implemented in subclass for Pawn'
  end

  def move_sequence
    # puts "\n\t#{self.class}##{__method__}\n "

    p ['move_permitted?', move_permitted?]

    move_permitted? ? transfer_piece : return

    p ['in_check?', in_check?(current_player)]

    if in_check?(current_player)
      revert_board
    else
      validate_move
      test_check_for_opposing_player
    end
  end

  def test_check_for_opposing_player
    # puts "\n\t#{self.class}##{__method__}\n "
    # @current_player = opposing_player

    if in_check?(opposing_player)
      @check = true
    end
  end

  def test_mate(player, other_player, move)
    puts "\n\t#{self.class}##{__method__}\n "

    king_escapes?(player, other_player, move)
  end

  def king_escapes?(player, other_player, move)

    sq_king = square_of_king(player.color)
    king = board.object(sq_king)

    king.possible_moves.each do |possible_move|
      begin_sq = sq_king
      finish_sq = [sq_king[0] + possible_move[0], sq_king[1] + possible_move[1]]
      next if out_of_bound?(board, begin_sq, finish_sq) # check if square is out of bound

      attributes = { current_player: player,
                     opposing_player: other_player,
                     board: board,
                     move_list: move_list,
                     begin_sq: sq_king,
                     finish_sq: possible_move }

      king_escape_move = move.prefactory_test_mate(attributes) # then we instantiate

      p ['finish_sq', finish_sq]
      p ['king_escape_move.validated', king_escape_move.validated]
    end
  end

  def validate_move
    @validated = true
    start_piece.moved
  end

  def in_check?(player)
    # puts "\n\t#{self.class}##{__method__}\n "
    attack_paths = paths_that_attack_king(square_of_king(player.color))
    p ['attack_paths', attack_paths]
    return false if attack_paths.empty?

    attack_paths.none? do |attack_path|
      path_obstructed?(attack_path)
    end
  end

  def paths_that_attack_king(sq_of_king)
    kings_color = board.object(sq_of_king).color
    attack_paths = []
    board.squares.each do |square|
      board_obj = board.object(square)
      next unless board_obj.is_a?(Piece) && board_obj.color == opposing_color(kings_color)

      start_sq = square
      end_sq = sq_of_king
      attack_path = board_obj.generate_attack_path(board, start_sq, end_sq)
      attack_paths << attack_path unless attack_path.empty?
    end
    attack_paths
  end

  def square_of_king(color)
    # puts "\n\t#{self.class}##{__method__}\n "

    board.squares.find do |square|
      board.object(square).instance_of?(King) && board.object(square).color == color
    end
  end

  def opposing_color(color)
    color == 'white' ? 'black' : 'white'
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

  # This method has ballooned, how do we fix it?
  def path_obstructed?(path)
    # puts "\n\t#{self.class}##{__method__}\n "
    # p ['path', path]

    begin_sq = path.first
    finish_sq = path.last

    begin_piece = board_object(begin_sq)
    finish_obj = board.object(finish_sq)
    base_move = base_move(begin_sq, finish_sq)

    first_occupied_sq = path.find.with_index do |curr_sq, idx|
      next if idx.zero? # do not check begin_sq

      board.object(curr_sq).is_a?(Piece)
    end

    piece_at_occupied_sq = board.object(first_occupied_sq)
    return false if first_occupied_sq.nil? # no piece found in path using .find
    return true if finish_sq != first_occupied_sq

    if first_occupied_sq == finish_sq
      # return false if begin_piece.instance_of?(Pawn) && (base_move == [1, 1] || base_move == [1, -1]) # other piece is diagonal to pawn
      return true if begin_piece.instance_of?(Pawn) && piece_at_occupied_sq.is_a?(Piece) && base_move[1].zero? # other piece is in front of pawn
      return true if begin_piece.color == finish_obj.color # same color obstruction
    end
    false
  end

  def transfer_piece
    @captured_piece = end_obj if end_obj.is_a?(Piece)
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
  end

  def revert_board
    puts "\n\t#{self.class}##{__method__}\n "
    board.update_square(end_sq, end_obj)
    board.update_square(start_sq, start_piece)
  end
end
