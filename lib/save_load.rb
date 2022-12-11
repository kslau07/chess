# frozen_string_literal: true

# Module class provides saving and loading games for chess
module SaveLoad
  def save_game_file
    json_obj_ary = serialize_game_objects
    save_to_file(json_obj_ary)
  end

  # show list of most recent 5 saves
  # user inputs num 1-5 to load a game file
  def load_game_file(board, move_list)
    file_list = show_saved_games
    fname = choose_file(file_list)
    return if fname.nil?

    json_obj_ary = read_file(fname)
    load_move_list(json_obj_ary[0], move_list) # move list object
    load_board(json_obj_ary[1], board) # perhaps we could load board after Game is instantiated
    puts 'The save file has been loaded!'
    [board, move_list]
  end

  def show_saved_games
    puts 'Choose a saved game to load:'.magenta # re-enable
    Dir.glob('saved_games/**').map.with_index do |fname, index|
      break if index >= 5

      puts "#{index + 1}. #{fname.split('/').last.split('.').first}"
      fname.split('/').last.split('.').first
    end
  end

  def choose_file(f_list)
    puts 'No saved games found.' if f_list.empty?
    input = validate_choose_file_input(f_list) unless f_list.empty?
    f_list[input.to_i - 1]
  end

  def validate_choose_file_input(f_list)
    list_len = f_list.length
    valid_inputs = (1..list_len).to_a.map(&:to_s)
    loop do
      input = gets.chomp
      return input if valid_inputs.include?(input)

      puts 'Invalid input! Choose a file to load.'
    end
  end

  def serialize_game_objects
    move_list_json = move_list.serialize
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

  def load_move_list(mv_list_json_str, move_list)
    obj = JSON.parse(mv_list_json_str)
    parsed_move_list = JSON.parse(obj) # strangely we have to parse twice
    move_list.set(parsed_move_list) # perhaps create a method within MoveList
  end

  # def revert_board(grid_json)
  #   load_board(grid_json)
  # end

  def load_board(json_str, board)
    grid_obj = JSON.parse(json_str)

    parsed_grid_obj = grid_obj.map do |row|
      row.map do |string|
        if string == 'unoccupied'
          string
        else
          piece_hash = JSON.parse(string)
          instantiate_board_piece(piece_hash)
        end
      end
    end

    board.load_grid(parsed_grid_obj)
  end

  # alias_method :revert_board, :load_board(json_str)
  alias revert_board load_board

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
