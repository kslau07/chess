# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/piece'
require_relative '../lib/board'

describe Pawn do
  describe '#generate_path' do
    context 'when pawn moves one space on the first move' do
      start_sq = [1, 0]
      end_sq = [2, 0]

      it 'returns an array' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to be_kind_of(Array)
      end

      it 'returns an array(path) that includes end_sq' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to include(end_sq)
      end
    end

    context 'when pawn moves two spaces on the first move' do
      start_sq = [1, 0]
      end_sq = [3, 0]

      it 'returns an array that includes end_sq' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to include(end_sq)
      end
    end

    context 'when end_sq is impossible to reach in next move' do
      start_sq = [1, 0]
      end_sq = [7, 7]

      it 'returns an empty array' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to be_empty
      end
    end
  end
end

