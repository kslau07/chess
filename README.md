# chess

This project spec is at
https://www.theodinproject.com/lessons/ruby-ruby-final-project

### Description

The final project in Odin's Ruby curriculum is to create a CLI-based chess game.

###  Play This App Online
You may play this on replit.com without having to install Ruby on your computer.
https://replit.com/@kslau/chess#README.md

### My Notes

11/7/22 - I am about halfway done with this project. It is time to refactor and to write the RSpec tests. I finished
the logic of most of the chess moves in about 2.5 weeks. No other project in the Ruby curriculum comes even close to 
the size and scope of this project. I did not expect chess would require ~25 classes (and counting). At this point
I am no longer hesitant to create new classes, nor to break up a larger class into 2 or 3 more focused ones.
The most difficult part so far has been to write the logic for all of the pawn's tricky moves (every single pawn
move was tricky for me). The pawn's attack move, en passant, pawn promotion, and including its normal move were all
unique.

### Testing

Following what Sandi Metz teaches, I will be testing only the following methods: incoming command methods, incoming
query methods, and outgoing command methods. To that list I will also add methods that Odin calls looping script
methods. These are methods that loop other methods, and the condition to break out of the loop will be tested.
