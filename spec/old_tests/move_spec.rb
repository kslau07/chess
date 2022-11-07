# frozen_string_literal: true

# require_relative '../lib/game'
# require_relative '../lib/player'
require_relative '../lib/move'
# require_relative '../lib/board'
# require_relative '../lib/move_list'
# require_relative '../lib/display'
# require_relative '../lib/board_layout'
# require_relative '../lib/piece_factory'
# require_relative '../lib/pieces/pawn'
# require_relative '../lib/pieces/bishop'
# require_relative '../lib/pieces/knight'
# require_relative '../lib/pieces/rook'
# require_relative '../lib/pieces/queen'
# require_relative '../lib/pieces/king'

"
A query method returns a value
A command method sets a value
A scripting method only calls other methods

Some things to remember:
-test integration, read this:
https://www.codewithjason.com/rails-integration-tests-rspec-capybara/#:~:text=Like%20I%20said%20earlier%2C%20an,referring%20to%20RSpec%20feature%20specs.

instance_variable_get is discouraged because it breaks encapsulation.
Tests should respect because we're interested in the observable state of the
system, not the internal implementation details.
Dependency injection is a good way to avoid instance_variable_get, while
also not defining a public setter for that instance variable.
Name your numbers! Magic numbers code smell - when numbers magically do things
because the reader is not informed of what they actually mean.
HEIGHT = 6
WIDTH = 7

-how do we use as_null_object?
  -it's an object that ignores all messages except for our assertion(???)
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

Some methods seem too complicated to test, such as Move.factory, we can
try to test it later.

We'll need to rewrite some code to be able to test integration more easily. We'll
need to be able to setup our board here easily for testing things like draw, checkmate, etc.
"

describe Move do

  # how can we test this method?
  # method has too many moving parts to unit test, integration test is better
  describe 'Move.factory' do
    xit 'instantiates a Move variant through candidate.handles?' do
      dbl = double('Candidate')
      args = [dbl]
      described_class.factory(args)
    end
  end
end
