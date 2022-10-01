# frozen_string_literal: true

# require_relative 'piece'
# require_relative 'pieces/pawn'

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
    
    # @grid << ['unoccupied']

    # @grid.push [TempRook.new, TempBishop.new, TempBishop.new]
    @grid.push Array.new(3, TempPawn.new)
    @grid.push Array.new(3, 'unoccupied')

    # 2.times do
    #   @grid.push Array.new(3, 'unoccupied')
    # end



  end

  def serialize_board
    # obj = @grid.map(&:serialize)
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
    puts "\n\t#{self.class}##{__method__}\n "

    obj = JSON.parse(string)

    # p obj

    obj.map do |row|
      row.map do |elem|
        # JSON.parse(elem)
        if elem == 'unoccupied'
          elem
        else
          JSON.parse(elem)
        end
      end
    end
  end

  # Who should be in charge of serialzing the board, unserializing the board
  # and unserializing instances? (instantiating + setting instance variables)
  # Maybe create new class: SaveLoadGame
  # Maybe create a module to be used in Game?
  def self.unserialize_instance(obj)
    puts "\n\t#{self.class}##{__method__}\n "

    return 'Piece instance'

    class_name = obj['@class']
    piece = Object.const_get(class_name).new
    obj.keys.each do |key|
      piece.instance_variable_set(key, obj[key])
    end
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
