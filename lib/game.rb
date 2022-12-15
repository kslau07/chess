# frozen_string_literal: true

require_relative 'menuable'
require_relative 'save_load'
require_relative 'chess_tools'

# This is the class for chess
class Game
  include Menuable
  include SaveLoad
  include ChessTools
  attr_reader :board, :player1, :player2, :current_player, :move, :move_list,
              :game_end, :display, :new_move

  def initialize(**args)
    @player1 = args[:player1] || Player.new(color: 'white', type: 'human')
    @player2 = args[:player2] || Player.new(color: 'black', type: 'human')
    @move_list = args[:move_list] || MoveList.new
    @board = args[:board] || Board.new
    @move = args[:move] || Move
    @display = args[:display] || Display
    @current_player = set_current_player
  end

  # Used for testing
  def configure_board(layout_type)
    BoardConfig.new(@board, layout_type, @move_list)
    set_current_player
  end

  def turn_sequence
    display.clear_console # debug, uncomment later
    display.draw_board(board)
    @new_move = produce_legal_move
    board.promote_pawn(new_move) if board.promotion?(new_move)
    new_move.opponent_check
    move_list.add(new_move)
    check_game_over(new_move) # checkmate/draw
    switch_players
  end

  def move_data
    { player: other_player, board: board, move_list: move_list, move: move }
  end

  def produce_legal_move(grid_json = board.serialize)
    loop do
      start_sq, end_sq = validate_turn_input

      new_move = create_move(start_sq, end_sq)
      new_move.transfer_piece if new_move.validated
      return new_move if !board.check?(current_player.color) && new_move.validated

      display.invalid_input_message
      revert_board(grid_json, board)
    end
  end

  def create_move(start_sq, end_sq)
    init_hsh = { player: current_player, board: board, move_list: move_list, start_sq: start_sq, end_sq: end_sq }
    move.factory(**init_hsh)
  end

  def set_current_player
    next_turn = move_list.all_moves.length.even? ? player1 : player2
    @current_player = next_turn
  end

  def switch_players
    @current_player = other_player
  end

  def other_player
    current_player == player1 ? player2 : player1
  end

  def check_game_over(new_move)
    checkmate_seq if new_move.checks
    check_for_draw unless game_over?
  end

  def check_for_draw
    return if move_list.all_moves.empty?

    game_is_draw if three_fold_repetition? ||
                    insufficient_material? ||
                    fifty_move_rule? ||
                    pieces_are_stuck?
  end

  def three_fold_repetition?
    return false if move_list.all_moves.size < 12

    all_mvs = move_list.all_moves
    subary1 = all_mvs[-12..-9]
    subary2 = all_mvs[-8..-5]
    subary3 = all_mvs[-4..]
    cond1 = subary1 == subary2
    cond2 = subary1 == subary3

    cond1 && cond2
  end

  def insufficient_material?
    pcs_remaining = board.names_of_pcs_remaining

    scenario1 = [King, King]
    scenario2 = [King, King, Bishop]
    scenario3 = [King, King, Knight]

    cond1 = (pcs_remaining - scenario1).empty?
    cond2 = (pcs_remaining - scenario2).empty?
    cond3 = (pcs_remaining - scenario3).empty?

    cond1 || cond2 || cond3
  end

  def fifty_move_rule?
    return false if move_list.all_moves.size < 50

    cond1 = move_list.all_moves[-50..].none? { |str| str.include?('P') }
    cond2 = move_list.all_moves[-50..].none? { |str| str.include?('x') }
    cond1 || cond2
  end

  def pieces_are_stuck?
    opp_mv_dat = move_data
    curr_mv_dat = move_data
    curr_mv_dat[:player] = current_player
    cond1 = board.no_pieces_can_move?(opp_mv_dat)
    cond2 = board.no_pieces_can_move?(curr_mv_dat)

    cond1 || cond2
  end

  def game_is_draw
    display.draw_board(board)
    puts "\n"
    puts 'Game ended in a draw!'.bg_red
    @game_end = true
  end

  def checkmate_seq
    new_move.test_checkmate_other_player(move_data)
    win(current_player) if new_move.checkmates
  end

  def win(player)
    display.clear_console
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
