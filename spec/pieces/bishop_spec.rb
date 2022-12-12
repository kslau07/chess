# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/bishop'

describe Bishop do
  let(:wht_bishop) { described_class.new(color: 'white') }
  let(:blk_bishop) { described_class.new(color: 'black') }

  describe '#to_s' do
    context 'when Bishop is white' do
      it "returns \u2657" do
        result = wht_bishop.to_s
        expect(result).to eq "\u2657"
      end
    end

    context 'when Bishop is black' do
      it "returns \u265D" do
        result = blk_bishop.to_s
        expect(result).to be "\u265D"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_bishop.moved
      expect(wht_bishop.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns bishop\s move_set' do
      bishop_move_set =  [[1, -1], [1, 1], [-1, -1], [-1, 1]]

      result = wht_bishop.possible_moves
      expect(result).to eq bishop_move_set
    end
  end

  
end
