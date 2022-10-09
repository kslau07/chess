# frozen_string_literal: true

require_relative 'menuable'
require_relative 'save_and_load'
require_relative 'chess_tools'
# This is the class for chess
class Game
  include Menuable
  include SaveAndLoad
  include ChessTools
  attr_reader :board, :player1, :player2, :current_player, :move, :move_list, :game_over

  def initialize(**args)
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
    @move = Move
    post_initialize(**args)
  end

  def play
    Display.greeting # change Display to display somehow
    start_sequence
    turn_sequence until game_over
    play_again
  end

  private

  def post_initialize(**args)
    @board = args[:board] || Board.new
    @move_list = args[:move_list] || MoveList.new
    white_set = PieceFactory.create_set('white')
    black_set = PieceFactory.create_set('black')
    pieces = { white_pcs: white_set, black_pcs: black_set }
    setup_board(pieces)
  end

  def setup_board(chess_pieces)
    tl = BoardLayout.new(current_player: current_player, board: board, move_list: move_list, game: self) # delete later

    # tl.normal(chess_pieces)
    tl.pawn_promotion
    # tl.checkmate_scenarios
    # tl.self_check
    # tl.pawn_vs_pawn
    # tl.en_passant_white_version1
    # tl.en_passant_white_version2
    # tl.en_passant_black
    # tl.castle
    # tl.w_pawn_attack
    # tl.b_pawn_attack
  end


  def start_sequence
    start_input = gets.chomp
    # start_input = '1' # auto new game

    case start_input
    when '1'
      Display.draw_board(board)
      puts "\nA new game has started!".magenta
    when '2'
      load_game_file
      press_any_key
    end
  end

  def turn_sequence
    Display.draw_board(board)
    new_move = legal_move
    board.promote_pawn(new_move) if board.promotion?(new_move) # write this method
    new_move.test_check_other_player
    move_list.add(new_move)
    checkmate_seq(new_move) if new_move.checks
    switch_players
  end

  def checkmate_seq(new_move)
    new_move.test_checkmate_other_player(move_data)
    win(current_player) if new_move.checkmates
  end

  def move_data
    { player: other_player, board: board, move_list: move_list, move: move}
  end

  def legal_move(new_move = nil)
    loop do
      grid_json = board.serialize
      start_sq, end_sq = user_input
      new_move = create_move(start_sq, end_sq)

      new_move.transfer_piece if new_move.validated
      break if !board.check?(current_player.color) && new_move.validated

      Display.invalid_input_message
      revert_board(grid_json, board) if board.check?(current_player.color) # duplicated board.check, better way??
    end
    new_move
  end


  # create factory for this?
  def create_move(start_sq, end_sq)
    init_hsh = { player: current_player, board: board, move_list: move_list, start_sq: start_sq, end_sq: end_sq }
    move.factory(**init_hsh)
  end

  def switch_players
    @current_player = other_player
  end

  def other_player
    current_player == player1 ? player2 : player1
  end

  # the follow 4 methods could be moved, or extracted
  def user_input(start_sq = '', end_sq = '')
    loop do
      Display.turn_message(current_player.color)
      puts 'Check!'.bg_red if board.check?(current_player.color)
      input = gets.chomp.downcase # normal input
      # input = 'd6f6' if (input == '' || input.nil?) # auto inputted move, delete me

      if input == 'menu'
        menu_sequence
      else
        cleaned_input = clean(input) # cleaned input may be nil now
        start_sq, end_sq = convert_to_squares(cleaned_input)
        break if pass_prelim_check?(start_sq, end_sq)
      end

      Display.invalid_input_message unless input == 'menu'
    end
    [start_sq, end_sq]
  end

  def clean(input)
    input = input.gsub(/[^0-8a-h]/, '')
    input if input.match(/^[a-h][0-8][a-h][0-8]$/) # same as checking if in-bounds
  end

  def convert_to_squares(input)
    return if input.nil?

    inputted_beg_sq = input[0..1]
    inputted_fin_sq = input[2..3]
    start_sq = translate_notation_to_square_index(inputted_beg_sq)
    end_sq = translate_notation_to_square_index(inputted_fin_sq)
    [start_sq, end_sq]
  end

  def pass_prelim_check?(start_sq, end_sq)
    return false if out_of_bound?(board, start_sq, end_sq)
    return false if board.object(end_sq).is_a?(Piece) && board.object(end_sq).color == current_player.color
    return true if board.object(start_sq).is_a?(Piece) && board.object(start_sq).color == current_player.color
  end

  def menu_sequence
    menu_choice = game_menu
    case menu_choice
    when 'save'
      save_game_file
    when 'load'
      load_game_file
    when 'move_list'
      puts move_list.all_moves.join(', ').magenta
      puts ' '
    when 'help'
    end
    press_any_key
    Display.draw_board(board)
  end

  def win(player)
    Display.draw_board(board)
    Display.win(player)
    @game_over = true
  end

  def tie
    @game_over = true
  end

  def play_again
    Display.play_again_question
    input = gets.chomp
    case input
    when 'y'
      post_initialize
      @game_over = false
      @current_player = player1
      play
    when 'n'
      puts 'Oh okay. See you next time!'
      exit
    end
  end
end
