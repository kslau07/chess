# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative './lib/library'
# perhaps only require game & display here
# then require library within game.rb

# require 'pry-byebug'
# require 'awesome_print'

class Main
  extend SaveLoad

  def self.start_prompt
    <<~HEREDOC
      \n\t\t#{'Welcome to chess!'.red}\n
      \t\t#{'Select an option:'.green}
      \t\t1. New Game
      \t\t2. Load game
    HEREDOC
  end

  def self.start_prompt_select
    loop do
      input = gets.chomp
      return input if input.match(/^[1-2]${1}/)

      puts 'Input error! Enter a choice from above.'
    end
  end

  def self.start_sequence(board, move_list)
    puts start_prompt
    start_mode = start_prompt_select
    case start_mode
    when '1'
      # new game
      # press_enter
      puts 'A new game has been loaded!'
      [board, move_list]
    when '2'
      loaded_board, loaded_move_list = load_game_file(board, move_list)
    end
  end

  def self.play(game)
    puts 'Press ENTER to continue.'
    # gets
    # Use a loop here, break loop if not play_again
    game.turn_sequence until game.game_over?
    game.play_again # this method should be in main, call self.play again
  end

  # board, move_list = start_sequence(Board.new, MoveList.new)
  # game = Game.new(board: board, move_list: move_list)
  # play(game)

  # testing
  game = Game.new
  game.configure_board('en_passant_black')
  play(game)
end

  # Move to Main
  # def play_again
  #   display.play_again_question
  #   input = gets.chomp
  #   case input
  #   when 'y'
  #     post_initialize
  #     @game_end = false
  #     @current_player = player1
  #     play
  #   when 'n'
  #     display.goodbye
  #     exit
  #   end
  # end
