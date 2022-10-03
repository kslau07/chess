# frozen_string_literal: true

# require_relative 'serializable'
# Module class provides saving and loading games for chess
module SaveAndLoad
  # include Serializable

  def save_game_file
    puts "\n\t#{self.class}##{__method__}\n "

    move_list_json = move_list.serialize # not 100% sure we have jsonified correctly
    board_json = board.serialize
    game_ary = [move_list_json, board_json]
    game_json = jsonify(game_ary)
    save_to_file(game_json)

    # what's next?
    # save to folder as new file
    # save date and time in files
  end

  def jsonify(obj)
    JSON.dump(obj)
  end

  def save_to_file(json_str)
    time = Time.new
    time_str = time.strftime('%Y%b%d_%I%M%p').downcase
    dirname = 'saved_games'
    Dir.mkdir(dirname) unless File.exist?(dirname)
    File.open("#{dirname}/#{time_str}.json", 'w') { |f| f.write(json_str) }
  end

  def load_file(json_file)
    # show list of most recent 5 saves
    # user inputs num 1-5 to load a game file
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


# p game.board

p game.board.grid

serialized_grid = game.board.serialize_board

dirname = 'saved_games'
Dir.mkdir(dirname) unless File.exist?(dirname)
File.open("#{dirname}/saved_game.json", 'w') { |f| f.write(serialized_grid) }

loaded_serialized_grid = ''
File.open("saved_games/saved_game.json", "r").each do |f|
  loaded_serialized_grid = f
end

# p json_string

unserialized_grid = Board.unserialize_board(loaded_serialized_grid)

loaded_board = game.board.instance_variable_set(:@grid, unserialized_grid)


Display.draw_board(game.board)


