# frozen_string_literal: true

require_relative 'save_load'

# This module tests for check in Board objects
module Check
  include SaveLoad

  def check?(color)
    kings_sq = square_of_king(color)
    check_paths = find_check_paths(color, kings_sq)
    check_paths.any? { |capture_path| !path_obstructed?(capture_path) }
  end

  # Finds any paths that currently attack king
  def find_check_paths(player_color, kings_sq, check_paths = [])
    squares.each do |square|
      next unless enemy_piece?(player_color, object(square))

      enemy_piece = object(square)
      path_to_king = enemy_piece.make_capture_path(self, square, kings_sq)
      check_paths << path_to_king unless path_to_king.empty?
    end
    check_paths
  end

  def square_of_king(color)
    squares.find do |square|
      object(square).instance_of?(King) && object(square).color == color
    end
  end

  def checkmate?(move_data)
    # target_color = move_data[:player].color
    no_pieces_can_move?(move_data)
  end

  def no_pieces_can_move?(move_data)
    target_color = move_data[:player].color
    plyers_sqs = squares_of_player(target_color)

    plyers_sqs.none? do |square|
      piece_can_move?(square, move_data)
    end
  end

  def piece_can_move?(begin_square, move_data)
    squares.any? do |board_square|
      move_data[:start_sq] = begin_square
      move_data[:end_sq] = board_square

      legal_move?(move_data)
    end
  end

  def legal_move?(move_data)
    move = move_data[:move]
    color = move_data[:player].color
    grid_json = serialize
    possible_move = move.factory(move_data)
    possible_move.transfer_piece if possible_move.validated
    result = !check?(color) && possible_move.validated
    revert_board(grid_json, self)
    result
  end
end

class Array
  def format_cn
    translate_index_to_notation(self)
  end

  def translate_index_to_notation(sq_array)
    [(sq_array[-1] + 97).chr, sq_array[-2] + 1].join # index to c.n.
  end
end
