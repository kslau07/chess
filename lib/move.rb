# frozen_string_literal: true

require_relative 'chess_tools'

# This creates moves in chess
class Move
  include ChessTools

  attr_reader :player, :board, :move_list, :start_sq, :end_sq, :start_piece, :end_obj,
              :path, :validated, :captured_piece, :checks, :checkmates

  def self.registry
    @registry ||= []
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  Move.register(self)

  def self.handles?(args)
    true
  end

  def self.factory(args, cand_list = registry)
    cand_list.find { |candidate| candidate.handles?(args) }.new(args)
  end

  def initialize(args)
    args.each do |k, v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
    @start_piece = @board.object(start_sq)
    @end_obj = @board.object(end_sq)
    post_initialize unless args[:test] == true
  end

  def post_initialize(**args)
    @path = start_piece.make_path(board, start_sq, end_sq)
    assess_move
  end

  def assess_move
    validate_move if move_permitted?
  end

  def validate_move
    @validated = true
  end

  def move_permitted?
    return false if unreachable?
    return true unless board.path_obstructed?(path)

    false
  end

  def unreachable?
    path.include?(end_sq) ? false : true
  end

  def transfer_piece
    capture_piece
    board.update_square(end_sq, start_piece)
    board.update_square(start_sq, 'unoccupied')
    start_piece.moved
  end

  def opponent_check
    @checks = true if board.check?(opposing_color(player.color))
  end

  def test_checkmate_other_player(move_data)
    @checkmates = true if board.checkmate?(move_data)
  end

  def capture_piece
    @captured_piece = end_obj if end_obj.is_a?(Piece)
  end
end
