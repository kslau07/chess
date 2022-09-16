# frozen_string_literal: true

# This is the class for chess
class Chess
  attr_reader :board, :player1, :player2, :current_player

  def initialize(board = nil, player1 = nil, player2 = nil)
    @board = board || Board.new
    @player1 = player1 || Player.new(color: 'white')
    @player2 = player2 || Player.new(color: 'black')
    @current_player = @player1
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
  end

  def setup_board(chess_pieces)
    # We can combine these 2 lines somehow. Do it later.
    (0..7).each { |x| board.squares[1][x] = chess_pieces[:white_pcs][x] }
    (0..7).each { |x| board.squares[6][x] = chess_pieces[:black_pcs][x] }
  end

  def play
    Display.greeting
    Display.draw_board(board)
    turn_loop
    # turn_loop until game_over?
  end

  def turn_loop
    Display.turn_message(current_player.color)
    # chess_notation
    p input_move
  end

  def input_move(user_input = '')
    loop do
      user_input = gets.chomp.upcase
      break if user_input[0].match(/[A-H]/) && user_input[1].match(/[1-8]/) # uses chess notation

      invalid_input_message
    end
    user_input
  end
end


  # def chess_notation
  #   spaces = []
  #   ('A'..'H').each do |letter|
  #     (1..8).each do |number|
  #       spaces << [letter, number].join
  #     end
  #   end
  #   spaces
  # end