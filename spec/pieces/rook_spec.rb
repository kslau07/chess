# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/rook'

describe Rook do
  let(:wht_rook) { described_class.new(color: 'white') }
  let(:blk_rook) { described_class.new(color: 'black') }

  describe '#to_s' do
    context 'when Rook is white' do
      it "returns \u2656" do
        result = wht_rook.to_s
        expect(result).to eq "\u2656"
      end
    end

    context 'when Rook is black' do
      it "returns \u265C" do
        result = blk_rook.to_s
        expect(result).to be "\u265C"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_rook.moved
      expect(wht_rook.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns rook\s move_set' do
      rook_move_set = [[1, 0], [0, 1], [-1, 0], [0, -1]]

      result = wht_rook.possible_moves
      expect(result).to eq rook_move_set
    end
  end
end
