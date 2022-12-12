# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/bishop'

describe Bishop do
  let(:wht_bishop) { described_class.new(color: 'white') }
  let(:blk_bishop) { described_class.new(color: 'black') }
  let(:board) { instance_double('board', squares: board_squares) }

  # method from class Board for Board double
  def board_squares
    arr_of_squares = []
    8.times do |x|
      8.times do |y|
        arr_of_squares << [x, y]
      end
    end
    arr_of_squares
  end

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

  # superclass method
  describe '#make_path' do
    context 'for white Bishop' do
      context 'when start_sq is [2, 3]' do
        start_sq = [2, 3]

        context 'when Bishop moves diagonally' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [6, 7]

            result = wht_bishop.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 3], [3, 4], [4, 5], [5, 6], [6, 7]]
          end

          it 'returns a path (Array) that is not empty' do
            end_sq = [0, 1]

            result = wht_bishop.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 3], [1, 2], [0, 1]]
          end
        end

        context 'when Bishop tries to move sideways' do
          it 'returns an empty Array' do
            end_sq = [2, 7]

            result = wht_bishop.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when Bishop tries to move vertically' do
          it 'returns an empty Array' do
            end_sq = [6, 3]

            result = wht_bishop.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end
