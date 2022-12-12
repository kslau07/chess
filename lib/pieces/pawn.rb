# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  # include Serializable
  # attr_reader :color, :unmoved, :long_reach

  def post_initialize
    @unmoved = true
    @long_reach = false
  end

  def to_s
    color == 'white' ? "\u2659" : "\u265F"
  end

  def moved
    @unmoved = false
  end

  def make_path(board, start_sq, end_sq)
    [] # single/double step move handled in separate methods
  end

  def make_single_step_path(start_sq)
    color_factor = color == 'white' ? 1 : -1
    end_sq = [start_sq[0] + color_factor, start_sq[1]]
    [start_sq, end_sq]
  end

  def make_double_step_path(start_sq)
    color_factor = color == 'white' ? 2 : -2
    end_sq = [start_sq[0] + color_factor, start_sq[1]]
    middle_sq = [(start_sq[0] + end_sq[0]) / 2, end_sq[1]]
    [start_sq, middle_sq, end_sq]
  end

  def make_capture_path(board, start_sq, end_sq)
    capturable_squares(start_sq).each do |capturable_sq|
      return [start_sq, end_sq] if end_sq == capturable_sq
    end
    []
  end

  def capturable_squares(start_sq)
    if color == 'white'
      capture_sq1 = [start_sq[0] + 1,  start_sq[1] + 1]
      capture_sq2 = [start_sq[0] + 1,  start_sq[1] - 1]
    else
      capture_sq1 = [start_sq[0] - 1,  start_sq[1] + 1]
      capture_sq2 = [start_sq[0] - 1,  start_sq[1] - 1]
    end
    [capture_sq1, capture_sq2]
  end
end
