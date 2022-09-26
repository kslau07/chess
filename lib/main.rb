# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative 'game'
require_relative 'board'
require_relative 'move'
require_relative 'special_moves/en_passant'
require_relative 'special_moves/castle'
require_relative 'special_moves/pawn_capture'
require_relative 'special_moves/pawn_double_step'
require_relative 'move_list'
require_relative 'player'
require_relative 'display'
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


