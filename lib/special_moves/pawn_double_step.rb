# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when pawn moves 2 steps forward
class PawnDoubleStep < Move
  Move.register(self)

  def self.handles?(args)
    start_sq = args[:start_sq]
    end_sq = args[:end_sq]
    cond1 = args[:board].object(start_sq).instance_of?(Pawn)
    cond2 = (end_sq[0] - start_sq[0]).abs == 2 # y change of 2
    cond3 = args[:board].object(start_sq).unmoved # uncomment

    cond1 && cond2 && cond3
  end

  def post_initialize
    @path = start_piece.make_double_step_path(start_sq)
    assess_move
  end
end
