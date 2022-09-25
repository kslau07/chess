# frozen_string_literal: true

# This class creates all_movess
class MoveList
  # perhaps add option to display move list in chess notation, or human readable format
  attr_reader :all_moves # :last_move
  
  def initialize
    @all_moves = []
  end

  # count length, then join on evens, if we want to do a readable list
  def add(move)
    translated_move = []
    # fix below line, too long
    piece_abbr = move.start_piece.class.name[0]
    piece_abbr = 'N' if move.start_piece.instance_of?(Knight)
    translated_move << piece_abbr
    translated_move << (move.start_sq[1] + 97).chr # convert to notation
    translated_move << move.start_sq[0] + 1 # convert to notation
    translated_move << 'x' if move.captured_piece
    translated_move << (move.end_sq[1] + 97).chr # convert to notation
    translated_move << move.end_sq[0] + 1 # convert to notation
    translated_move << '+' # if check
    all_moves << translated_move.join
  end

  def notation_to_index_nums

  end

  # ^ in regex seems to only permit those characters

  def last_move
    all_moves[-1].gsub(/[^0-9A-Za-h]/, '') # alphanumeric, lowercase a-h, x not included
  end

  def prev_sq
    translate_notation_to_square_index(last_move)
  end
  
  def translate_notation_to_square_index(str_move)
    [str_move[-1].to_i - 1, str_move[-2].ord - 97]
  end


  # def cleaned_list
  #   all_moves.map do |move|
  #     move.gsub(/[^0-9A-Za-h]/, '')
  #   end
  # end

  def to_s
    @all_moves.to_s
  end
end