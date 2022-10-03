# frozen_string_literal: true

# require_relative 'serializable'
# Module class provides saving and loading games for chess
module SaveAndLoad
  # include Serializable

  def save_game_file
    puts "\n\t#{self.class}##{__method__}\n "
    # mechanics of game save go here.
    # serialize(move_list)
    # serialize(board)

    move_list.serialize
    # board.serializable
  end

  # def serialize
  #   # some method to serialize move_list

  #   move_list = ["Pd2d4", "Pa7a6", "Pd4d5", "Pe7e5"]
  #   serialized_move_list = serialize_list(move_list)
  #   serialized_grid = serialize_grid

  #   game_json = []
  #   game_json << serialized_move_list
  #   game_json << serialized_grid
  #   # game_json
  # end

end

return



















# unused stuff, delete later

def serialize_board
  obj = board.grid.map do |row|
    row.map do |square|
      if square.is_a?(String)
        square
      else
        square.serialize
      end
    end
  end

  p JSON.dump(obj)
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