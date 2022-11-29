# frozen_string_literal: true

require 'json'

# This module provides methods used in different classes for Chess
module ChessTools
  # NOTE: extract methods from Move to ChessTools
  # ALSO: have methods you can include AND extend, so that
  # the prefactory has access to them.

  # refactor
  # i.e. 2 steps forward would be [2, 0] for either color
  def base_move(begin_sq = nil, finish_sq = nil, color =  nil)
    begin_sq ||= start_sq
    finish_sq ||= end_sq
    color ||= object(begin_sq).color

    case color
    when 'black'
      [begin_sq[0] - finish_sq[0], begin_sq[1] - finish_sq[1]]
    when 'white'
      [finish_sq[0] - begin_sq[0], finish_sq[1] - begin_sq[1]]
    end
  end

  def out_of_bound?(board, start_sq, end_sq)
    board.squares.include?(start_sq) && board.squares.include?(end_sq) ? false : true
  end

  def translate_notation_to_square_index(str_move)
    [str_move[-1].to_i - 1, str_move[-2].ord - 97]
  end

  def opposing_color(color)
    color == 'white' ? 'black' : 'white'
  end

  def validate_turn_input
    loop do
      Display.turn_message(current_player.color, board)
      user_input = gets.chomp.downcase # normal user_input, re-enable
      # user_input = 'b2b4' if (user_input == '' || user_input.nil?) # debug, delete me when app finished
      verified_input = verify_input(user_input)
      return verified_input if verified_input.is_a?(Array)
    end
  end

  def verify_input(input)
    return midgame_menu if input == 'menu'

    input.gsub(/[^0-8a-h]/, '')
    return convert_to_squares(input) if input.match(/^[a-h][0-8][a-h][0-8]$/)

    Display.invalid_input_message
  end

  def convert_to_squares(input)
    return if input.nil?

    inputted_beg_sq = input[0..1]
    inputted_fin_sq = input[2..3]
    start_sq = translate_notation_to_square_index(inputted_beg_sq)
    end_sq = translate_notation_to_square_index(inputted_fin_sq)
    [start_sq, end_sq]
  end

  def pass_prelim_check?(start_sq, end_sq)
    return false if out_of_bound?(board, start_sq, end_sq)
    return false if board.object(end_sq).is_a?(Piece) && board.object(end_sq).color == current_player.color
    return true if board.object(start_sq).is_a?(Piece) && board.object(start_sq).color == current_player.color
  end
end

# Can we use this code snippet?
# This code from an old exercise uses double verification
# verify_input is invoked only if user_input matches regex first
# then, verified_number is returned only if result of verified_input is not nil
# def player_input(min, max)
#   loop do
#     user_input = gets.chomp
#     verified_number = verify_input(min, max, user_input.to_i) if user_input.match?(/^\d+$/)
#     return verified_number if verified_number

#     puts "Input error! Please enter a number between #{min} or #{max}."
#   end
# end

# def verify_input(min, max, input)
#   return input if input.between?(min, max)
# end
