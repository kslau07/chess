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
    (0..7).each { |x| board.grid[1][x] = chess_pieces[:white_pcs][x] }
    (0..7).each { |x| board.grid[6][x] = chess_pieces[:black_pcs][x] }
  end

  def play
    Display.greeting
    Display.draw_board(board)
    # turn_loop
    turn_loop until game_over?
  end

  def game_over?
    false
  end

  def turn_loop
    Display.turn_message(current_player.color)
    move
    Display.draw_board(board)
    switch_players
  end

  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end

  def move
    Display.starting_point_message
    starting_point = input_move
    starting_point = convert_notation(starting_point)

    Display.end_point_message
    end_point = input_move
    end_point = convert_notation(end_point)
    board.grid[end_point[0]][end_point[1]] = board.grid[starting_point[0]][starting_point[1]]
    board.grid[starting_point[0]][starting_point[1]] = nil
  end

  def input_move(user_input = '')
    loop do
      user_input = gets.chomp.upcase
      break if user_input[0].match(/[A-H]/) && user_input[1].match(/[1-8]/) # uses chess notation

      Display.invalid_input_message
    end
    user_input
  end

  # Convert notation, check nil square
  def convert_notation(chess_notation)
    converted_nums = []
    converted_nums << chess_notation[1].to_i - 1
    converted_nums << chess_notation[0].ord - 65
    # board.grid[converted_nums[0]][converted_nums[1]].nil? ? false : true
  end
end
