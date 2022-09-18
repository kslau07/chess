# frozen_string_literal: true

# Display is a namespace for puts messages
module Display
  def self.greeting
    puts "\n\t\tWelcome to chess!\n ".red
  end


  def self.draw_board(board)
    puts "\t    0   1   2   3   4   5   6   7  second"
    puts "\t  .-------------------------------."
    7.downto(0) do |x|
      print "\t#{x} |"
      0.upto(7) do |y|
        print board.grid[x][y] == 'unoccupied' ? "   |" : " #{board.grid[x][y]} |"
      end
      puts
      puts "\t  |---+---+---+---+---+---+---+---|" unless x == 0
    end
    puts "\t  '-------------------------------'"
    puts "\t    0   1   2   3   4   5   6   7"
  end

  def self.turn_message(color)
    puts "#{color.capitalize}, it's your turn!"
  end

  def self.invalid_input_message
    puts 'That is not a legal move!'.red
  end

  def self.input_start_msg
    puts 'Enter starting square:'
  end

  def self.input_end_msg
    puts 'Enter ending square:'
  end
end


# This module makes sure user input matches given criteria
# module ValidInput
#   include Display

#   # def validate_input(allowable_chars, user_input = '')
#   #   allowable_chars.map!(&:to_s)
#   #   user_input = gets.chomp.downcase
#   #   user_input
#   # end

#   def self.validate_input(allowable_chars, user_input = '')
#     allowable_chars.map!(&:to_s)
#     loop do
#       user_input = gets.chomp.downcase
#       break if allowable_chars.include?(user_input)

#       invalid_input_message
#     end
#     user_input
#   end
# end


# Uses chess notation legend
  # # Later: remove #{x}, it's 3 spaces
  # def self.draw_board(board)
  #   puts "\t      (0) (1) (2) (3) (4) (5) (6) (7) second"
  #   puts "\t     .-------------------------------."
  #   7.downto(0) do |x|
  #     print "\t#{x+1}(#{x}) |" # <- remove here
  #     0.upto(7) do |y|
  #       print board.grid[x][y].nil? ? "   |" : " #{board.grid[x][y]} |"
  #     end
  #     puts
  #     puts "\t     |---+---+---+---+---+---+---+---|" unless x == 0
  #   end
  #   puts "\t     '-------------------------------'"
  #   puts "\t       A   B   C   D   E   F   G   H"
  # end

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

# puts "\t.-------------------------------."
# puts "\t| ♜ | ♞ | ♝ | ♛ | ♚ | ♝ | ♞ | ♜ |"
# puts "\t|---+---+---+---+---+---+---+---|"
# puts "\t| ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ | ♟ |"
# puts "\t|---+---+---+---+---+---+---+---|"
# puts "\t|   |   |   |   |   |   |   |   |"
# puts "\t|---+---+---+---+---+---+---+---|"
# puts "\t|   |   |   |   |   |   |   |   |"
# puts "\t|---+---+---+---+---+---+---+---|"
# puts "\t|   |   |   |   |   |   |   |   |"
# puts "\t|---+---+---+---+---+---+---+---|"
# puts "\t| ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ | ♙ |"
# puts "\t|---+---+---+---+---+---+---+---|"
# puts "\t| ♖ | ♘ | ♗ | ♕ | ♔ | ♗ | ♘ | ♖ |"
# puts "\t'-------------------------------'"