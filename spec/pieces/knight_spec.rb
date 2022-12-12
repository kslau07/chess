# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/knight'

describe Knight do
  let(:wht_knight) { described_class.new(color: 'white') }
  let(:blk_knight) { described_class.new(color: 'black') }

  describe '#to_s' do
    context 'when Knight is white' do
      it "returns \u2658" do
        result = wht_knight.to_s
        expect(result).to eq "\u2658"
      end
    end

    context 'when Knight is black' do
      it "returns \u265E" do
        result = blk_knight.to_s
        expect(result).to be "\u265E"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_knight.moved
      expect(wht_knight.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns knight\s move_set' do
      knight_move_set = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2],
                         [1, -2], [2, -1]]

      result = wht_knight.possible_moves
      expect(result).to eq knight_move_set
    end
  end
end
