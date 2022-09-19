# frozen_string_literal: true

require_relative '../lib/pawn'
require_relative '../lib/piece'
require_relative '../lib/board'

# require_relative '../lib/game'
# require_relative '../lib/player'
# require_relative '../lib/display'
# require_relative '../lib/piece_factory'
# require_relative '../lib/move'

describe Pawn do
  describe '#generate_path' do
    context 'when end_sq is a possible next move' do
      start_sq = [1, 0]
      end_sq = [2, 0]
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
      start_sq = [1, 0]
      end_sq = [7, 7]
      board_squares = Board.board_squares

      it 'returns an empty array' do
        result = subject.generate_path(start_sq, end_sq, board_squares)
        expect(result).to be_empty
      end
    end
  end
end

