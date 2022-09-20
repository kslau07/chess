# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/move'

describe Game do
  xit '' do
    allow(subject).to receive(:gets).and_return '10', '20'
    subject.play
  end
end

describe Game do
  subject(:game) { Game.new }

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
