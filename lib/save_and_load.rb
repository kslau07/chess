# frozen_string_literal: true

# require_relative 'serializable'
# Module class provides saving and loading games for chess
module SaveAndLoad
  # include Serializable

  def save_game_file
    puts "\n\t#{self.class}##{__method__}\n "
    json_obj_ary = serialize_game_objects
    save_to_file(json_obj_ary)
  end

  def serialize_game_objects
    move_list_json = move_list.serialize # not 100% sure we have jsonified correctly
    board_json = board.serialize
    [move_list_json, board_json]
  end

  def save_to_file(json_obj_ary)
    time = Time.new
    time_str = time.strftime('%Y%b%d_%I%M%p').downcase
    dirname = 'saved_games'
    Dir.mkdir(dirname) unless File.exist?(dirname)
    File.open("#{dirname}/#{time_str}.json", 'w') do |f|
      json_obj_ary.each { |json_obj| f.puts(json_obj) }
    end

    # File.open("#{dirname}/#{time_str}.json", 'w') do |f| # 2nd way to write lines
    #   f.puts(json_obj_ary)
    # end
  end

  def load_game_file
    # show list of most recent 5 saves
    # user inputs num 1-5 to load a game file
    json_obj_ary = read_file
    load_move_list(json_obj_ary[0])
    load_board(json_obj_ary[1])
  end

  def load_move_list(json_str)
    obj = JSON.parse(json_str)
    JSON.parse(obj) # strangely we have to parse twice
  end

  def load_board(json_str)
    # puts __method__
    # return
    obj = JSON.parse(json_str)

    obj.map do |row|
      row.map do |string|
        if string == 'unoccupied'
          string
        else
          obj2 = JSON.parse(string)
          instantiate_board_piece(obj2)
        end
      end
    end
  end

  def instantiate_board_piece(obj)
    class_name = obj['@class_name']
    obj = Object.const_get(class_name).new
  
    obj.keys.each do |key|
      piece.instance_variable_set(key, obj[key])
    end
  
    piece
  end

  # Allow user to load any of most recent 5 saved games
  def read_file
    a_file = ''
    Dir.glob('saved_games/**').each do |fname|
      a_file = fname.split('/').last
    end

    p a_file

    file = File.open("saved_games/#{a_file}", 'r')
    json_obj_ary = []
    until file.eof?
      line = file.readline
      json_obj_ary.push line
    end

    json_obj_ary
  end
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

def self.load_board(string)
  obj = JSON.parse(string)

  obj.map do |row|
    row.map do |string|
      if string == 'unoccupied'
        string
      else
        obj = JSON.parse(string)
        instantiate_board_piece(obj)
      end
    end
  end
end

# Who should be in charge of serialzing the board, unserializing the board
# and unserializing instances? (instantiating + setting instance variables)
# Maybe create new class: SaveLoadGame
# Maybe create a module to be used in Game?
def self.instantiate_board_piece(obj)
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

loaded_json = ''
File.open("saved_games/saved_game.json", "r").each do |f|
  loaded_json = f
end

# p json_string

unserialized_grid = Board.load_board(loaded_json)

loaded_board = game.board.instance_variable_set(:@grid, unserialized_grid)


Display.draw_board(game.board)



# saved_games_path = File.dirname(__FILE__) + '/../saved_games/**'
# fnames = Dir.glob(saved_games_path)
# fnames.each do |fname|
#   a_file = fname.split('/').last
# end