# frozen_string_literal: true

require 'json'

# This module provides methods used in different classes for Chess
module ChessTools
  # NOTE: extract methods from Move to ChessTools
  # ALSO: have methods you can include AND extend, so that
  # the prefactory has access to them.

  # i.e. 2 steps forward would be [2, 0] for either color
  def base_move(begin_sq = nil, finish_sq = nil, color =  nil)
    # puts "\n\t#{self.class}##{__method__}\n "

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

  # refactor this method, maybe into 2 methods
  def user_input(start_sq = '', end_sq = '')
    loop do
      Display.turn_message(current_player.color, board)
      input = gets.chomp.downcase # normal input
      # input = 'd6f6' if (input == '' || input.nil?) # auto inputted move, delete me

      if input == 'menu'
        midgame_menu
      else
        cleaned_input = clean(input) # cleaned input may be nil now
        start_sq, end_sq = convert_to_squares(cleaned_input)
        break if pass_prelim_check?(start_sq, end_sq)
      end

      Display.invalid_input_message unless input == 'menu'
    end
    [start_sq, end_sq]
  end

  def clean(input)
    input = input.gsub(/[^0-8a-h]/, '')
    input if input.match(/^[a-h][0-8][a-h][0-8]$/) # same as checking if in-bounds
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
