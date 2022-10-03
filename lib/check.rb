# temp file to hold check methods, until we know where to put them

def opposing_color(color)
  color == 'white' ? 'black' : 'white'
end

  # def test_check_for_opposing_player
  #   # puts "\n\t#{self.class}##{__method__}\n "
  #   # @player = opposing_player

  #   if in_check?(opposing_player)
  #     @check = true
  #   end
  # end

  # def test_mate(player, other_player, move)
  #   puts "\n\t#{self.class}##{__method__}\n "

  #   king_escapes?(player, other_player, move)
  # end

  # def king_escapes?(player, other_player, move)

  #   sq_king = square_of_king(player.color)
  #   king = board.object(sq_king)

  #   king.possible_moves.each do |possible_move|
  #     begin_sq = sq_king
  #     finish_sq = [sq_king[0] + possible_move[0], sq_king[1] + possible_move[1]]
  #     next if out_of_bound?(board, begin_sq, finish_sq) # check if square is out of bound

  #     attributes = { player: player,
  #                    opposing_player: other_player,
  #                    board: board,
  #                    move_list: move_list,
  #                    begin_sq: sq_king,
  #                    finish_sq: possible_move }

  #     king_escape_move = move.prefactory_test_mate(attributes) # then we instantiate

  #     p ['finish_sq', finish_sq]
  #     p ['king_escape_move.validated', king_escape_move.validated]
  #   end
  # end


  # def in_check?(player)
  #   # puts "\n\t#{self.class}##{__method__}\n "
  #   attack_paths = paths_that_attack_king(square_of_king(player.color))
  #   p ['attack_paths', attack_paths]
  #   return false if attack_paths.empty?

  #   attack_paths.none? do |attack_path|
  #     path_obstructed?(attack_path)
  #   end
  # end

  # def paths_that_attack_king(sq_of_king)
  #   kings_color = board.object(sq_of_king).color
  #   attack_paths = []
  #   board.squares.each do |square|
  #     board_obj = board.object(square)
  #     next unless board_obj.is_a?(Piece) && board_obj.color == opposing_color(kings_color)

  #     start_sq = square
  #     end_sq = sq_of_king
  #     attack_path = board_obj.generate_attack_path(board, start_sq, end_sq)
  #     attack_paths << attack_path unless attack_path.empty?
  #   end
  #   attack_paths
  # end

  # def square_of_king(color)
  #   # puts "\n\t#{self.class}##{__method__}\n "

  #   board.squares.find do |square|
  #     board.object(square).instance_of?(King) && board.object(square).color == color
  #   end
  # end

  def revert_board
    puts "\n\t#{self.class}##{__method__}\n "
    board.update_square(end_sq, end_obj)
    board.update_square(start_sq, start_piece)
  end