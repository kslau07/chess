# frozen_string_literal: true

# This is the super class for all chess pieces
class Piece
  # def board_squares
  #   Board.board_squares
  # end

  def initialize(**args)
    @color = args[:color] || 'white'
    post_initialize(**args)
  end

  def post_initialize(**args)
    raise NotImplementedError, 'method should be implemented in concrete class'
  end

  def invert(move)
    # return
    return move.map { |num| num * -1 } if move.is_a?(Array)
  end

  def attack

  end

  # Unwieldy method, not sure if it can be split
  def generate_path(board, start_sq, end_sq, pdf_moves = nil)
    puts "\n\t#{self.class}##{__method__}\n "

    pdf_moves ||= predefined_moves # we may not use this

    path = [start_sq]
    pdf_moves.each do |pdf_move|
      pdf_move = invert(pdf_move) if color == 'black' && instance_of?(Pawn)
      next_sq = start_sq
      # i = 0
      loop do
        # i += 1
        # puts ">>> counter: #{i}"
        next_sq = [next_sq[0] + pdf_move[0], next_sq[1] + pdf_move[1]]
        break unless board.squares.include?(next_sq)

        path << next_sq
        return path if next_sq == end_sq
        break unless long_reach
      end
      path = [start_sq]
    end
    []
  end

  def generate_attack_path(board, start_sq, end_sq)
    generate_path(board, start_sq, end_sq)
  end
end
