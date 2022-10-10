# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require 'pry-byebug'
require 'awesome_print'

require_relative 'game'
require_relative 'board'
require_relative 'board_layout'
require_relative 'move'
require_relative 'special_moves/en_passant'
require_relative 'special_moves/castle'
require_relative 'special_moves/pawn_attack'
require_relative 'special_moves/pawn_double_step'
require_relative 'move_list'
require_relative 'player'
require_relative 'display'
require_relative 'menuable'
require_relative 'save_and_load'
require_relative 'test_check'
require_relative 'serializable'
require_relative 'chess_tools'
require_relative 'piece_factory'
require_relative 'piece'
require_relative 'pieces/pawn'
require_relative 'pieces/rook'
require_relative 'pieces/queen'
require_relative 'pieces/king'
require_relative 'pieces/bishop'
require_relative 'pieces/knight'

def play(game)
  # NOTE: move scripting methods here once game is finished
  game.play
end

game = Game.new
play(game)