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
    @move_list = args[:move_list] || MoveList.new
    @board = args[:board] || Board.new
    @move = args[:move] || Move
    @display = args[:display] || Display
    @current_player = set_current_player # This method is causing issues in testing
  end

  # For testing
  def configure_board(layout_type)
    BoardConfig.new(@board, layout_type, @move_list)
    set_current_player
  end

  # create factory for the factory? for this?
  def create_move(start_sq, end_sq)
    init_hsh = { player: current_player, board: board, move_list: move_list, start_sq: start_sq, end_sq: end_sq }
    move.factory(**init_hsh)
  end

  def turn_sequence
    # display.clear_console # disabled for debugging, re-enable
    display.draw_board(board)
    new_move = legal_move
    # board.promote_pawn(new_move) if board.promotion?(new_move)
    new_move.opponent_check
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

  # Use length of move_list to determine who goes next
  def set_current_player
    player = move_list.all_moves.length.even? ? player1 : player2
    @current_player = player
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

  def play_again_init(board)
    @game_end = false
    @board = board
    move_list.set([])
    set_current_player
  end
end

# What other errors can we subclass?
class InputError < StandardError
  def message
    'Invalid input!'
  end
end
