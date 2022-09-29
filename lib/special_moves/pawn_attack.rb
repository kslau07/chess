# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when Pawn captures another piece

class PawnAttack < Move
  Move.register(self)

  def self.handles?(current)
    start_sq = current[:start_sq]
    end_sq = current[:end_sq]
    board = current[:board]
    player = current[:player]
    yaxis_diff = player.color == 'white' ? 1 : -1

    cond1 = current[:board].object(start_sq).instance_of?(Pawn)
    cond2 = end_sq[0] - start_sq[0] == yaxis_diff # y-axis +1 step
    cond3 = (end_sq[1] - start_sq[1]).abs == 1 # x-axis +/- 1 step
    cond4 = board.object(end_sq).is_a?(Piece) && board.object(end_sq).color != player.color
    cond1 && cond2 && cond3 && cond4
  end

  def post_initialize(**args)
    # puts "\n\t#{self.class}##{__method__}\n "
    @path = start_piece.generate_attack_path(board, start_sq, end_sq)
    # p ['@path', @path]
    move_sequence
  end

  def move_permitted?
    board.object(end_sq).is_a?(Piece) && board.object(end_sq).color != player.color
  end
end
