# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'move'
require_relative 'special_moves/en_passant'
require_relative 'special_moves/castle'
require_relative 'special_moves/pawn_capture'
require_relative 'special_moves/pawn_double_step'
require_relative 'move_list'
require_relative 'player'
require_relative 'display'
require_relative 'piece_factory'
require_relative 'piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'

def play(game)
  # NOTE: move scripting methods here once game is finished
  game.play
end

game = Game.new
play(game)

"
NOTES

To do:
  3) Instantiation
  4) What happens after instantiation? Begin refactor with regular moves.

Remove Display concretion, push class names lower in stack.

You can get rid of the data clump ... board.grid[start_sq[0]][start_sq[1]]
by adding a method for board to accept an array and return that object.

Refactor: Board.board_squares and #board_squares is now board.spaces

For some reason, black cannot castle properly even though the code should be
relative, i.e. white and black castle code should be identical.

Is there an abstraction for castle? Much of the code seems repetitive.

Add serializing after king-check logic.j

Change notation from 0 to 1 when finished. Keep 0 for now, easier to read.

Display captured pieces to the right? Need up to 15 spaces.

At the end:
See how to add main and tests to replit

We need to test what, not how.

You must write edge cases for all of your tests.

Start testing asap. Use tests to repeatedly do the same thing.
Use Display::method
-> what is namespacing?

Other testing tools to use:
p/puts anywhere in test
let variables vs instance variables
set = variables like this
game = Game.new (and like this)
allow_any_instance_of
expect_any_instance_of
receive_message_chain(:method1, :method2, :method3).and_return('some_characters')
instance_variable_get
instance_variable_set
use mocks/stubs sparringly

Rememeber to include:
castling
cannot put yourself in check
check after moving a piece
double check
pawn promotion

draws:
stalemate because king has no legal moves, other pieces cannot move either
stalemate from insufficient material:
  King vs. king
  King and bishop vs. king
  King and knight vs. king
  King and bishop vs. king and bishop of the same color as the opponent's bishop
3 repititions, ask about this rule, not necessarily a draw (maybe ask in console after 3)
"

"Assignment
Build a command line Chess game where two players can play against each other.
The game should be properly constrained – it should prevent players from making 
illegal moves and declare check or check mate in the correct situations.
Make it so you can save the board at any time (remember how to serialize?)
Write tests for the important parts. You don’t need to TDD it (unless you want to),
but be sure to use RSpec tests for anything that you find yourself typing into
the command line repeatedly.
Do your best to keep your classes modular and clean and your methods doing only one
thing each.
This is the largest program that you’ve written, so you’ll definitely start to see
the benefits of good organization (and testing) when you start running into bugs.
Unfamiliar with Chess? Check out some of the additional resources to help you get
your bearings.
Have fun! Check out the unicode characters for a little spice for your gameboard.
(Optional extension) Build a very simple AI computer player (perhaps who does a
random legal move)
"
