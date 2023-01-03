# chess

This project spec is at  
[Odin Ruby Final Project](https://www.theodinproject.com/lessons/ruby-ruby-final-project)

## Description

The final project in Odin's Ruby curriculum is to create a CLI-based chess game. The second player can be an optionally computer opponent.

##  Play This App Online

> [Link to replit](https://replit.com/@kslau/chess#README.md)  

You may play this on replit.com without having to install Ruby on your computer.  
  * Click the replit link above
  * Press the **green run** button at the top of the screen

## Testing

Following what Sandi Metz teaches, I will be testing only the following methods: incoming command methods, incoming query methods, and outgoing command methods. To that list, I will also add methods that Odin calls _looping script methods_. These are methods that loop other methods, and the condition to break out of the loop will be tested.

## Patterns Used

* Self-Registering Factory - used for selecting a piece class for individual moves
* Template Method - used to subclass Piece

## Reflections After Chess

It is obvious to me why this was chosen as the final project for Ruby. There are multiple skills one has to juggle in order for the pieces to come together at the end.

I began by writing my code alongside my tests. I abandoned that practice when my classes and methods were changing too often at the beginning- breaking tests constantly. So I decided to write my tests _after_ finishing the project. That was a huge mistake. My classes and methods were not kept in check by my tests and I learned the hard way how difficult it is to refactor without tests at your back. I don't think I will ever wait to write my tests again. 

_After all is said and I now feel:_  
1. I am much more confident creating classes.
2. I have a more systematic approach to refactoring.
3. Tests are worth every ounce of effort they take to write.

## Project Specs

* Build a command line Chess game where two players can play against each other.

* The game should be properly constrained – it should prevent players from making illegal moves and declare check or check mate in the correct situations.

* Make it so you can save the board at any time (remember how to serialize?)

* Write tests for the important parts. You don’t need to TDD it (unless you want to),
but be sure to use RSpec tests for anything that you find yourself typing into
the command line repeatedly.

* Do your best to keep your classes modular and clean and your methods doing only one
thing each.

* This is the largest program that you’ve written, so you’ll definitely start to see the benefits of good organization (and testing) when you start running into bugs.

* Unfamiliar with Chess? Check out some of the additional resources to help you get your bearings.

* Have fun! Check out the unicode characters for a little spice for your gameboard.

* (Optional extension) Build a very simple AI computer player (perhaps who does a
random legal move)