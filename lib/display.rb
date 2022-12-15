# frozen_string_literal: true

# Display is a namespace for puts messages
module Display
  def self.clear_console
    puts "\e[H\e[2J"
  end

  def self.draw_board(board)
    # puts "\t    0   1   2   3   4   5   6   7  second"
    puts "\t  .-------------------------------."
    7.downto(0) do |x|
      print "\t#{x+1} |"
      0.upto(7) do |y|
        print board.grid[x][y] == 'unoccupied' ? "   |" : " #{board.grid[x][y]} |"
      end
      # print "#{x}i"
      puts
      puts "\t  |---+---+---+---+---+---+---+---|" unless x == 0
    end
    puts "\t  '-------------------------------'"
    puts "\t    a   b   c   d   e   f   g   h"
  end

  def self.turn_message_human(color, board)
    puts "#{color.capitalize}'s king is in check!".bg_red if board.check?(color)
    puts "\nType 'menu' for help and options.\n ".green
    puts "#{color.capitalize}, it's your turn!"
    puts 'Enter a move:'
  end

  def self.turn_message_computer(color, board)
    puts "#{color.capitalize}'s king is in check!".bg_red if board.check?(color)
    puts "\t\nThe computer is thinking...\n "
  end

  def self.invalid_input_message
    puts 'That move is not permitted!'.bg_red
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
    puts "\n\tCheckmate! #{player.color.capitalize} wins the game!\n".green
  end

  def self.pawn_promotion(player)
    <<~HEREDOC
      #{player.color.capitalize}, your pawn has been promoted!
      Pick the promotion:\n   1. Queen\n   2. Rook\n   3. Bishop\n   4. Knight
    HEREDOC
  end
end
