# frozen_string_literal: true

require_relative 'piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/bishop'

require 'json'
require_relative 'serializable'

# This is the chess board
class Board
  # include Serializable
  attr_reader :grid

  def initialize
    generate_board
  end

  def generate_board
    @grid = []
    
    @grid.push [Rook.new, Bishop.new]
    # @grid.push Array.new(3, Pawn.new)
    @grid.push Array.new(2, 'unoccupied')
  end

  def serialize_list_and_grid
    # some method to serialize move_list

    move_list = ["Pd2d4", "Pa7a6", "Pd4d5", "Pe7e5"]
    serialized_move_list = serialize_list(move_list)
    serialized_grid = serialize_grid

    game_json = []
    game_json << serialized_move_list
    game_json << serialized_grid
    # game_json
  end

  def unserialize_list_and_grid(list_and_grid_ary)
    serialized_list = list_and_grid_ary[0]
    serialized_grid = list_and_grid_ary[1]

    puts "\nserialized_list"
    p serialized_list

    puts "\nserialize_grid"
    p serialized_grid

    # to load move_list, instantiate new MoveList, you have to pass along
    # (2) and use a conditional, 1 -> new list + new variables, 2 -> new list and load instance variables
    # then for load move_list, use instance_variable_set @all_moves

    # to load grid, instantiate new Board, pass along 1/2, use conditional
    # to either create new list + new variables, or new list + load saved variables

    # We've gone as far as we can go with this class, we now need to implement
    # real methods in Game, MoveList and Board.

    # Begin with creating the in game menu -> Type 'menu' to see options
    # In the menu, first create save game option
    # You will then use our dummy methods to create a real save file
    # You may try reducing the size of the game board for this part
    # After we can save a file we then work on load file
    # First start with loading from beginning, then later implement load 
    # in the middle of a game.
  end

  def serialize_list(move_list)
    JSON.dump move_list
  end

  def serialize_grid
    obj = @grid.map do |row|
      row.map do |square|
        if square.is_a?(String)
          square
        else
          square.serialize
        end
      end
    end

    JSON.dump(obj)
  end

  def self.unserialize_grid(string)
    obj = JSON.parse(string)

    obj.map do |row|
      row.map do |string|
        if string == 'unoccupied'
          string
        else
          obj = JSON.parse(string)
          instantiate_board_obj(obj)
        end
      end
    end
  end

  # Who should be in charge of serialzing the board, unserializing the board
  # and unserializing instances? (instantiating + setting instance variables)
  # Maybe create new class: SaveLoadGame
  # Maybe create a module to be used in Game?
  def self.instantiate_board_obj(obj)
    class_name = obj['@class_name']
    piece = Object.const_get(class_name).new

    obj.keys.each do |key|
      piece.instance_variable_set(key, obj[key])
    end

    piece
  end
end

# # Let's serialize an array with ONE pawn, then unserialize it
# board = Board.new
# puts "\nboard.grid\n "
# p board.grid

# serialized_grid = board.serialize_grid
# puts "\nserialized_grid\n "
# p serialized_grid

# dirname = 'saved_games'
# Dir.mkdir(dirname) unless File.exist?(dirname)
# File.open("#{dirname}/saved_game.json", 'w') { |f| f.write(serialized_grid) }

# loaded_serialized_grid = ''
# File.open("saved_games/saved_game.json", "r").each do |f|
#   loaded_serialized_grid = f
# end

# loaded_board = Board.unserialize_grid(loaded_serialized_grid)

# puts "\nloaded_board\n "
# p loaded_board


# we need to serialize game_list, then serialize board
# entire saved_game will be an ary, like this: [saved_move_list, saved_grid]
# first create this array with its serialized components
# then we unserialize it

board = Board.new
list_and_grid_ary = board.serialize_list_and_grid
board.unserialize_list_and_grid(list_and_grid_ary)
