# frozen_string_literal: true

# This module provides the menu for chess
module Menuable
  def menu_options
    puts "\n\tMenu Options"
    puts "\t1. Save Game"
    puts "\t2. Load Game"
    puts "\t3. Help"
  end

  def game_menu
    menu_options
    menu_input = gets.chomp.downcase

    case menu_input
    when '1'
      save_from_menu
    when '2'
      load_from_menu
    when '3'
      help_from_menu
      # type any key to continue
    end
    # menu branch, display menu
    # save -> display saved message, then return to get input
    # bring up help -> return to get input
    # load game, variables -> return to get input
    # allow backing out of menu -> return to get input
  end

  def save_from_menu
    puts 'Game has been saved!'
    puts 'Press any key to continue.'
    gets
    nil
  end

  def load_from_menu
    puts 'Game has been loaded!'
    puts 'Press any key to continue.'
    gets
    nil
  end

  def help_from_menu
    puts "\n<< Help >>"
    puts "To input a move you may use any of the following notation:".green
    puts 'a2a4 / a2 to a4 / a2-a4 / a2 - a4'.red
    puts 'Press any key to continue'
    gets
    nil
  end
end
