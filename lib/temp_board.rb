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
    
    @grid.push [TempRook.new, TempBishop.new, TempBishop.new]
    @grid.push Array.new(3, TempPawn.new)
    @grid.push Array.new(3, 'unoccupied')
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
      row.map do |elem|
        # JSON.parse(elem)
        if elem == 'unoccupied'
          elem
        else
          unserialize_instance(elem)
        end
      end
    end
  end

  # Who should be in charge of serialzing the board, unserializing the board
  # and unserializing instances? (instantiating + setting instance variables)
  # Maybe create new class: SaveLoadGame
  # Maybe create a module to be used in Game?
  def self.unserialize_instance(string)
    obj = JSON.parse(string)
    class_name = obj['@class_name']
    piece = Object.const_get(class_name).new

    obj.keys.each do |key|
      piece.instance_variable_set(key, obj[key])
    end

    piece
  end
end

class TempPawn
  include Serializable

  def initialize(color = 'white')
    @class_name = self.class
    @color = color
  end
end

class TempRook
  include Serializable
  
  def initialize(color = 'white')
    @class_name = self.class
    @color = color
  end
end

class TempBishop
  include Serializable

  def initialize(color = 'white')
    @class_name = self.class
    @color = color
  end
end

class TempKnight
  include Serializable

  def initialize(color = 'white')
    @class_name = self.class
    @color = color
  end
end

# Let's serialize an array with ONE pawn, then unserialize it
board = Board.new
puts "\nboard.grid\n "
p board.grid

serialized_board = board.serialize_board
puts "\nserialized_board\n "
p serialized_board

loaded_board = Board.unserialize_board(serialized_board)

puts "\nloaded_board\n "
p loaded_board
