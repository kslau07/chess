# frozen_string_literal: true

require_relative 'piece'
require_relative 'pieces/pawn'

require 'json'

# This is the chess board
class Board
  attr_reader :grid

  def initialize
    generate_board
  end

  def object(coord)
    grid[coord[0]][coord[1]] unless coord.nil?
  end

  def squares
    arr_of_squares = []
    8.times do |x|
      8.times do |y|
        arr_of_squares << [x, y]
      end
    end
    arr_of_squares
  end

  def generate_board
    @grid = []

    8.times do
      @grid.push Array.new(8, 'unoccupied')
    end
  end

  def update_square(coord, new_value)
    grid[coord[0]][coord[1]] = new_value
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

