# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/queen'

describe Queen do
  let(:wht_queen) { described_class.new(color: 'white') }
  let(:blk_queen) { described_class.new(color: 'black') }

  describe '#to_s' do
    context 'when Queen is white' do
      it "returns \u2655" do
        result = wht_queen.to_s
        expect(result).to eq "\u2655"
      end
    end

    context 'when Queen is black' do
      it "returns \u265B" do
        result = blk_queen.to_s
        expect(result).to be "\u265B"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_queen.moved
      expect(wht_queen.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns queen\s move_set' do
      queen_move_set = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1],
                        [0, -1], [1, -1]]

      result = wht_queen.possible_moves
      expect(result).to eq queen_move_set
    end
  end
end
