# frozen_string_literal: true

require_relative '../lib/game'

`
Think about the edge of the space capsule!

Testing definitions:
Query Message - Returns a value and contains no side effects
Command Message - Changes state (or value), does not return anything
Looping Script - Similar to a Script except a this one must be broken out of
Outgoing - Sent to another class that is not self
Incoming - Received from another class

Quick recap on what we're actually testing:
* Incoming query messages
  * Assert result
    * 'expect' whatever is returned
* Incoming command messages
  * These are messages sent from other classes
  * Assert direct public side effects
    * That is, 'expect' any state changes
* Query messages sent to Self (ignore)
  * Asking another method within the same class for a value
  * No side effects
  * As far as the rest of the app is concerned, nothing changes
  * Asserting these messages would be micromanaging the HOW
  * It would be difficult to refactor code within a class
  * Test WHAT not HOW
* Command messages sent to Self (ignore)
  * Similar to above, state changes within a class are not real side effects
  * You have restructured variables over and over again within a class
    * Had these been part of tests, you would've been reluctant to experiment
    * Stuff that happens inside a class is like stuff that happens in a method
      * The guts are implementation and not part of the API
* Outgoing Query Messages
  * Since the incoming message is already tested, this is a redundant test
  * What we're testing is the return value, that value would be the same
  whether it's a collaborator that asks or a method from inside a class
  * Since it's redundant, and we only need to test one side, it makes sense
  to only test the incoming messages
  * If we were to test this, it would look like this:
    * expect(outside_class) to receive(some_method)
      * Something is clearly wrong with the above, it doesn't involve
      the class under test at all.
* Outgoing Command Messages
  * These must be sent because this is an interaction between 2 classes
  * expect(outside_class) to receive(some_method)
  * This time it makes sense, one class is changing another class
* Looping Scripts
  * We should test condition for breaking loop
    * Especially edge cases
`

describe Game do
  subject(:game) { described_class.new(player1: player1, player2: player2, move_list: move_list, board: board, move: move, display: display) }
  let(:player1) { double('player1') }
  let(:player2) { double('player2') }
  let(:move_list) { double('move_list') }
  let(:board) { double('board') }
  let(:move) { double('move') }
  let(:display) { double('display') }

  before(:each) do
    allow_message_expectations_on_nil
    allow(move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(true)
    # game = Game.new(player1: player1, player2: player2, move_list: move_list, board: board, move: move, display: display)
  end

  describe '#initialize' do
    # no need to test, only creates instance variables
  end

  describe '#post_initialize' do
    # no need to test, only creates instance variables
  end

  describe '#configure_board' do
    let(:board_config) { class_double('BoardConfig').as_stubbed_const }

    it 'instantiates BoardConfig' do
      expect(board_config).to receive(:new)
      game.configure_board('standard')
    end
  end

  describe '#turn_sequence' do
    before(:each) do
      allow(display).to receive(:draw_board)
      allow(game).to receive(:produce_legal_move)
      allow(board).to receive(:promote_pawn).with(game.new_move)
      allow(game.new_move).to receive(:opponent_check).and_return(true)
      allow(move_list).to receive(:add)
      allow(game.new_move).to receive(:checks).and_return(false)
    end

    it 'sends #draw_board to Display' do
      allow(board).to receive(:promotion?).with(game.new_move)
      expect(display).to receive(:draw_board).with(board)
      game.turn_sequence
    end

    context 'when pawn promotion condition is true' do
      it 'sends Board#promote_pawn' do
        allow(board).to receive(:promotion?).with(game.new_move).and_return(true)
        expect(board).to receive(:promote_pawn)
        game.turn_sequence
      end
    end

    context 'when pawn promotion condition is false' do
      it 'does not send Board#promote_pawn' do
        allow(board).to receive(:promotion?).with(game.new_move).and_return(false)
        expect(board).not_to receive(:promote_pawn)
        game.turn_sequence
      end
    end

    it 'sends #add to MoveList' do
      allow(board).to receive(:promotion?).with(game.new_move)
      expect(move_list).to receive(:add).with(game.new_move)
      game.turn_sequence
    end
  end

  describe 'checkmate_seq' do
    it 'sends #test_checkmate_other_player to Move' do
      allow_message_expectations_on_nil
      allow(game.new_move).to receive(:checkmates).and_return(false)
      expect(game.new_move).to receive(:test_checkmate_other_player)
      game.checkmate_seq
    end
  end

  describe '#produce_legal_move' do
    before do
      allow(game).to receive(:validate_turn_input)
      allow(game).to receive(:create_move)
      allow(game.current_player).to receive(:color)
      allow(game).to receive(:revert_board)
      allow(game).to receive(:revert_board)
    end

    context 'when new_move is valid' do
      it 'sends #transfer_piece to Move' do
        serialized_board = 'json_string'
        allow(game.new_move).to receive(:validated).and_return(true)
        allow(game.board).to receive(:check?).and_return(false)
        expect(game.new_move).to receive(:transfer_piece)
        game.produce_legal_move(serialized_board)
      end
    end

    context 'when new_move is invalid then valid' do
      it 'receives #invalid_input_message once' do
        serialized_board = 'json_string'
        allow(game.new_move).to receive(:validated).and_return(false, true)
        allow(game.board).to receive(:check?).and_return(true, false)
        allow(game.new_move).to receive(:transfer_piece)
        expect(game.display).to receive(:invalid_input_message).exactly(1).time
        game.produce_legal_move(serialized_board)
      end
    end
  end

  describe '#set_current_player' do
    it 'sets current_player to player1 when move_list is even' do
      allow(game.move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(true)
      game.set_current_player
      expect(game.current_player).to be(game.player1)
    end

    it 'does NOT set current_player to player1 when move_list is odd' do
      allow(game.move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(false)
      game.set_current_player
      expect(game.current_player).not_to be(game.player1)
    end
  end

  describe '#switch_players' do
    it 'changes current_player' do
      curr_plyr = game.instance_variable_get(:@current_player)
      game.switch_players
      expect(game.current_player).not_to be(curr_plyr)
    end
  end

  describe '#other_player' do
    it 'returns player who is not current_player' do
      curr_play = game.instance_variable_get(:@current_player)
      expect(game.other_player).not_to be(curr_play)
    end
  end

  describe '#win' do
    before do
      allow(display).to receive(:draw_board).with(board)
      allow(display).to receive(:win).with(player1)
    end

    it 'returns true for @game_end' do
      game.win(player1)
      expect(game.game_end).to be true
    end
  end

  describe '#tie' do
    it 'returns true for @game_end' do
      game.tie
      expect(game.game_end).to be true
    end
  end

  describe '#game_over?' do
    # calls method within class, ignore
  end

  describe '#play_again_init' do
    it 'sets @game_end to false' do
      allow(game.move_list).to receive(:set)
      allow(game).to receive(:set_current_player)
      game.play_again_init(board)
      expect(game.game_end).to be false
    end

    it 'sets @board to board' do
      allow(game.move_list).to receive(:set)
      allow(game).to receive(:set_current_player)
      game.play_again_init(board)
      expect(game.board).to be(board)
    end

    it 'sets move_list to an empty array' do
      allow(game).to receive(:set_current_player)
      expect(move_list).to receive(:set).with(kind_of(Array))
      game.play_again_init(board)
    end
  end
end
