# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/king'

describe King do
  let(:wht_king) { described_class.new(color: 'white') }
  let(:blk_king) { described_class.new(color: 'black') }
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

  # superclass method
  describe '#make_path' do
    context 'for white King' do
      context 'when start_sq is [2, 2]' do
        start_sq = [2, 2]

        context 'when King moves diagonally 1 space' do
          it 'returns an Array that is not empty' do
            end_sq = [3, 3]

            result = wht_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 2], [3, 3]]
          end

          it 'returns an Array that is not empty' do
            end_sq = [3, 1]

            result = wht_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 2], [3, 1]]
          end
        end

        context 'when King moves sideways 1 space' do
          it 'returns an Array that is not empty' do
            end_sq = [2, 1]

            result = wht_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 2], [2, 1]]
          end
        end

        context 'when King moves up 1 space' do
          it 'returns an Array that is not empty' do
            end_sq = [3, 2]

            result = wht_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 2], [3, 2]]
          end
        end

        context 'when King tries to move up 2 spaces' do
          it 'returns an empty Array' do
            end_sq = [4, 2]

            result = wht_king.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when King tries to move diagonally 4 spaces' do
          it 'returns an empty Array' do
            end_sq = [6, 6]

            result = wht_king.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end

    context 'for black King' do
      context 'when start_sq is [5, 3]' do
        start_sq = [5, 3]

        context 'when King moves diagonally 1 space' do
          it 'returns an Array that is not empty' do
            end_sq = [4, 2]

            result = blk_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 3], [4, 2]]
          end

          it 'returns an Array that is not empty' do
            end_sq = [4, 4]

            result = blk_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 3], [4, 4]]
          end
        end

        context 'when King moves sideways 1 space' do
          it 'returns an Array that is not empty' do
            end_sq = [5, 2]

            result = blk_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 3], [5, 2]]
          end
        end

        context 'when King moves up 1 space' do
          it 'returns an Array that is not empty' do
            end_sq = [6, 3]

            result = blk_king.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 3], [6, 3]]
          end
        end

        context 'when King tries to move up 2 spaces' do
          it 'returns an empty Array' do
            end_sq = [7, 3]

            result = blk_king.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when King tries to move diagonally 4 spaces' do
          it 'returns an empty Array' do
            end_sq = [1, 7]

            result = blk_king.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end
