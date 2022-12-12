# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/king'

describe King do
  let(:wht_king) { described_class.new(color: 'white') }
  let(:blk_king) { described_class.new(color: 'black') }

  describe '#to_s' do
    context 'when King is white' do
      it "returns \u2654" do
        result = wht_king.to_s
        expect(result).to eq "\u2654"
      end
    end

    context 'when King is black' do
      it "returns \u265A" do
        result = blk_king.to_s
        expect(result).to be "\u265A"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_king.moved
      expect(wht_king.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns king\s move_set' do
      king_move_set = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1],
                       [0, -1], [1, -1]]

      result = wht_king.possible_moves
      expect(result).to eq king_move_set
    end
  end
end
