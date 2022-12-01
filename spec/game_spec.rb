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
  * We should conditions for breaking loop
    * Especially edge cases
`

describe Game do
  let(:player) { double('player')}
  let(:move_list) { double('move_list') }
  let(:board) { double('board') }
  let(:move) { double('move') }
  let(:display) { double('display') }

  before(:each) do
    allow(move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(true)
    @game = Game.new(player1: player, player2: player, move_list: move_list, board: board, move: move, display: display)
  end

  describe '#initialize' do
    # no need to test, only creates instance variables
  end

  describe '#post_initialize' do
    # no need to test, only creates instance variables
  end

  describe '#configure_board' do
    let(:board_config) { class_double('BoardConfig').as_stubbed_const }

    # Outgoing message, must test
    it 'instantiates BoardConfig' do
      expect(board_config).to receive(:new)
      @game.configure_board('standard')
    end
  end
end
