# frozen_string_literal: true

# This module tests for check in Board objects
module TestCheck
  include SaveAndLoad

  def check?(color)
    attack_paths = paths_that_attack_king(square_of_king(color))
    return false if attack_paths.empty?

    attack_paths.any? { |attack_path| !path_obstructed?(attack_path) }
  end

  def paths_that_attack_king(kings_sq)
    player_color = object(kings_sq).color



    attack_paths = []
    squares.each do |square|
      board_obj = object(square)
      next unless board_obj.is_a?(Piece) && board_obj.color == opposing_color(player_color)

      start_sq = square
      end_sq = kings_sq
      attack_path = board_obj.generate_attack_path(self, start_sq, end_sq)
      attack_paths << attack_path unless attack_path.empty?
    end
    attack_paths
  end

  def square_of_king(color)
    squares.find do |square|
      p [__method__, square.format_cn] if object(square).instance_of?(King) && object(square).color == color # temp delete


      object(square).instance_of?(King) && object(square).color == color
    end
  end

  def checkmate?(move_data)
    # p __method__
    # print 'king_escapes? ', king_escapes?(move_data); puts

    # dummy_legal_move(move_data)

    return false if king_escapes?(move_data) || king_is_defendable?(move_data)

    true
  end

  # def dummy_legal_move(move_data)
  #   move_data[:start_sq] = [0,6]
  #   move_data[:end_sq] = [1,6]
  #   p legal_move?(move_data)
  #   # gets
  # end

  def king_is_defendable?(move_data)
    color = move_data[:player].color
    kings_sq = square_of_king(color)
    attackers_paths = paths_that_attack_king(kings_sq)

    attackers_paths.each do |attackers_path|
      attackers_path.each do |path_square|
        grid.each_with_index do |col, y|
          col.each_with_index do |sq, x|
            if sq.is_a?(Piece) && sq.color == color
              move_data[:start_sq] = [y, x]
              move_data[:end_sq] = path_square
              return true if legal_move?(move_data)
            end
          end
        end
      end
    end
    false
  end

  def king_escapes?(move_data)
    color = move_data[:player].color
    sq_king = square_of_king(color)
    king = object(sq_king)

    king.possible_moves.any? do |possible_move|
      begin_sq = sq_king
      finish_sq = [sq_king[0] + possible_move[0], sq_king[1] + possible_move[1]]
      next if out_of_bound?(self, begin_sq, finish_sq) # check if square is out of bound

      move_data[:start_sq] = begin_sq
      move_data[:end_sq] = finish_sq


      if legal_move?(move_data) # delete this
        puts
        p 'legal king escape move'
        print 'Move: ', [begin_sq.format_cn, finish_sq.format_cn].join; puts
        puts
      end


      legal_move?(move_data)

    end
  end

  # this method could be split up
  def legal_move?(move_data)
    move = move_data[:move]
    color = move_data[:player].color
    grid_json = serialize
    possible_move = move.factory(move_data)
    possible_move.transfer_piece if possible_move.validated

    # puts
    # print 'color', color; puts
    # print 'Move: ', [move_data[:start_sq].format_cn, move_data[:end_sq].format_cn].join; puts
    # print 'check?', check?(color); puts
    # puts

    result = !check?(color) && possible_move.validated
    revert_board(grid_json, self)
    result
  end
end

        # # next if path_square == kings_sq
        # remaining_pieces(color).each do |remaining_piece|
        #   if path_obj == 'unoccupied'
        #     p can_reach_square?(remaining_piece, path_square)
        #   elsif path_obj.is_a?(Piece) && path_obj.color != color
        #     p can_capture_square?(remaining_piece, path_square)
        #   end
        # end


  # def can_reach_square?(defender, target_sq)
  #   path = defender.generate_path(self, defender.location, target_sq)
  #   # p path unles path.empty?
  #   true unless path.empty?
  # end

  # def can_capture_square?(defender, attackers_sq)
  #   path = defender.generate_attack_path(self, defender.location, attackers_sq)
  #   # p path unles path.empty?
  #   true unless path.empty?
  # end

  class Array
    def format_cn
      translate_index_to_notation(self)
    end

    def translate_index_to_notation(sq_array)
      [(sq_array[-1] + 97).chr, sq_array[-2] + 1].join # index to c.n.
    end
  end