# frozen_string_literal: true

# This is the super class for all chess pieces
class Piece
  # first we use initialize with super
  # later we will switch to post_initialization

  def board_squares
    Board.board_squares
  end

  def initialize(**args)
    @color = args[:color] || 'white'
    post_initialization(**args)
  end

  def post_initialization(**args)
    raise NotImplementedError, 'method should be implemented in concrete class'
  end

  # def find_route(start_sq, end_sq)
  #   case self.class.name
  #   when 'Pawn' # this could be its own class

  #     # move = [(start_sq[0] - end_sq[0]), (start_sq[1] - end_sq[1])]
  #     # *call_capture_method if pawn_capture_moves.include?(move)
  #     generate_path(start_sq, end_sq)

  #     # stage_piece(start_sq, end_sq)
  #   when 'Bishop'
  #     stage_piece(start_sq, end_sq)
  #   end
  # end

  # def stage_piece(start_sq, end_sq)
  #   # return generate_pawn_path(start_sq, end_sq) if instance_of?(Pawn)

  #   generate_path(start_sq, end_sq)
  # end

  def invert(move)
    move.map { |num| num * -1 }
  end

  # This method is unwieldy wholely because of Pawn's unusual movement including
  # capture move. I decided not to extract it into its own method to keep
  # code DRYer.
  def generate_path(start_sq, end_sq)
    path = []
    predefined_moves.each do |predefined_move|
      predefined_move = invert(predefined_move) if color == 'black' && instance_of?(Pawn)
      next_sq = start_sq
      i = 0
      loop do
        i += 1
        next_sq = [next_sq[0] + predefined_move[0], next_sq[1] + predefined_move[1]]
        break unless board_squares.include?(next_sq)

        path << next_sq
        return path if next_sq == end_sq
        break if i == 2 && instance_of?(Pawn) && unmoved == true # pawn 2 square first move
        break if i == 1 && instance_of?(Pawn) && unmoved == false # pawn single square move
        break if i == 1 && instance_of?(Pawn) && [[1, -1], [1, 1]].include?(predefined_move) # pawn capture moves
        break if i == 1 && (instance_of?(Knight) || instance_of?(King))
      end
    end
    path = []
  end
end



"
Fixed-movers
pawns, knights, and the king

Long-distance travelers
bishops, rooks, and the queen

Pawns are especially tricky. They're the only piece whose capture
direction is different from its move direction.

We can use predefined_moves for pawns, knights, and the king. That method
name is perfect. But it doesn't fit bishops, rooks, and the queen.

The king and knight are not exactly like the pawn. They can move in any
direction, but only ONE unit.

The pawn can move forward only, and its first move can be 1 or 2 squares.

The reason I am conflating the pawn, the knight, and the king, I believe is
because the size of their move array is small.
"

  # def predefined_moves
  #   move_directions = [[1, -1], [1, 1], [-1, -1], [-1, 1]]
  #   generate_path(move_directions)
  # end


  # def capturable_squares(start_sq, color, board_squares)
  #   predefined_capture_moves.map do |predefined_capture_move|
  #     predefined_capture_move = invert(predefined_capture_move) if color == 'black'
  #     move = [predefined_capture_move[0] + start_sq[0], predefined_capture_move[1] + start_sq[1]]
  #     board_squares.include?(move) ? move : nil
  #   end
  # end

    # path_one: pawns, knights, the king
  # What do we want from this method?
  # We already check if start/end are in bounds earlier. No need to do that.
  # With pawn: take its path, which could be one or two moves,
  # match it with end_sq, then return that path. The path could contain
  # one or two arrays, depending on if pawn moves 1 or 2 spaces.
  # def path_one(start_sq, end_sq, board_squares)
  #   path = []
  #   predefined_moves.each do |predefined_step|
  #     next_move = [predefined_step[0] + start_sq[0], predefined_step[1] + start_sq[1]]
  #     path << next_move
  #     break if next_move == end_sq

  #     path = [] # clear path if it's not one that includes end_sq
  #   end
  #   path
  # end
