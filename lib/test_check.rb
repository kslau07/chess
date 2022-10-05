# frozen_string_literal: true

# This module tests for check in Board objects
module TestCheck
  include SaveAndLoad

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

  # test if checkate for color indicated
  # remove delegation if not needed
  def checkmate?(move_data)
    p __method__

    
    p king_escapes?(move_data)

    gets
  end

  # How do we start this?
  # Check the king with a rook
  # Find one single square it can legally move to
  # checkmate is false at that point

  # does king of given color have one escape square
  def king_escapes?(move_data)
    p __method__
    color = move_data[:player].color
    sq_king = square_of_king(color)
    king = object(sq_king)


    king.possible_moves.any? do |possible_move|

      
      begin_sq = sq_king
      finish_sq = [sq_king[0] + possible_move[0], sq_king[1] + possible_move[1]]
      next if out_of_bound?(self, begin_sq, finish_sq) # check if square is out of bound

      # p ['finish_sq', finish_sq]

      move = move_data[:move]
      player = move_data[:player]
      move_list = move_data[:move_list]
      start_sq = begin_sq
      end_sq = finish_sq


      king_escape_move = move.factory(player: player, board: self,
                                      move_list: move_list, start_sq: start_sq, end_sq: end_sq)
      #

      # serialize board + move_list here
      grid_json = serialize
      revert_board(grid_json, self)
      # load_board(grid_json)

      require 'pry-byebug'; binding.pry # debugging, delete
      
      p king_escape_move.start_sq
      p king_escape_move.end_sq
      p king_escape_move.validated
      p !check?(color)

      
      # revert board and move_list if move results in check
      # return true if king escapes (move is valid and move does not result in check)

      king_escape_move.validated && !check?(color)
      # p ['king_escape_move.validated', king_escape_move.validated]
    end
  end
end
