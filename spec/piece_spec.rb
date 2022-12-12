# frozen_string_literal: true

require_relative '../lib/piece'

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

  # We should consider using real objects for this next method
  # We can show all that pieces can create paths when start/end are good
  # and when start/end are bad, path should be empty.

  describe '#make_path' do
    let(:board) { instance_double('Board') }

  context 'when start square is [1, 4]' do
    xit '' do
      result = class_instance.method_call
      expect(result).to be 'abcd'
    end
  end
  end

  describe '#make_capture_path' do
    # Only calls self, no testing required
  end
end
