# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when pawn moves 2 steps forward
class PawnDoubleStep < Move
  Move.register(self)

  def self.handles?(current)
    # p name

    # What logic do we need here?
    # Pawn moves 2 steps forward
    # Only y-axis is affected
    # X-axis is unchanged
    # Y-axis difference is 2 or -2
    # Must be instance of Pawn
    # Pawn is unmoved

    start_sq = current[:start_sq]
    end_sq = current[:end_sq]
    # board = current[:board]
    # player = current[:player]
    # yaxis_diff = player.color == 'white' ? 1 : -1

    cond1 = current[:board].object(start_sq).instance_of?(Pawn)
    cond2 = (end_sq[0] - start_sq[0]).abs == 2 # y-axis +1 step
    cond3 = current[:board].object(start_sq).unmoved
    # cond3 = (end_sq[1] - start_sq[1]).abs == 1 # x-axis +/- 1 step
    # cond4 = board.object(end_sq) == 'unoccupied' # end_sq == 'unoccupied'\

    p 'bottom of' + name.to_s
    p cond1 && cond2 && cond3
    
    cond1 && cond2 && cond3
  end

  def post_initialize(**args)
    p self.name, __method__.to_s
  end

  # How do we get the pawn to move forward 2 steps?
  # We must override generate path

  def generate_path
    path = []
    path << [start_sq[0], start_sq[1] + 1]
    path << [start_sq[0], start_sq[1] + 2]
  end

  # We may or may not override path_blocked
  # path_blocked can use this path, which is better?
end

