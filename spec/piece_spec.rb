# frozen_string_literal: true

require_relative '../lib/piece'

# This is an abstract class
describe Piece do
  subject(:piece) { described_class.new(test: true) }

  before(:each) do
    allow_any_instance_of(Piece).to receive(:post_initialize)
  end

  describe '#invert' do
    context 'when move is [0, 2]' do
      it 'returns [0, -2]' do
        move = [0, 2]

        result = piece.invert(move)
        expect(result).to eq [0, -2]
      end
    end
  end

  describe '#make_path' do
    # Tested in individual game pieces
  end
  
  describe '#make_capture_path' do
    # Tested in individual game pieces
  end
end
