# frozen_string_literal: true

# This is the super class for all chess pieces
class Piece

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

  def invert(move)
    move.map { |num| num * -1 }
  end

  # Unwieldy method, not sure if it can be split
  def generate_path(start_sq, end_sq)
    path = []
    predefined_moves.each do |pdf_move|
      pdf_move = invert(pdf_move) if color == 'black' && instance_of?(Pawn)
      next_sq = start_sq
      i = 0
      loop do
        i += 1
        next_sq = [next_sq[0] + pdf_move[0], next_sq[1] + pdf_move[1]]
        break unless board_squares.include?(next_sq)

        path << next_sq
        return path if next_sq == end_sq
        break if i == 2 && instance_of?(Pawn) && unmoved == true # pawn 2 steps forward
        break if i == 1 && instance_of?(Pawn) && unmoved == false # pawn single step forward
        break if i == 1 && instance_of?(Pawn) && [[1, -1], [1, 1]].include?(pdf_move) # pawn capture moves
        break if i == 1 && (instance_of?(Knight) || instance_of?(King))
      end
      # puts ">>> counter: #{i}"
      path = []
    end
    []
  end
end
