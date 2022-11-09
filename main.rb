# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative './lib/library'

# require 'pry-byebug'
# require 'awesome_print'

def play(game)
  # NOTE: move scripting methods here once game is finished
  game.play
end

game = Game.new
game.play
# p game.current_player
# play(game)
