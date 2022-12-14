# frozen_string_literal: true

require 'json'

# This module provides methods used in different classes for Chess
module ChessTools
  def base_move(begin_sq, finish_sq, color)
    factor = color == 'white' ? 1 : -1
    [(finish_sq[0] - begin_sq[0]) * factor, (finish_sq[1] - begin_sq[1]) * factor]
  end

  def out_of_bound?(board, start_sq, end_sq)
    board.squares.include?(start_sq) && board.squares.include?(end_sq) ? false : true
  end

  def translate_notation_to_square_index(move_str)
    [move_str[-1].to_i - 1, move_str[-2].ord - 97]
  end

  def opposing_color(color)
    color == 'white' ? 'black' : 'white'
  end

  def validate_turn_input
    return computer_turn_input if current_player.type == 'computer'

    loop do
      Display.turn_message_human(current_player.color, board)
      user_input = gets.chomp.downcase # normal user_input, uncomment
      # user_input = 'd6d8' if (user_input == '' || user_input.nil?) # delete me
      verified_input = verify_input(user_input)

      return verified_input if verified_input.is_a?(Array)
    end
  end

  def computer_turn_input
    Display.turn_message_computer(current_player.color, board)
    seconds = rand(1..2)
    sleep(seconds)
    random_computer_move
  end

  def random_computer_move
    mv_dat = move_data
    mv_dat[:player] = current_player
    shuffled_comp_squares = board.squares_of_player(current_player.color).shuffle
    shuffled_board_squares = board.squares.shuffle

    shuffled_comp_squares.each do |start_sq|
      shuffled_board_squares.each do |end_sq|
        mv_dat[:start_sq] = start_sq
        mv_dat[:end_sq] = end_sq

        return [start_sq, end_sq] if board.legal_move?(mv_dat)
      end
    end
    nil
  end

  def verify_input(input)
    return midgame_menu if input == 'menu'

    input.gsub!(/[^0-8a-h]/, '')
    # return convert_to_squares(input) if input.match(/^[a-h][0-8][a-h][0-8]$/)
    start_sq, end_sq = convert_to_squares(input) if input.match(/^[a-h][0-8][a-h][0-8]$/)
    return [start_sq, end_sq] if pass_prelim_check?(start_sq, end_sq)

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
    return false if start_sq.nil?
    return false if board.object(start_sq) == 'unoccupied'
    return false if out_of_bound?(board, start_sq, end_sq)
    return false if board.object(end_sq).is_a?(Piece) && board.object(end_sq).color == current_player.color
    return true if board.object(start_sq).is_a?(Piece) && board.object(start_sq).color == current_player.color
  end
end
