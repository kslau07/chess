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

  # Array of all 64 squares in index notation
  def squares_array
    squares = []
    8.times do |x|
      8.times do |y|
        squares << [x, y]
      end
    end
    squares
  end

  def setup_board(chess_pieces)
    (0..1).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] }
    (0..1).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] }

    # We can combine these 2 lines somehow. Do it later.
    # (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] }
    # (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] }
  end

  def play
    Display.greeting
    Display.draw_board(board)
    turn_loop

    # turn_loop until game_over?
  end

  def game_over?
    false
  end

  def turn_loop
    Display.turn_message(current_player.color)

    # piece = board.grid[6][0]
    # p piece
    # piece.move

    move
    # Display.draw_board(board)
    switch_players
  end

  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end

  def move
    loop do
      Display.input_start_msg
      start_pt = gets.chomp.split('').map(&:to_i)
      Display.input_end_msg
      end_pt = gets.chomp.split('').map(&:to_i)
      break if permissible?(start_pt, end_pt)

      Display.invalid_input_message
    end
  end

  def permissible?(start_pt, end_pt)

    # false if 1st inputted square is 'unoccupied'
    return false if board.grid[start_pt[0]][start_pt[1]] == 'unoccupied' # 1st input

    # false if second input is off the board
    # return false unless board.grid.dig(end_pt[0], end_pt[1]) # 2nd input
    return false unless squares_array.include?(end_pt)

    # false if piece cannot reach square
    return false unless reachable?(start_pt, end_pt)


    true

    # false if second input is not one of piece's next moves
    # false if puts own king into check

    # array.fetch(1, 'dft val') # fetch uses a value for lookup. dig uses indexing
    # return false unless board.grid.fetch([end_pt[0]], [end_pt[1]])
    # return false unless board.include? board.grid[end_pt[0]][end_pt[1]]
  end

  def reachable?(start_pt, end_pt)
    piece = board.grid[start_pt[0]][start_pt[1]]
    # Create array of possible squares piece can travel to
    p piece.legal_next_moves(start_pt)
    # reachable_squares = [squares]
    # reachable_squares.include?(end_pt)
  end
end

