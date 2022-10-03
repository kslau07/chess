# frozen_string_literal: true

require_relative 'menuable'
require_relative 'save_and_load'
# This is the class for chess
class Game
  include Menuable
  include SaveAndLoad
  attr_reader :board, :player1, :player2, :current_player, :opposing_player, :move, :move_list

  def initialize(**args)
    @board = args[:board] || Board.new
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
    @opposing_player = @player2
    @move = Move
    post_initialize(**args)
  end

  def post_initialize(**args)
    @move_list = args[:move_list] || MoveList.new
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
  end

  def setup_board(chess_pieces)
    tl = TempLayout.new(current_player: current_player, board: board, move_list: move_list, game: self) # delete later

    tl.normal(chess_pieces)

    # tl.self_check
    # tl.pawn_vs_pawn
    # tl.en_passant_white_version1
    # tl.en_passant_white_version2
    # tl.en_passant_black
    # tl.castle
    # tl.w_pawn_attack
    # tl.b_pawn_attack
  end

  def play
    Display.greeting # change Display to display somehow
    start_sequence
    # Display.draw_board(board)

    turn_loop # run once, testing
    # 40.times { turn_loop }
    # turn_loop until game_over?
  end

  def start_sequence
    start_input = gets.chomp
    case start_input
    when '1'
      Display.draw_board(board)
      puts "\nA new game has started!".magenta
    when '2'
      # puts 'Loading game!'
      load_game_file
      press_any_key

      # load_from_start
      # Write this branch when we are able to save game files
      # load game will simply overwrite @board and move_list, use move_list to calculate @current_player
    end
  end

  def turn_loop
    Display.turn_message(current_player.color)
    user_input

    # pass move input to prefactory
    # new_move = create_move
    move_list.add(new_move) # No longer test for check within Move
    # board.test_check
    # board.test_mate
    Display.draw_board(board)
    # We use board_clone for #test_mate
    # board_clone = board.clone
    switch_players
  end

  def user_input(input = '')
    loop do
      puts 'Another message goes here?'
      puts 'Enter a move:'
      input = gets.chomp.downcase
      if input == 'menu'
        menu_sequence
      else
        # move branch -> check input, continue turn loop
        cleaned_input = clean(input)
        prelim_check(cleaned_input)

      end

      Display.invalid_input_message unless input == 'menu'
      # break if input is good
    end
    # input
  end

  def clean(input)
    # how should we clean input?
    input
  end

  def prelim_check(input)
    
    check_input(input)
  end

  def check_input(input)
    return false if out_of_bound?
    # return false if @board.object(@start_sq) == 'unoccupied'
    return false if @board.object(@end_sq).is_a?(Piece) && @board.object(@end_sq).color == @current_player.color
    return true if @board.object(@start_sq).is_a?(Piece) && @board.object(@start_sq).color == @current_player.color
  end

  def out_of_bound?
    @board.squares.include?(@start_sq) && @board.squares.include?(@end_sq) ? false : true
  end

  def menu_sequence
    menu_choice = game_menu
    case menu_choice
    when 'save'
      save_game_file
    when 'load'
      load_game_file
      # Display.draw_board(board)
    when 'move_list'
      puts move_list.all_moves.join(', ').magenta
      puts ' '
    when 'help'
    end
    press_any_key
    Display.draw_board(board)
  end

  # create factory for this?
  def create_move(new_move = nil)
    loop do
      new_move = move.prefactory(current_player, opposing_player, board, move_list, self) # rename
      break if new_move.validated || new_move.nil?

      Display.invalid_input_message
    end
    new_move
  end

  def switch_players
    @current_player = current_player == player1 ? player2 : player1
    @opposing_player = current_player == player1 ? player2 : player1
  end

  def game_over?
    # check_mate
    # draw
    false
  end
end
