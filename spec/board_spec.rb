# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }



  describe '#squares' do
    it 'returns an array containing 64 elements' do
      board.squares
    end
  end
end
