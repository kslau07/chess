# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when Pawn captures another piece

class PawnAttack < Move
  Move.register(self)

  def self.handles?(args)
    start_sq = args[:start_sq]
    end_sq = args[:end_sq]
    board = args[:board]
    player = args[:player]
    yaxis_diff = player.color == 'white' ? 1 : -1

    cond1 = args[:board].object(start_sq).instance_of?(Pawn)
    cond2 = end_sq[0] - start_sq[0] == yaxis_diff # y-axis +1 step
    cond3 = (end_sq[1] - start_sq[1]).abs == 1 # x-axis +/- 1 step
    cond4 = board.object(end_sq).is_a?(Piece) && board.object(end_sq).color != player.color
    cond1 && cond2 && cond3 && cond4
  end

  def post_initialize(args)
    @path = start_piece.generate_attack_path(board, start_sq, end_sq)
    move_sequence
  end

  def move_permitted?
    board.object(end_sq).is_a?(Piece) && board.object(end_sq).color != player.color
  end
end
