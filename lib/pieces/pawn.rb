# frozen_string_literal: true

# This class represents pawns in chess
class Pawn < Piece
  # include Serializable
  # attr_reader :color, :unmoved, :long_reach

  def post_initialize
    # @class_name = self.class
    # @unmoved = true
    @long_reach = false
  end

  def to_s
    color == 'white' ? "\u2659" : "\u265F"
  end

  def moved
    @unmoved = false
    @long_reach = false
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

  def make_path

  end

  def make_attack_path(board, start_sq, end_sq)
    # attack_path = make_path(board, start_sq, end_sq, attack_move_set)
    make_path(board, start_sq, end_sq, attack_move_set)
  end

  private

  def move_set
    [[1, 0]].freeze
  end

  def attack_move_set
    [[1, -1], [1, 1]].freeze
  end
end
