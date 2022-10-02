# frozen_string_literal: true

# This is the class for chess
class Game
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
    Display.draw_board(board)

    40.times { turn_loop }
    # turn_loop until game_over?
  end
  
  def start_sequence
    start_input = gets.chomp

    case start_input
    when '1'
      puts 'New game!'
    when '2'
      puts 'Loading game!'
      # Write this branch when we are able to save game files
    end
  end

  def game_over?
    # check_mate
    # draw
    false
  end

  def turn_loop
    Display.turn_message(current_player.color)
    new_move = create_move # use factory later
    move_list.add(new_move)
    # board.test_check
    # board.test_mate
    new_move.test_mate(opposing_player, current_player, move) if new_move.check
    
    Display.draw_board(board)

    # We use board_clone for #test_mate
    # board_clone = board.clone

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
    loop do
      new_move = move.prefactory(current_player, opposing_player, board, move_list, self) # rename
      break if new_move.validated || new_move.nil?

      Display.invalid_input_message
    end
    # puts "\n\tmove_list: #{move_list}\n "
    new_move || 
  end


  def switch_players
    @current_player = current_player == player1 ? player2 : player1
    @opposing_player = current_player == player1 ? player2 : player1
  end

  def menu
    puts 'you are now at the menu'
  end
end

# new_move = Move.new(current_player: current_player, board: board, move_list: move_list)