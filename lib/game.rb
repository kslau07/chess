# frozen_string_literal: true

require_relative 'menuable'
require_relative 'save_load'
require_relative 'chess_tools'

# This is the class for chess
class Game
  include Menuable
  include SaveLoad
  include ChessTools
  attr_reader :board, :player1, :player2, :current_player, :move, :move_list, :game_end, :display

  def initialize(**args)
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')

    # @board = args[:board] || Board.new
    @board = Board.new(args[:board_config] || 'standard')

    @move = Move
    @current_player = @player1
    @move_list = args[:move_list] || MoveList.new
    @display = Display
  end

  # create factory for the factory? for this?
  def create_move(start_sq, end_sq)
    init_hsh = { player: current_player, board: board, move_list: move_list, start_sq: start_sq, end_sq: end_sq }
    move.factory(**init_hsh)
  end

  def turn_sequence
    display.clear_console
    display.draw_board(board)
    new_move = legal_move
    board.promote_pawn(new_move) if board.promotion?(new_move)
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

  # break up into smaller methods
  def legal_move(new_move = nil)
    loop do
      grid_json = board.serialize
      start_sq, end_sq = validate_turn_input
      new_move = create_move(start_sq, end_sq)
      new_move.transfer_piece if new_move.validated
      break if !board.check?(current_player.color) && new_move.validated

      display.invalid_input_message
      revert_board(grid_json, board) if board.check?(current_player.color) # duplicated board.check, better way??
    end
    new_move
  end

  def switch_players
    @current_player = other_player
  end

  def other_player
    current_player == player1 ? player2 : player1
  end

  def win(player)
    display.draw_board(board)
    display.win(player)
    @game_end = true
  end

  def tie
    @game_end = true
  end

  def game_over?
    game_end
  end

  def play_again
    display.play_again_question
    input = gets.chomp
    case input
    when 'y'
      post_initialize
      @game_end = false
      @current_player = player1
      play
    when 'n'
      display.goodbye
      exit
    end
  end
end

class InputError < StandardError
  def message
    'Invalid input!'
  end
end

# What other errors can we subclass?