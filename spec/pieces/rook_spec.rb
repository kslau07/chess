# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/rook'

describe Rook do
  let(:wht_rook) { described_class.new(color: 'white') }
  let(:blk_rook) { described_class.new(color: 'black') }
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
    context 'when Rook is white' do
      it "returns \u2656" do
        result = wht_rook.to_s
        expect(result).to eq "\u2656"
      end
    end

    context 'when Rook is black' do
      it "returns \u265C" do
        result = blk_rook.to_s
        expect(result).to be "\u265C"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_rook.moved
      expect(wht_rook.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns rook\s move_set' do
      rook_move_set = [[1, 0], [0, 1], [-1, 0], [0, -1]]

      result = wht_rook.possible_moves
      expect(result).to eq rook_move_set
    end
  end

  # superclass method
  describe '#make_path' do
    context 'for white Rook' do
      context 'when start_sq is [2, 5]' do
        start_sq = [2, 5]

        context 'when Rook moves 1 square to the right' do
          it 'returns an Array that is not empty' do
            end_sq = [2, 6]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 5], [2, 6]]
          end
        end

        context 'when Rook moves 2 squares to the right' do
          it 'returns an Array that is not empty' do
            end_sq = [2, 7]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 5], [2, 6], [2, 7]]
          end
        end

        context 'when Rook moves 5 squares to the left' do
          it 'returns an Array that is not empty' do
            end_sq = [2, 0]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 5], [2, 4], [2, 3], [2, 2], [2, 1], [2, 0]]
          end
        end

        context 'when Rook moves 1 square up' do
          it 'returns an Array that is not empty' do
            end_sq = [3, 5]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 5], [3, 5]]
          end
        end

        context 'when Rook moves 1 square down' do
          it 'returns an Array that is not empty' do
            end_sq = [1, 5]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 5], [1, 5]]
          end
        end

        context 'when Rook moves 4 squares up' do
          it 'returns an Array that is not empty' do
            end_sq = [6, 5]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[2, 5], [3, 5], [4, 5], [5, 5], [6, 5]]
          end
        end

        context 'when Rook tries to move diagonally' do
          it 'returns an empty Array' do
            end_sq = [3, 6]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when Rook tries to move like a Knight' do
          it 'returns an empty Array' do
            end_sq = [3, 3]

            result = wht_rook.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end

    context 'for black Rook' do
      context 'when start_sq is [4, 2]' do
        start_sq = [4, 2]

        context 'when Rook moves 1 square to the right' do
          it 'returns an Array that is not empty' do
            end_sq = [4, 3]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[4, 2], [4, 3]]
          end
        end

        context 'when Rook moves 2 squares to the right' do
          it 'returns an Array that is not empty' do
            end_sq = [4, 0]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[4, 2], [4, 1], [4, 0]]
          end
        end

        context 'when Rook moves 5 squares to the right' do
          it 'returns an Array that is not empty' do
            end_sq = [4, 7]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7]]
          end
        end

        context 'when Rook moves 1 square up' do
          it 'returns an Array that is not empty' do
            end_sq = [5, 2]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[4, 2], [5, 2]]
          end
        end

        context 'when Rook moves 1 square down' do
          it 'returns an Array that is not empty' do
            end_sq = [3, 2]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[4, 2], [3, 2]]
          end
        end

        context 'when Rook moves 4 squares down' do
          it 'returns an Array that is not empty' do
            end_sq = [0, 2]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to eq [[4, 2], [3, 2], [2, 2], [1, 2], [0, 2]]
          end
        end

        context 'when Rook tries to move diagonally' do
          it 'returns an empty Array' do
            end_sq = [5, 1]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when Rook tries to move like a Knight' do
          it 'returns an empty Array' do
            end_sq = [3, 4]

            result = blk_rook.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end
