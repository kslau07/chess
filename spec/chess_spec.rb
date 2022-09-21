# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/move'
require_relative '../lib/move_list'
require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/rook'
require_relative '../lib/queen'
require_relative '../lib/king'
require_relative '../lib/bishop'
require_relative '../lib/knight'


describe Game do
  subject(:game) { Game.new }

  it 'tests #move_list' do
    # remember to change Game#play >>> x.times { turn_loop }

    # # 4 moves (2 complete sets)
    # allow_any_instance_of(Move).to receive(:gets).and_return(
    #   '17', '37', '64', '44', '06', '27', '75', '20')
    
    # 5 moves (2 complete)
    allow_any_instance_of(Move).to receive(:gets).and_return(
        '17', '37', '64', '44', '06', '27', '75', '20', '11', '20')

    subject.play
  end

  describe '#initialize' do
    # Not tested
    it '' do
      # p ['game: ', subject.class]
    end
  end

  describe '#play' do
    # Script method, not tested
    # Only query and command methods are tested
  end
  
  # Script method
  describe '#turn_loop' do
  end

  # A query method expects a return value
  # A command method expects to set a value
end
