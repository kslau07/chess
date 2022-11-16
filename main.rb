# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative './lib/library'
# perhaps only require game & display here
# then require library within game.rb

# require 'pry-byebug'
# require 'awesome_print'

class Main
  extend SaveLoad
  extend ChessTools

  def self.start_menu
    <<~HEREDOC
      \n\t\t#{'Welcome to chess!'.red}\n
      \t\t#{'Select an option:'.green}
      \t\t1. New Game
      \t\t2. Load game
    HEREDOC
  end

  def self.start_sequence
    puts start_menu
    # start_input = select_initial_mode
    start_input = gets.chomp
    # start_input = '1' # auto new game
    case start_input
    when '1'
      puts "\nA new game was loaded!".magenta
      config = 'standard'
    when '2'
      # When we created load_game_file, it was extended to Game
      # Now we are in Main, we do not have access to @board nor @move_list
      # Let's  the necessary logic here, then instantiate Board & MoveList, then pass those to Game
      # press_any_key
      load_game_file
      config = 'pawn_promotion'
    end

    board = Board.new(config)
    move_list = MoveList.new
    Game.new(board: board, move_list: move_list)
  end

  def self.play(game)
    # Use a loop here, break loop if not play_again
    game.turn_sequence until game.game_over?
    game.play_again
  end

  game = start_sequence
  play(game)

end

# # game = Game.new(board_config: 'pawn_promotion')
# game = start_sequence
# play(game)

# <<~HEREDOC
#   How do we move the start menu to main.rb?
  
# HEREDOC


  # Needed to get layout working properly:
  # setter for @current_player
  # setter for @move_list

  # def play
  #   start_menu
  #   turn_sequence until game_over?
  #   play_again
  # end
