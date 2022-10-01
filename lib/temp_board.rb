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

  def serialize_board
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

  def self.unserialize_board(string)
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

# Let's serialize an array with ONE pawn, then unserialize it
board = Board.new
puts "\nboard.grid\n "
p board.grid

serialized_grid = board.serialize_board
puts "\nserialized_grid\n "
p serialized_grid

dirname = 'saved_games'
Dir.mkdir(dirname) unless File.exist?(dirname)
File.open("#{dirname}/saved_game.json", 'w') { |f| f.write(serialized_grid) }

loaded_serialized_grid = ''
File.open("saved_games/saved_game.json", "r").each do |f|
  loaded_serialized_grid = f
end

loaded_board = Board.unserialize_board(loaded_serialized_grid)

puts "\nloaded_board\n "
p loaded_board


# we need to serialize game_list, then serialize board
# entire saved_game will be an ary, like this: [saved_move_list, saved_grid]
# first create this array with its serialized components
# then we unserialize it