# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved, :long_reach

  def post_initialize(**args)
    @unmoved = true
    @long_reach = false
  end

  def to_s
    color == 'white' ? '♙' : '♟'
  end

  def moved
    @unmoved = false
    @long_reach = false
  end

  def generate_path(board, start_sq, end_sq)
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

  def generate_path_double_step(start_sq)
    # puts "\n\t#{self.class}##{__method__}\n "
    pdf_move = [1, 0]
    pdf_move = [-1, 0] if color == 'black'
    next_sq = start_sq
    path = [start_sq]
    2.times do
      next_sq = [next_sq[0] + pdf_move[0], next_sq[1] + pdf_move[1]]
      path << next_sq
    end
    # p ">>> path: #{path}"
    path
  end

  def generate_attack_path(board, start_sq, end_sq)
    # call generate_path with pawn_attack_moves below
    generate_path(board, start_sq, end_sq, pawn_attack_moves)
  end

  private

  def predefined_moves
    [[1, 0]]
  end

  def pawn_attack_moves
    [[1, -1], [1, 1]]
  end
end
