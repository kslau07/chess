# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true


require_relative 'chess'

game = Chess.new

def play(game)
  # game.greeting
  # game.choose_color
  # game.draw_board
  # game.turn_loop until game.game_over?
end

play(game)

"
NOTES

We need to test what, not how.

You must write edge cases for all of your tests.

Start testing asap. Use tests to repeatedly do the same thing.
Use Display::method
-> what is namespacing?


Other testing tools to use:
p/puts anywhere in test
let variables
set = variables like this
game = Game.new (and like this)
allow_any_instance_of
expect_any_instance_of
receive_message_chain(:method1, :method2, :method3).and_return('some_characters')
instance_variable_get
instance_variable_set
use mocks/stubs sparringly
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
