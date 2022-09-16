# frozen_string_literal: true

# This is the class for chess
class Chess
  attr_reader :board, :player1, :player2
  
  def initialize(board = nil, player1 = nil, player2 = nil)
    @board = board || Board.new
    @player1 = player1 || Player.new(name: 'Player One')
    @player2 = player2 || Player.new(name: 'Player Two')
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    set_up_board(pieces)
  end

  def set_up_board(chess_pieces)
    [1, 6].each do |i|
      (0..7).each do |x|
        board.squares[i][x] = chess_pieces[0][x] if i == 1
        board.squares[i][x] = chess_pieces[1][x] if i == 6
      end
    end
  end

  def create_chess_pieces

    # @board.squares[1][0] = PieceFactory.create('Pawn', 'white')
    # @board.squares[6][0] = PieceFactory.create('Pawn', 'black')
  end

  def play
    Display.greeting
    Display.draw_board(board)
    # game.turn_loop until game.game_over?
  end


end
