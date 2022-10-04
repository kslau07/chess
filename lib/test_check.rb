# frozen_string_literal: true

# This module tests for check in Board objects
module TestCheck
  def check?(player)
    p __method__
    p player

    attack_paths = paths_that_attack_king(square_of_king(player.color))

    p ['attack_paths', attack_paths]
    
    # gets
    
    return false if attack_paths.empty?

    attack_paths.none? do |attack_path|
      path_obstructed?(attack_path)
    end
  end

  def paths_that_attack_king(sq_of_king)
    player_color = object(sq_of_king).color
    attack_paths = []
    squares.each do |square|
      board_obj = object(square)
      next unless board_obj.is_a?(Piece) && board_obj.color == opposing_color(player_color)

      start_sq = square
      end_sq = sq_of_king
      attack_path = board_obj.generate_attack_path(self, start_sq, end_sq)
      attack_paths << attack_path unless attack_path.empty?
    end
    attack_paths
  end

  def square_of_king(color)
    squares.find do |square|
      object(square).instance_of?(King) && object(square).color == color
    end
  end
end