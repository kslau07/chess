# frozen_string_literal: true

# This module provides the menu for chess
module Menuable
  private

  def midgame_menu
    puts menu_options
    menu_input = gets.chomp.downcase # add validation

    case menu_input
    when '1'
      puts 'Game has been saved!'
      save_game_file
    when '2'
      load_game_file
    when '3'
      puts "\nHere is the move list:".blue
      puts move_list.all_moves.join(', ').magenta
      puts ' '
      'move_list'
    when '4'
      help_from_menu
      'help'
    when '5'
      exit_from_menu
    end
    press_any_key
    Display.draw_board(board)
  end

  def menu_options
    <<~HEREDOC
      \n\tMenu Options
      \t#{'1. Save Game'.red}
      \t2. Load Game
      \t3. View Move List
      \t4. Help
      \t5. Exit
    HEREDOC
  end



  def help_from_menu
    puts "\nHelp:"
    puts 'To input a move you may use any of the following notation:'.blue
    puts 'a2a4 | a2 to a4 | a2-a4 | a2 - a4'.red
  end

  def exit_from_menu
    puts 'Oh, okay. See you next time!'
    exit
  end

  def press_any_key
    puts 'Press any key to continue'.green
    gets
    nil
  end
end
