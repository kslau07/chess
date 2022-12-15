# frozen_string_literal: true

require_relative 'save_load'
require 'pry-byebug' # delete me

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


  # Returns false if king has at least 1 legal move
  # We need to make this work for any piece, not just King
  # The easiest way would be to use all the squares in board. start_sq
  # would be home sq and end sq would be each of the squares on the board.
  # We run #legal_move? 64 times per piece on the board. If even 1 piece can
  # move, the function must stop. It would be expensive to go through every
  # single piece every single time.

  # refactored, delete me
  # def king_cannot_move?(king, kings_sq, move_data)
    # king.possible_moves.none? do |possible_move|
      # begin_sq = kings_sq
      # finish_sq = [kings_sq[0] + possible_move[0], kings_sq[1] + possible_move[1]]
      # next if out_of_bound?(self, begin_sq, finish_sq)

      # move_data[:start_sq] = begin_sq
      # move_data[:end_sq] = finish_sq
      # legal_move?(move_data)
    # end
  # end

  # Returns false if another piece can remove check
  # def king_not_defendable?(color, kings_sq, move_data)
  #   # Although this method is long, it feels like all parts are necessary
  #   attackers_paths = find_check_paths(color, kings_sq)
  #   attackers_paths.each do |attackers_path|
  #     attackers_path.each do |path_square|
  #       grid.each_with_index do |col, y|
  #         col.each_with_index do |sq, x|
  #           next unless sq.is_a?(Piece) && sq.color == color

  #           move_data[:start_sq] = [y, x]
  #           move_data[:end_sq] = path_square
  #           return false if legal_move?(move_data)
  #         end
  #       end
  #     end
  #   end
  #   true
  # end


  # def king_cannot_move?(king, kings_sq, move_data)
  #   king.possible_moves.none? do |possible_move|
  #     begin_sq = kings_sq
  #     finish_sq = [kings_sq[0] + possible_move[0], kings_sq[1] + possible_move[1]]
  #     next if out_of_bound?(self, begin_sq, finish_sq)

  #     move_data[:start_sq] = begin_sq
  #     move_data[:end_sq] = finish_sq
  #     legal_move?(move_data)
  #   end
  # end

  # # Returns false if another piece can remove check
  # def king_not_defendable?(color, kings_sq, move_data)
  #   # Although this method is long, it feels like all parts are necessary
  #   attackers_paths = find_check_paths(color, kings_sq)
  #   attackers_paths.each do |attackers_path|
  #     attackers_path.each do |path_square|
  #       grid.each_with_index do |col, y|
  #         col.each_with_index do |sq, x|
  #           next unless sq.is_a?(Piece) && sq.color == color

  #           move_data[:start_sq] = [y, x]
  #           move_data[:end_sq] = path_square
  #           return false if legal_move?(move_data)
  #         end
  #       end
  #     end
  #   end
  #   true
  # end

  # We need 3 methods now. What 3 methods?
  
  # 1st method needs to return an array of arrays of the player's remaining pieces
  # player_remaining_pcs_coords

  # 2nd method needs to iterate through this array of arrays and apply a method.
  # name: can_any_piece_move?(pcs_coords)

  # 3rd array must take the incoming subarray and apply legal_move? to each
  # of the 64 squares (minus home) and return true if at least 1 legal move is found.
  # We can call this method: piece_can_move?(piece)

  # Replaced #king_cannot_move? and king_not_defendable? with two simplified but
  # slightly less optimized methods.
  # Return an array containing subarrays of the remaining pieces on the board
  # In our current layout: [[3, 2], [0, 7]]