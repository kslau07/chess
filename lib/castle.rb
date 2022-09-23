# frozen_string_literal: true

# This class is used to create castling moves
class Castle
  def castle?

    corner_piece = ''
    # You cannot exit check with a castle
    # Both King and Rook must be unmoved
    # All spaces between must be empty
  
    if base_move == [0, 2]
      corner_piece = board_object([start_sq[0] + 0, start_sq[1] + 3])
      return false unless board_object([start_sq[0] + 0, start_sq[1] + 1]) == 'unoccupied'
      return false unless board_object([start_sq[0] + 0, start_sq[1] + 2]) == 'unoccupied'
    elsif base_move == [0, -2]
      corner_piece = board_object([start_sq[0] + 0, start_sq[1] - 4])
      return false unless board_object([start_sq[0] + 0, start_sq[1] - 1]) == 'unoccupied'
      return false unless board_object([start_sq[0] + 0, start_sq[1] - 2]) == 'unoccupied'
      return false unless board_object([start_sq[0] + 0, start_sq[1] - 3]) == 'unoccupied'
    end
    return false unless corner_piece.instance_of?(Rook)
    return false unless start_piece.unmoved && corner_piece.unmoved
    # return false unless
  
    # Should we transfer pieces here, or 
    # add a variable @castle = true
    # then allow transfer piece to operate
    @castle = true
    true
  end
  
  def perform_castle(rook = '', corner = [])
    board.update_square(end_sq, start_piece) # king
    board.update_square(start_sq, 'unoccupied')
  
    if base_move == [0, 2]
      corner = [start_sq[0] + 0, start_sq[1] + 3]
      new_sq = [start_sq[0] + 0, start_sq[1] + 1]
      rook = board_object(corner)
    elsif base_move == [0, -2]
      corner = [start_sq[0] + 0, start_sq[1] - 4]
      new_sq = [start_sq[0] + 0, start_sq[1] - 1]
      rook = board_object(corner)
    end
  
    board.update_square(new_sq, rook) # rook
    board.update_square(corner, 'unoccupied')
  end
end


