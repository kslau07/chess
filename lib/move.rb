# frozen_string_literal: true

# require_relative 'board'
# require_relative 'player'
require_relative 'chess_tools'

# This creates moves in chess
class Move
  include ChessTools

  attr_reader :player, :board, :move_list, :start_sq, :end_sq, :start_piece, :end_obj,
              :path

  # attr_reader :player, :board, :start_sq, :end_sq, :path, :start_piece,
  #             :end_obj, :captured_piece, :move_list, :castle, :validated,
  #             :opposing_player, :check

  def self.factory(**args)
    registry.find { |candidate| candidate.handles?(**args) }.new(**args)
  end

  def self.registry
    @registry ||= []
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  Move.register(self)

  def self.handles?(**args)
    true
  end

  def initialize(**args)
    # puts "\n\t#{self.class}##{__method__}\n "

    @player = args[:player] # || Player.new
    # @opposing_player = args[:opposing_player] # || Player.new
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
    move_sequence
  end

  def move_sequence
    validate_move if move_permitted?
  end

  def validate_move
    @validated = true
    start_piece.moved
  end

  def opposing_color(color)
    color == 'white' ? 'black' : 'white'
  end

  # # delegate for now, replace soon
  # def board_object(target_sq)
  #   board.object(target_sq)
  # end

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

    begin_piece = board.object(begin_sq)
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

  def capture_piece
    @captured_piece = end_obj if end_obj.is_a?(Piece)
  end
end
