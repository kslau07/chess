# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when player castles
class Castle < Move
  attr_reader :base_move_castle
  
  Move.register(self)

  def self.handles?(args)
    start_sq = args[:start_sq]
    end_sq = args[:end_sq]

    cond1 = args[:board].object(start_sq).instance_of?(King)
    cond2 = (end_sq[1] - start_sq[1]).abs == 2 # base move is > 1
    cond1 && cond2
  end
  
  def post_initialize
    @base_move_castle = base_move(start_sq, end_sq, player.color)
    @base_move_castle = start_piece.invert(base_move_castle) if player.color == 'black'
    move_sequence
  end

  def move_permitted?
    return false if move_list.prev_move_check?

    case base_move_castle
    when [0, 2]
      king_side_castle?
    when [0, -2]
      queen_side_castle?
    end
  end

  def king_side_castle?
    corner_piece = board.object([start_sq[0], start_sq[1] + 3])
    return false unless corner_piece.instance_of?(Rook)
    return false unless board.object([start_sq[0], start_sq[1] + 1]) == 'unoccupied'
    return false unless board.object([start_sq[0], start_sq[1] + 2]) == 'unoccupied'
    return true if start_piece.unmoved && corner_piece.unmoved
  end

  def queen_side_castle?
    corner_piece = board.object([start_sq[0], start_sq[1] - 4])
    return false unless corner_piece.instance_of?(Rook)
    return false unless board.object([start_sq[0], start_sq[1] - 1]) == 'unoccupied'
    return false unless board.object([start_sq[0], start_sq[1] - 2]) == 'unoccupied'
    return false unless board.object([start_sq[0], start_sq[1] - 3]) == 'unoccupied'
    return true if start_piece.unmoved && corner_piece.unmoved
  end

  def transfer_piece

    execute_castle
  end

  def execute_castle(rook = '', corner = [])
    board.update_square(end_sq, start_piece) # king
    board.update_square(start_sq, 'unoccupied')

    if base_move_castle == [0, 2]
      corner = [start_sq[0], start_sq[1] + 3]
      rook_new_sq = [start_sq[0], start_sq[1] + 1]
      rook = board.object(corner)
    elsif base_move_castle == [0, -2]
      corner = [start_sq[0], start_sq[1] - 4]
      rook_new_sq = [start_sq[0], start_sq[1] - 1]
      rook = board.object(corner)
    end
  
    board.update_square(rook_new_sq, rook)
    board.update_square(corner, 'unoccupied')

    start_piece.moved
    rook.moved
  end
end
