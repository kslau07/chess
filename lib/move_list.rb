# frozen_string_literal: true

# This class creates all_movess
class MoveList
  # perhaps add option to display move list in chess notation, or human readable format
  attr_reader :last_move, :all_moves
  
  def initialize
    @all_moves = []
  end

  def add(move)
    # count length, then join on evens


    translated_move = []

    # fix below line, too long
    move.start_piece.class.name == 'Knight' ? translated_move << 'N' : translated_move << move.start_piece.class.name[0]
    translated_move << 'x' if move.captured_piece
    translated_move << (move.end_sq[1] + 97).chr
    translated_move << move.end_sq[0]
    # translated_move << '+' # if check
    all_moves << translated_move.join

    puts ">>> all_moves : #{all_moves}"
  end

  # ^ in regex seems to only permit those characters

  def last_move
    # puts '>>> find last move by using all_moves[-1]'
    # all_moves[-1].split(' ')[-1].gsub(/[^0-9A-Za-h]/, '') # allow only alphanumeric chars
  end


  def print_last_move

  end

  def to_s
    puts 'print all moves here'
  end
end