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
    cond4 = board.object(end_sq) == 'unoccupied'
    cond1 && cond2 && cond3 && cond4
  end

  def post_initialize
    @path = [start_sq, end_sq]
    move_sequence
  end

  def move_valid?
    puts "\n\t#{self.class}##{__method__}\n "

    pawn_on_correct_row? && opp_prev_move_allows_en_passant?
  end

  def pawn_on_correct_row?
    # puts "\n\t#{self.class}##{__method__}\n "
    case player.color
    when 'white'
      return true if start_sq[0] == 4
    when 'black'
      return true if start_sq[0] == 3
    end
  end

  # refactor this later! -> we can split conditional into separate methods
  # calculate valid previous move relative to player's start_sq
  def opp_prev_move_allows_en_passant?
    case base_move
    when [1, 1]
      valid_opp_last_move = ['P', (start_sq[1] + 96).chr, start_sq[0] - 1, (start_sq[1] + 96).chr, start_sq[0] + 1].join  if player.color == 'black'
      valid_opp_last_move = ['P', (start_sq[1] + 98).chr, start_sq[0] + 3, (start_sq[1] + 98).chr, start_sq[0] + 1].join  if player.color == 'white'
    when [1, -1]
      valid_opp_last_move = ['P', (start_sq[1] + 96).chr, start_sq[0] + 3, (start_sq[1] + 96).chr, start_sq[0] + 1].join if player.color == 'white'
      valid_opp_last_move = ['P', (start_sq[1] + 98).chr, start_sq[0] - 1, (start_sq[1] + 98).chr, start_sq[0] + 1].join if player.color == 'black'
    end
    # return true if move_list.last_move == valid_opp_last_move
    move_list.last_move == valid_opp_last_move
  end

  def transfer_piece
    # puts "\n\t#{self.class}##{__method__}\n "

    @captured_piece = board_object(move_list.prev_sq)
    board.update_square(end_sq, start_piece)
    board.update_square(move_list.prev_sq, 'unoccupied')
    board.update_square(start_sq, 'unoccupied')
  end
end




# You must verify if opponent's pawn double stepped on the last move.

# pseudo for oppo's last move
# switch x and y to [3, 4]
# convert 3 to e
# convert 4 to 5
# duplicate above 2 chars
# add 1 to e5 to make it e6
# add P to the front
