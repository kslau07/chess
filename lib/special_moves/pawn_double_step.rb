# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when pawn moves 2 steps forward
class PawnDoubleStep < Move
  Move.register(self)

  def self.handles?(current)
    start_sq = current[:start_sq]
    end_sq = current[:end_sq]

    cond1 = current[:board].object(start_sq).instance_of?(Pawn)
    cond2 = (end_sq[0] - start_sq[0]).abs == 2 # y-axis +1 step
    cond3 = current[:board].object(start_sq).unmoved

    cond1 && cond2 && cond3
  end

  def post_initialize
    @path = start_piece.generate_double_step_path(board, start_sq, end_sq)
    move_sequence
  end
end
