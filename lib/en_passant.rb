# frozen_string_literal: true

# This class is used help the factory method in Move to
# self-register and self-select when move is en passant
class EnPassant < Move
  Move.register(self)

  # What are minimum requirements for en passant?
  def self.handles?(current)
    start_sq = current[:start_sq]
    end_sq = current[:end_sq]
    board = current[:board]
    player = current[:player]
    yaxis_diff = player.color == 'white' ? 1 : -1

    cond1 = current[:board].object(start_sq).instance_of?(Pawn)
    cond2 = end_sq[0] - start_sq[0] == yaxis_diff # y-axis +1 step
    cond3 = (end_sq[1] - start_sq[1]).abs == 1 # x-axis +/- 1 step
    cond4 = board.object(end_sq) == 'unoccupied' # end_sq == 'unoccupied'
    cond1 && cond2 && cond3 && cond4
  end

  # Only thing left is to check last move
  # Then make sure black en passant works

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

