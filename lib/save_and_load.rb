# frozen_string_literal: true

# Module class provides saving and loading games for chess
module SaveAndLoad
  def save_game_file
    puts "\n\t#{self.class}##{__method__}\n "
    # mechanics of game save go here.
    serialize_board
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