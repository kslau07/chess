# frozen_string_literal: true

require_relative 'chess_tools'

# This creates moves in chess
class Move
  include ChessTools

  attr_reader :player, :board, :move_list, :start_sq, :end_sq, :start_piece, :end_obj,
              :path, :validated, :captured_piece, :checks, :checkmates

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
    @player = args[:player]
    @board = args[:board]
    @move_list = args[:move_list]
    @start_sq = args[:start_sq]
    @end_sq = args[:end_sq]
    @start_piece = @board.object(start_sq)
    @end_obj = @board.object(end_sq)

    post_initialize
  end

  def transfer_piece
    capture_piece
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
    start_piece.moved
  end

  def test_check_other_player
    @checks = true if board.check?(opposing_color(player.color))
  end

  def test_checkmate_other_player
    @checkmates = true if board.checkmate?(opposing_color(player.color))
  end

  private

  def capture_piece
    @captured_piece = end_obj if end_obj.is_a?(Piece)
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
  end

  def move_permitted?
    return false unless reachable?
    return true unless board.path_obstructed?(path)
  end

  def reachable?
    path.include?(end_sq) ? true : false
  end

  private
end
