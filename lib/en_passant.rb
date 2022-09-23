# frozen_string_literal: true

# This class is used to create en passant moves
class EnPassant
  def en_passant?
    prev_sq = move_list.prev_sq
    relative_diff = [prev_sq[0] - start_sq[0], prev_sq[1] - start_sq[1]]
    if start_piece.color == 'white' && move_list.last_move[0] == 'P'
      return true if relative_diff == [0, 1] && base_move == [1, 1]
      return true if relative_diff == [0, -1] && base_move == [1, -1]
    elsif start_piece.color == 'black' && move_list.last_move[0] == 'P'
      return true if relative_diff == [0, -1] && base_move == [1, 1]
      return true if relative_diff == [0, 1] && base_move == [1, -1]
    end
    false
  end

  def en_passant_capture
    @captured_piece = board_object(move_list.prev_sq)
    board.update_square(end_sq, start_piece)
    board.update_square(move_list.prev_sq, 'unoccupied')
    board.update_square(start_sq, 'unoccupied')
  end
end

