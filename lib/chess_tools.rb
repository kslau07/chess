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
    color ||= board.object(begin_sq).color

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
end
