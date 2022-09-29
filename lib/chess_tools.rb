# frozen_string_literal: true

# This module provides methods used in different classes for Chess
module ChessTools
  # i.e. 2 steps forward would be [2, 0] for either color
  def base_move(begin_sq = nil, finish_sq = nil, color =  nil)
    puts "\n\t#{self.class}##{__method__}\n "

    begin_sq ||= start_sq
    finish_sq ||= end_sq
    color ||= board.object(begin_sq).color



    p ['color', color]
    
    # p ['begin_sq', begin_sq]
    # p ['finish_sq', finish_sq]
    

    case color
    when 'black'
      [begin_sq[0] - finish_sq[0], begin_sq[1] - finish_sq[1]]
    when 'white'
      [finish_sq[0] - begin_sq[0], finish_sq[1] - begin_sq[1]]
    end
  end
end