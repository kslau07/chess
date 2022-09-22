# frozen_string_literal: true

require_relative '../lib/bishop'
require_relative '../lib/piece'
require_relative '../lib/board'

describe Bishop do
  describe '#path_one' do
    context 'when end_sq is a possible next move' do
      start_sq = [2, 3]
      end_sq = [6, 7] # in path

      it 'returns an array' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to be_kind_of(Array)
      end

      it 'returns an array(path) that includes end_sq' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to include(end_sq)
      end
    end

    context 'when end_sq is impossible to reach in next move' do
      start_sq = [2, 3]
      end_sq = [3, 3] # not in path, 1 step forward

      it 'returns an empty array' do
        result = subject.generate_path(start_sq, end_sq)
        expect(result).to be_empty
      end
    end
  end
end
