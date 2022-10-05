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

    # p move_data
    # gets

    color = move_data[:player].color
    sq_king = square_of_king(color)
    king = object(sq_king)

    counter = 0
    king.possible_moves.each do |possible_move| # change to any?
      # break if counter == 2
      # print 'counter', counter += 1; puts

      begin_sq = sq_king
      finish_sq = [sq_king[0] + possible_move[0], sq_king[1] + possible_move[1]]
      next if out_of_bound?(self, begin_sq, finish_sq) # check if square is out of bound

      move_data[:start_sq] = begin_sq
      move_data[:end_sq] = finish_sq
      test_king_move(move_data)

      # possible_king_escape_mv.validated && !check?(color)
    end
  end

  def test_king_move(move_data)
    move = move_data[:move]
    color = move_data[:player].color

    grid_json = serialize
    possible_king_escape_mv = move.factory(move_data)
    possible_king_escape_mv.transfer_piece if possible_king_escape_mv.validated

    # check out results
    # print possible_king_escape_mv.start_sq, possible_king_escape_mv.end_sq; puts
    # print 'validated ', possible_king_escape_mv.validated; puts
    # print 'NOT check? ', !check?(move_data[:player].color); puts


    result = !check?(color) && possible_king_escape_mv.validated
    revert_board(grid_json, self)
    result
  end
end


    # move = move_data[:move]
    # player = move_data[:player]
    # move_list = move_data[:move_list]
    # start_sq = begin_sq
    # end_sq = finish_sq


    # pass in a hash, there are too many variables to set
    # on the other side we will automate setting variables
    # possible_king_escape_mv = move.factory(player: player, board: self,
                                    # move_list: move_list, start_sq: start_sq, end_sq: end_sq)



    # methods involving a new Move
    # serialize board
    # new_move.factory(init_hsh)
    # new_move.transfer_piece if new_move.validated
    # revert board if check
    # pass if !new_move.check? && new_move.validated

    # break if !board.check?(current_player.color) && new_move.validated
