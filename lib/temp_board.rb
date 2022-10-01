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

    @grid.push 'unoccupied'
    new_pawn = TempPawn.new
    new_pawn.instance_variable_set(:@color, 'green')
    @grid.push new_pawn

    # 2.times do
    #   @grid.push Array.new(2, 'unoccupied')
    # end
  end

  def serialize_board
    # obj = @grid.map(&:serialize)
    obj = @grid.map do |square|
      if square.is_a?(String)
        square
      else
        square.serialize
      end
    end

    JSON.dump(obj)
  end

  def self.unserialize_board(string)
    obj = JSON.parse(string)
    whole_board = []
    obj.each do |obj_str|
      next if obj_str == 'unoccupied'

      unserialize_instance(obj_str)
    end
  end

  def self.unserialize_instance(string)
    p 'self.unserialize_instance'

    obj = JSON.parse(string)

    class_name = obj['@class']
    piece = Object.const_get(class_name).new
    obj.keys.each do |key|
      piece.instance_variable_set(key, obj[key])
    end
  end

  # def to_json
  #   JSON.dump ({
  #     grid: @grid
  #   })
  # end

  # def self.from_json(string)
  #   data = JSON.load string # this is a hash, you access info like this: data['grid']
  #   board_inst = self.new
  #   board_inst.instance_variable_set(:@grid, data['grid'])
  #   board_inst
  # end
end

class TempPawn
  include Serializable
  
  def initialize(color = 'white')
    @class = self.class
    @color = color
  end
end

class TempBishop
  # include Serializable

  def initialize(color = 'white')
    @color = color
  end
end

# Let's serialize an array with ONE pawn, then unserialize it
board = Board.new
serialized_board = board.serialize_board
# p serialized_board

loaded_board = Board.unserialize_board(serialized_board)

p loaded_board
# pawn = TempPawn.new
# p pawn
