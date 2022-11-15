# https://www.theodinproject.com/lessons/ruby-ruby-final-project
# frozen_string_literal: true

require_relative './lib/library'

# require 'pry-byebug'
# require 'awesome_print'

# def play(game)
  # NOTE: move scripting methods here once game is finished
  # game.play
# end

# main.rb can/should be the entry point for dependencies
# 

game = Game.new(board_config: 'pawn_promotion')
game.play
