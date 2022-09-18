# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'player'
require_relative 'display'
require_relative 'piece_factory'
require_relative 'piece'
require_relative 'pawn'
require_relative 'move'

def play(game)
  # NOTE: move scripting methods here once game is finished
  game.play
end

game = Game.new
play(game)

"
NOTES

Change 'unoccupied' back to nil

Keep a move list, at least 6 deep. Maybe make a list of all moves.
Use class.name or get name for notation.
Or, add @name to classes. (probably this one, but try other first)

Make one pawn block the other.
Make predefined_moves and capture_path_rename different for pawns, same for all other pieces.
If capture and move do not match, do not capture. Illegal move.


Who is responsible for creating game piece objects?

row legend: A, B, C, D, E, F, G, H
column legend: 8, 7, 6, 5, 4, 3, 2, 1 (top to bottom)

white chess king	♔	U+2654	&#9812;	&#x2654;
white chess queen	♕	U+2655	&#9813;	&#x2655;
white chess rook	♖	U+2656	&#9814;	&#x2656;
white chess bishop	♗	U+2657	&#9815;	&#x2657;
white chess knight	♘	U+2658	&#9816;	&#x2658;
white chess pawn	♙	U+2659	&#9817;	&#x2659;
black chess king	♚	U+265A	&#9818;	&#x265A;
black chess queen	♛	U+265B	&#9819;	&#x265B;
black chess rook	♜	U+265C	&#9820;	&#x265C;
black chess bishop	♝	U+265D	&#9821;	&#x265D;
black chess knight	♞	U+265E	&#9822;	&#x265E;
black chess pawn	♟	U+265F	&#9823;	&#x265F;


Add serializing ASAP, after pawn works.

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
en passant (must execute when available or lose it)
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
The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.
Make it so you can save the board at any time (remember how to serialize?)
Write tests for the important parts. You don’t need to TDD it (unless you want to), but be sure to use RSpec tests for anything that you find yourself typing into the command line repeatedly.
Do your best to keep your classes modular and clean and your methods doing only one thing each. This is the largest program that you’ve written, so you’ll definitely start to see the benefits of good organization (and testing) when you start running into bugs.
Unfamiliar with Chess? Check out some of the additional resources to help you get your bearings.
Have fun! Check out the unicode characters for a little spice for your gameboard.
(Optional extension) Build a very simple AI computer player (perhaps who does a random legal move)
"
