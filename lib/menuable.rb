# frozen_string_literal: true

# This module provides the menu for chess
module Menuable
  def game_menu
    menu_options
    menu_input = gets.chomp.downcase

    case menu_input
    when '1'
      save_from_menu
      'save'
    when '2'
      'load'
    when '3'
      view_move_list_from_menu
      'move_list'
    when '4'
      help_from_menu
      'help'
    when '5'
      exit_from_menu
    end
  end

  def menu_options
    puts "\n\tMenu Options"
    puts "\t1. Save Game"
    puts "\t2. Load Game"
    puts "\t3. View Move List"
    puts "\t4. Help"
    puts "\t5. Exit"
  end

  def save_from_menu
    puts 'Game has been saved!'
  end

  # def load_from_menu
  #   puts 'Game has been loaded!'
  # end

  def view_move_list_from_menu
    puts "\nHere is the move list:".blue
  end

  def help_from_menu
    puts "\nHelp:"
    puts 'To input a move you may use any of the following notation:'.blue
    puts 'a2a4 | a2 to a4 | a2-a4 | a2 - a4'.red
  end

  def exit_from_menu
    puts 'Oh okay. See you next time!'
    exit
  end

  def press_any_key
    puts 'Press any key to continue'.green
    gets
    nil
  end
end
