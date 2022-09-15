# frozen_string_literal: true

# This is the class for chess
class Chess
  attr_reader :board, :player1, :player2
  
  def initialize(board = nil, player1 = nil, player2 = nil)
    @board = board || Board.new
    @player1 = player1 || Player.new(name: 'Player One')
    @player2 = player2 || Player.new(name: 'Player Two')
    
  end

  def play
    Display.greeting
    Display.draw_board()
    # game.turn_loop until game.game_over?
  end
end
