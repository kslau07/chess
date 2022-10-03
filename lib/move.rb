# frozen_string_literal: true

# require_relative 'board'
# require_relative 'player'
require_relative 'chess_tools'

# This creates moves in chess
class Move
  include ChessTools

  attr_reader :player, :board, :move_list, :start_sq, :end_sq, :start_piece, :end_obj,
              :path, :validated

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

  def move_permitted?
    # puts "\n\t#{self.class}##{__method__}\n "
    return false unless reachable?
    return true unless board.path_obstructed?(path)
  end

  def reachable?
    path.include?(end_sq) ? true : false
  end

  # delegate, then delete
  def path_obstructed?(path)
    board.path_obstructed?(path)
  end

  def capture_piece
    @captured_piece = end_obj if end_obj.is_a?(Piece)
  end
end
