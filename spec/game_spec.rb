# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/move'
require_relative '../lib/board'
require_relative '../lib/move_list'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'
require_relative '../lib/board_layout'


"
A query method returns a value
A command method sets a value
A scripting method only calls other methods

Some things to remember:
-a stub is a canned response
-a mock is a test that can pass or fail (an assertion)
--format documentation
-Test what not how
-use subject
-p/puts anywhere in test
-let variables vs instance variables
-set = variables like this
-game = Game.new (and like this)
-allow_any_instance_of
-expect_any_instance_of
-receive_message_chain(:method1, :method2, :method3).and_return('some_value')
-instance_variable_get
-instance_variable_set
-use mocks or stubs sparingly
"

"
Notes from writing tests:
For some reason, subject.current_player did not work for a long time 
until it suddenly did, from trying to test #initialize.

"

describe Game do
  subject(:game) { described_class.new }

  describe '#initialize' do
    it 'sets @player1 to a kind of Player' do
      expect(subject.player1).to be_a(Player)
    end

    it 'sets @player2 to a kind of Player' do
      expect(subject.player2).to be_a(Player)
    end

    it 'sets @current_player to a kind of Player' do
      expect(subject.current_player).to be_a(Player)
    end
  end

  describe '#play' do
    before do
      allow(game).to receive(:gets).and_return('a')
    end

    it 'calls Display.greeting' do
      allow(game).to receive(:start_sequence)
      allow(game).to receive(:turn_sequence)
      allow(game).to receive(:play_again)
      allow(game).to receive(:game_over).and_return(true)
      expect(Display).to receive(:greeting) # nil
      game.play
    end
  end

  # Script method
  describe '#turn_loop' do
  end

  describe '#post_initialize' do
    it 'is invoked when Game is initialized' do
      expect_any_instance_of(Game).to receive(:post_initialize)
      Game.new
    end

    xit 'creates a new board' do
    end
  end

  describe '#play' do
    # this is a script method, test invoked called within
    
    # let(:game_play) { described_class.new }
    
    # before do
    #   allow(game_play).to receive(:puts)
    #   allow(game_play).to receive(:start_sequence)
    #   allow(game_play).to receive(:turn_sequence)

    #   allow(Display).to receive(:puts)
      
    #   #  until game_over
      
    # end

    # it 'calls Display.greeting' do
    #   # expect(game_play).to receive(Display.greeting)
    #   expect(game_play).to receive(:play_again)
    #   game_play.play
    # end
  end
end
