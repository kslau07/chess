# frozen_string_literal: true

require_relative '../lib/chess'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'

describe Chess do
  xit '' do
    allow(subject).to receive(:gets).and_return '10', '20'
    subject.play
  end
end

describe Chess do
  describe '#initialize' do
    # Not tested
  end

  describe '#play' do
    # Script method, not tested
    # Only query and command methods are tested
  end

  describe '#turn_loop' do
    # Script method
  end

  describe '#transfer_piece' do
    # Command method
    # test
  end

  describe '#input_move' do
  # Command and Query
  # test
  end

  describe '#board_object' do
    # Query
  end

  describe '#valid' do

  end

  # A query method expects a return value
  # A command method expects to set a value
end