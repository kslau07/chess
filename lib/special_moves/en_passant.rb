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

  def post_initialize
    # p 'are we here?'
    # p self.class, __method__
    @path = [end_sq]
    move_sequence # rename?
  end

  def move_valid?
    # Let's do last_move translated into an index
    # Then see if it is the square to the right

    # left_sq = [start_sq[0] + 0, start_sq[1] - 1]
    
    # p ['prev_sq', prev_sq]
    # p ['right_sq', right_sq]


    prev_sq = move_list.prev_sq
    right_sq = [start_sq[0], start_sq[1] + 1]
    cond1 = start_sq[0] == 4 # en passant for white happens on row 4
    cond2 = prev_sq == right_sq # previous sq to the right of own pawn
    cond3 = move_list.last_move.include?('P')

    # Check if opponent's pawn moved 1 step already
    last_move = move_list.last_move
    single_step = "#{last_move[0..1]}6"
    list = move_list.cleaned_list
    cond4 = list.include?(single_step)

    p [cond1, cond2, cond3, cond4]

    return false
  end

  def transfer_piece
    puts "\n\t#{self.class}##{__method__}\n "
    @captured_piece = board_object(move_list.prev_sq)

    p ['move_list.prev_sq', move_list.prev_sq] # -> Use translator to translate board piece
    puts @captured_piece
    return

    board.update_square(end_sq, start_piece)
    board.update_square(move_list.prev_sq, 'unoccupied')
    board.update_square(start_sq, 'unoccupied')
  end
end


# You must verify if opponent's pawn double stepped on the last move.
# You check if that same pawn made a single step earlier in the move list.
# In order to use an odd/even filter, we'd have to use && in an enumerator, that could get confusing.
# We will hard-code a check for y-axis of 5 and the 2 char match.
# If player is white, check if black pawn was on y 5.
# If player is black, check if white pawn was on y 2.

# first clean the list, remove + and x.

# Next: check that move_list still works
# Instead of changing to long-form, we have to instead look through
# list and make sure opp's same pawn did not take a single step
# earlier.
# Add conditional:
# Y-axis wht 4, blk 3

# Then: Look at last move, determine if en passant

# Use shared method. Add 1 line condition for above, then super.
# Then make sure black en passant works

# def en_passant?
#   prev_sq = move_list.prev_sq
#   relative_diff = [prev_sq[0] - start_sq[0], prev_sq[1] - start_sq[1]]
#   if start_piece.color == 'white' && move_list.last_move[0] == 'P'
#     return true if relative_diff == [0, 1] && base_move == [1, 1]
#     return true if relative_diff == [0, -1] && base_move == [1, -1]
#   elsif start_piece.color == 'black' && move_list.last_move[0] == 'P'
#     return true if relative_diff == [0, -1] && base_move == [1, 1]
#     return true if relative_diff == [0, 1] && base_move == [1, -1]
#   end
#   false
# end