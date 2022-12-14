# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative './lib/library'

# This class is a looping script for chess games
class Main
  extend SaveLoad

  def self.start_prompt
    puts "\e[H\e[2J" # clear terminal
    <<~HEREDOC
      \n\t\t#{'Welcome to chess!'.red}\n
      \t\t#{'Select an option:'.green}
      \t\t1. New Game
      \t\t2. Load game
    HEREDOC
  end

  def self.start_prompt2
    puts "\e[H\e[2J" # clear terminal
    <<~HEREDOC
      \t\t#{'Select an option:'.green}
      \t\t1. Play vs. human
      \t\t2. Play vs. computer
    HEREDOC
  end

  def self.start_prompt_select
    loop do
      input = gets.chomp
      return input if input.match(/^[1-2]${1}/)

      puts 'Input error! Enter a choice from above.'
    end
  end

  def self.load_game_or_new(board, move_list)
    puts start_prompt
    start_mode = start_prompt_select
    case start_mode
    when '1'
      puts 'A new game has been loaded!'
      [board, move_list]
    when '2'
      loaded_board, loaded_move_list = load_game_file(board, move_list)
    end
  end

  def self.human_or_computer
    puts start_prompt2
    user_option = start_prompt_select
    case user_option
    when '1'
      Player.new(type: 'human', color: 'black')
    when '2'
      Player.new(type: 'computer', color: 'black')
    end
  end

  def self.play_again(game)
    # Show menu
    # 1. Play again
    # 2. Show move list
    # 3. Quit
    puts <<~HEREDOC
      \t\t#{'Game over!'.red}

      \t\t#{'Select an option:'.green}
      \t\t1. Play again
      \t\t2. View move list
      \t\t3. Quit
    HEREDOC

    input = gets.chomp until %w[1 2 3].include?(input)

    case input
    when '1'
      game.play_again_init(Board.new)
      play(game)
    when '2'
      puts "\nHere is the move list:".blue
      puts game.move_list.all_moves.join(', ').magenta
      puts ' '
      puts 'Press ENTER to continue.' # uncomment later
      gets
      game.display.clear_console
      self.play_again(game)
      nil
    when '3'
      puts 'Oh okay. See you next time!'
      system exit
    end
  end

  def self.play(game)
    # puts 'Press ENTER to continue.' # uncomment later
    # gets
    game.turn_sequence until game.game_over?
    play_again(game)
  end

  board, move_list = load_game_or_new(Board.new, MoveList.new)
  player2 = human_or_computer
  game = Game.new(board: board, move_list: move_list, player2: player2)
  game.configure_board('fix_pawn_cannot_check') # uncomment for testing
  play(game)
end
