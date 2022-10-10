# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/move'
require_relative '../lib/board'
require_relative '../lib/move_list'
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
--format documentation
Test what not how
use subject
p/puts anywhere in test
let variables vs instance variables
set = variables like this
game = Game.new (and like this)
allow_any_instance_of
expect_any_instance_of
receive_message_chain(:method1, :method2, :method3).and_return('some_value')
instance_variable_get
instance_variable_set
use mocks or stubs sparingly
"

describe Game do
  subject(:game) { Game.new }

  describe '#initialize' do
    # Not tested
  end

  describe '#play' do
    # Script method, not tested
    # Only query and command methods are tested
  end

  # Script method
  describe '#turn_loop' do
  end

  describe '#post_initialize' do
    it 'returns something' do
      expect_any_instance_of(Game).to receive(:post_initialize)
      Game.new
    end

    xit 'creates a new board' do
      expect_any_instance_of(Game).to receive(:post_initialize)

    end
  end
end
