# frozen_string_literal: true

# Display is a namespace for puts messages
module Display
  # def self.greeting
  #   puts "\n\t\tWelcome to chess!\n ".red
  #   puts "\t\tSelect an option:".green
  #   puts "\t\t1. New Game"
  #   puts "\t\t2. Load game"
  # end

  def self.draw_board(board)
    puts "\t    0   1   2   3   4   5   6   7  second"
    puts "\t  .-------------------------------."
    7.downto(0) do |x|
      print "\t#{x+1}n|"
      0.upto(7) do |y|
        print board.grid[x][y] == 'unoccupied' ? "   |" : " #{board.grid[x][y]} |"
      end
      print "#{x}i"
      puts
      puts "\t  |---+---+---+---+---+---+---+---|" unless x == 0
    end
    puts "\t  '-------------------------------'"
    puts "\t    a   b   c   d   e   f   i   h"
  end

  def self.turn_message(color, board)
    puts "#{color.capitalize}'s king is in check!".bg_red if board.check?(color)
    puts "\nType 'menu' to see options\n ".green
    puts "#{color.capitalize}, it's your turn!"
    puts 'Enter a move:'
  end

  def self.invalid_input_message
    puts 'That move is not permitted!'.bg_red
    puts 'Type "menu" for help'.red
  end

  def self.input_start_msg
    puts 'Enter starting square:'
  end

  def self.input_end_msg
    puts 'Enter ending square:'
  end

  def self.check
    puts 'Check!'.bg_red
  end

  def self.win(player)
    puts "Checkmate! #{player.color.capitalize} wins the game!".bg_green
  end

  def self.play_again_question
    puts "\nDo you want to play again? [y, n]"
  end

  def self.pawn_promotion(player)
    <<~HEREDOC
      #{player.color.capitalize}, your pawn has been promoted!
      Pick the promotion:\n   1. Queen\n   2. Rook\n   3. Bishop\n   4. Knight
    HEREDOC
  end

  def self.goodbye
    puts 'Oh okay. See you next time!'
  end

end

# These additional methods to String colorize text in the terminal
class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end
  def default;        "\e[39m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end
end
