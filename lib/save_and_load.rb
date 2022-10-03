# frozen_string_literal: true

# Module class provides saving and loading games for chess
module SaveAndLoad

  def save_game_file
    # puts "\n\t#{self.class}##{__method__}\n "
    json_obj_ary = serialize_game_objects
    save_to_file(json_obj_ary)
  end

  def load_game_file
    # show list of most recent 5 saves
    # user inputs num 1-5 to load a game file
    file_list = show_saved_games
    fname = choose_file(file_list)
    return if fname.nil?

    json_obj_ary = read_file(fname)
    load_move_list(json_obj_ary[0])
    load_board(json_obj_ary[1])
  end

  private

  def show_saved_games
    puts 'Choose a saved game to load:'.magenta
    Dir.glob('saved_games/**').map.with_index do |fname, index|
      break if index >= 5

      puts "#{index + 1}. #{fname.split('/').last.split('.').first}"
      fname.split('/').last.split('.').first
    end
  end

  def choose_file(f_list)
    puts 'No saved games found.' if f_list.empty?
    input = gets unless f_list.empty?
    f_list[input.to_i - 1]
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

  def load_move_list(json_str)
    obj = JSON.parse(json_str)
    a_move_list = JSON.parse(obj) # strangely we have to parse twice
    move_list.instance_variable_set(:@all_moves, a_move_list) # perhaps create a method within MoveList
  end

  def load_board(json_str)
    # puts __method__
    # return
    grid_obj = JSON.parse(json_str)

    loaded_grid = grid_obj.map do |row|
      row.map do |string|
        if string == 'unoccupied'
          string
        else
          piece_hash = JSON.parse(string)
          instantiate_board_piece(piece_hash)
        end
      end
    end

    board.instance_variable_set(:@grid, loaded_grid) # perhaps create method in Board (i.e. Board#load_grid)
    puts 'Game file has been loaded!'
  end

  def instantiate_board_piece(piece_hash)
    class_name = piece_hash['@class_name']
    piece = Object.const_get(class_name).new

    piece_hash.each_key do |key|
      piece.instance_variable_set(key, piece_hash[key])
    end

    piece
  end

  def read_file(fname)
    fname += '.json'
    file = File.open("saved_games/#{fname}", 'r')
    json_obj_ary = []
    until file.eof?
      line = file.readline
      json_obj_ary.push line
    end

    json_obj_ary
  end
end
