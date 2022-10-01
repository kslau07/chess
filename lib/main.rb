# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'move'
require_relative 'special_moves/en_passant'
require_relative 'special_moves/castle'
require_relative 'special_moves/pawn_attack'
require_relative 'special_moves/pawn_double_step'
require_relative 'move_list'
require_relative 'player'
require_relative 'display'
require_relative 'chess_tools'
require_relative 'piece_factory'
require_relative 'piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'

require_relative 'temp_layout' # delete temp class

def play(game)
  # NOTE: move scripting methods here once game is finished
  game.play
end

game = Game.new

play(game)

return

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




