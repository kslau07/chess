# frozen_string_literal: true

require_relative '../lib/bishop'
require_relative '../lib/piece'
require_relative '../lib/board'

# require_relative '../lib/pawn'
# require_relative '../lib/game'
# require_relative '../lib/player'
# require_relative '../lib/display'
# require_relative '../lib/piece_factory'
# require_relative '../lib/move'

describe Bishop do
  describe '#path_one' do
    context 'when end_sq is a possible next move' do
      start_sq = [2, 3]
      end_sq = [3, 3] # not in path, 1 step forward
      end_sq = [3, 4] # in path
      board_squares = Board.board_squares

      it 'returns an array' do
        result = subject.generate_path(start_sq, end_sq, board_squares)
        expect(result).to be_kind_of(Array)
      end

      it 'returns an array(path) that contains end_sq' do
        result = subject.generate_path(start_sq, end_sq, board_squares)
        expect(result).to include(end_sq)
      end
    end

    context 'when end_sq is impossible to reach in next move' do
      start_sq = [2, 3]
      end_sq = [3, 3] # not in path, 1 step forward
      board_squares = Board.board_squares

      it 'returns an empty array' do
        result = subject.generate_path(start_sq, end_sq, board_squares)
        expect(result).to be_empty
      end
    end
  end
end

