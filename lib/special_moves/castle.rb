# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when player castles
class Castle < Move
  Move.register(self)

  def self.handles?(current)
    start_sq = current[:start_sq]
    end_sq = current[:end_sq]

    cond1 = current[:board].object(start_sq).instance_of?(King)
    cond2 = (end_sq[1] - start_sq[1]).abs == 2 # base move is > 1
    cond1 && cond2
  end
  
  def post_initialize
    move_sequence
  end

  # You cannot exit check with a castle
  # Maybe add the logic here
  def move_permitted?
    puts "\n\t#{self.class}##{__method__}\n "

    case base_move
    when [0, 2]
      king_side_castle?
    when [0, -2]
      queen_side_castle?
    end
  end

  def king_side_castle?
    corner_piece = board.object([start_sq[0] + 0, start_sq[1] + 3])
    return false unless corner_piece.instance_of?(Rook)
    return false unless board.object([start_sq[0], start_sq[1] + 1]) == 'unoccupied'
    return false unless board.object([start_sq[0], start_sq[1] + 2]) == 'unoccupied'
    return true if start_piece.unmoved && corner_piece.unmoved
  end

  def queen_side_castle?
    corner_piece = board.object([start_sq[0] + 0, start_sq[1] - 4])
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
    puts "\n\t#{self.class}##{__method__}\n "

    base_move = base_move(start_sq, end_sq, board.object(start_sq).color)
    temp = start_piece.invert(base_move) if player.color == 'black'
    base_move = temp if player.color == 'black'

    board.update_square(end_sq, start_piece) # king
    board.update_square(start_sq, 'unoccupied')

    if base_move == [0, 2]
      corner = [start_sq[0] + 0, start_sq[1] + 3]
      new_sq = [start_sq[0] + 0, start_sq[1] + 1]
      rook = board.object(corner)
    elsif base_move == [0, -2]
      corner = [start_sq[0] + 0, start_sq[1] - 4]
      new_sq = [start_sq[0] + 0, start_sq[1] - 1]
      rook = board.object(corner)
    end
  
    board.update_square(new_sq, rook) # rook
    board.update_square(corner, 'unoccupied')
  end

  # override
  def revert_board
    puts "\n\t#{self.class}##{__method__}\n "
    board.update_square(new_sq, rook) # rook
    board.update_square(new_sq, rook) # rook
    board.update_square(new_sq, rook) # rook
    board.update_square(new_sq, rook) # rook
  end

  def validate_move
    raise NotImplementedError, 'Update King and Rook to moved'
    # @validated = true
    # start_piece.moved
  end
end


