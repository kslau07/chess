# frozen_string_literal: true

# This module tests for check in Board objects
module Check
  # include SaveLoad

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
    color = move_data[:player].color
    kings_sq = square_of_king(color)
    king = object(kings_sq)
    king_cannot_move?(king, kings_sq, move_data) && king_not_defendable?(color, kings_sq, move_data)
  end

  # Returns false if king has at least 1 legal move
  def king_cannot_move?(king, kings_sq, move_data)
    king.possible_moves.none? do |possible_move|
      begin_sq = kings_sq
      finish_sq = [kings_sq[0] + possible_move[0], kings_sq[1] + possible_move[1]]
      next if out_of_bound?(self, begin_sq, finish_sq)

      move_data[:start_sq] = begin_sq
      move_data[:end_sq] = finish_sq
      legal_move?(move_data)
    end
  end

  # Returns false if another piece can remove check
  def king_not_defendable?(color, kings_sq, move_data)
    # Although this method is long, it feels like all parts are necessary
    attackers_paths = find_check_paths(kings_sq)
    attackers_paths.each do |attackers_path|
      attackers_path.each do |path_square|
        grid.each_with_index do |col, y|
          col.each_with_index do |sq, x|
            next unless sq.is_a?(Piece) && sq.color == color

            move_data[:start_sq] = [y, x]
            move_data[:end_sq] = path_square
            return false if legal_move?(move_data)
          end
        end
      end
    end
    true
  end

  # def legal_move?(move_data)
  #   move = move_data[:move]
  #   color = move_data[:player].color
  #   grid_json = serialize
  #   possible_move = move.factory(move_data)
  #   possible_move.transfer_piece if possible_move.validated
  #   result = !check?(color) && possible_move.validated
  #   revert_board(grid_json, self)
  #   result
  # end
end

class Array
  def format_cn
    translate_index_to_notation(self)
  end

  def translate_index_to_notation(sq_array)
    [(sq_array[-1] + 97).chr, sq_array[-2] + 1].join # index to c.n.
  end
end
