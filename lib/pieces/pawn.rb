# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  attr_reader :color, :unmoved, :long_reach

  def post_initialize(**args)
    @class_name = self.class
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

  def generate_double_step_path(board, start_sq, end_sq)
    # puts "\n\t#{self.class}##{__method__}\n "
    # base_move = base_move(start_sq, end_sq, board.object(start_sq).color)

    predefined_move = [1, 0]
    predefined_move = invert(predefined_move) if color == 'black'
    next_sq = start_sq
    path = [start_sq]
    2.times do
      next_sq = [next_sq[0] + predefined_move[0], next_sq[1] + predefined_move[1]]
      path << next_sq
    end
    # p ">>> path: #{path}"
    path
  end

  def generate_attack_path(board, start_sq, end_sq)
    # puts "\n\t#{self.class}##{__method__}\n "
    attack_path = generate_path(board, start_sq, end_sq, pawn_attack_moves)
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
