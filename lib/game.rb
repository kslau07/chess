# frozen_string_literal: true

# This is the class for chess
class Game
  attr_reader :board, :player1, :player2, :current_player, :move, :move_list

  def initialize(**args)
    @board = args[:board] || Board.new
    @player1 = args[:player1] || Player.new(color: 'white')
    @player2 = args[:player2] || Player.new(color: 'black')
    @current_player = @player1
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
    # tl.normal(chess_pieces)

    tl.bishop_self_check
    # tl.pawn_vs_pawn
    # tl.en_passant_white_version1
    # tl.en_passant_white_version2
    # tl.en_passant_black
    # tl.castle
    # tl.w_pawn_capture
    # tl.b_pawn_capture

  end

  def play
    Display.greeting    # change Display to display somehow
    Display.draw_board(board)

    40.times { turn_loop }
    # turn_loop until game_over?
  end

  def game_over?
    # check_mate
    # draw
    false
  end

  def turn_loop
    Display.turn_message(current_player.color)
    create_move # use factory later
    Display.draw_board(board)
    switch_players
  end

  # We need to basically immediately get to the Move factory, which will choose
  # among regular move, en passant, castle (and maybe more). We do NOT want to
  # instantiate Move. We will do as Metz did, we will first go through Move
  # class methods, the factory will also be a class method. The factory brings
  # us the instance we need. 

  # We loop new_move if it is not valid, as it's more difficult for us to 
  # know if a move is valid without going through a Move or Move variant instance.

  # create factory for this
  def create_move(new_move = nil)
    # puts "\n\t#{self.class}##{__method__}\n "

    # p move_list

    loop do
      new_move = move.prefactory(current_player, board, move_list) # rename
      break if new_move.validated

      Display.invalid_input_message
    end

    move_list.add(new_move)

    puts "\n\tmove_list: #{move_list}\n "
    # puts "\n\tlast_move: #{move_list.last_move}\n"
  end


  def switch_players
    @current_player = current_player == player1 ? player2 : player1
  end
end

# new_move = Move.new(current_player: current_player, board: board, move_list: move_list)