# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/bishop'
require_relative '../lib/knight'
require_relative '../lib/rook'
require_relative '../lib/queen'
require_relative '../lib/king'
require_relative '../lib/move'

describe Move do
  subject(:move) { described_class.new }

  # perhaps move to example block
  before(:each) do
    allow_any_instance_of(Move).to receive(:move_sequence)
  end

  describe '#move_valid?' do
    context 'when "en passant" is possible and player executes this move' do
      before do
        move.board.grid[4][3] = Pawn.new(color: 'white')
        move.board.grid[4][4] = Pawn.new(color: 'black')
        # move.board.grid[5][7] = 'unoccupied'
        move.instance_variable_set(:@start_sq, [4, 3])
        move.instance_variable_set(:@end_sq, [5, 4])
      end

      
      it 'returns true' do
        Display.draw_board(subject.board)
        result = subject.move_valid?
        expect(result).to eq(true)
      end
    end
  end
end

