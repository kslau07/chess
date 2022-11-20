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

  def make_single_step_path(start_sq, end_sq)
    [start_sq, end_sq]
  end

  def make_double_step_path(start_sq, end_sq)
    middle_sq = [(start_sq[0] + end_sq[0]) / 2, end_sq[1]]
    [start_sq, middle_sq, end_sq]
  end

  def make_attack_path(board, start_sq, end_sq)
    # attack_path = make_path(board, start_sq, end_sq, attack_move_set)
    # make_path(board, start_sq, end_sq, attack_move_set)
    []
    # returns an array of squares traveled
  end

  private

  def move_set
    [[1, 0]].freeze
  end

  def attack_move_set
    [[1, -1], [1, 1]].freeze
  end
end

  # break up in smaller methods (?)
  # def make_double_step_path(board, start_sq, end_sq)
  #   move_set = [1, 0]
  #   move_set = invert(move_set) if color == 'black'
  #   next_sq = start_sq
  #   path = [start_sq]
  #   2.times do
  #     next_sq = [next_sq[0] + move_set[0], next_sq[1] + move_set[1]]
  #     path << next_sq
  #   end
  #   path
  # end
