# frozen_string_literal: true

# This module tests for check in Board objects
module TestCheck
  def check?(color)
    attack_paths = paths_that_attack_king(square_of_king(color))
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

  # checkmate methods

  def checkmate?(color)
    p __method__
    king_escapes?(player, other_player, move)
  end

  # How do we start this?
  # Check the king with a rook
  # Find one single square it can legally move to
  # checkmate is false at that point

  def king_escapes?(player, other_player, move)

    gets

    sq_king = square_of_king(player.color)
    king = board.object(sq_king)

    king.possible_moves.each do |possible_move|
      begin_sq = sq_king
      finish_sq = [sq_king[0] + possible_move[0], sq_king[1] + possible_move[1]]
      next if out_of_bound?(board, begin_sq, finish_sq) # check if square is out of bound

      attributes = { player: player,
                     opposing_player: other_player,
                     board: board,
                     move_list: move_list,
                     begin_sq: sq_king,
                     finish_sq: possible_move }

      king_escape_move = move.prefactory_test_mate(attributes) # then we instantiate

      p ['finish_sq', finish_sq]
      p ['king_escape_move.validated', king_escape_move.validated]
    end
  end
end
