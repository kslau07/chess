# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/queen'

describe Queen do
  let(:wht_queen) { described_class.new(color: 'white') }
  let(:blk_queen) { described_class.new(color: 'black') }
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
    context 'when Queen is white' do
      it "returns \u2655" do
        result = wht_queen.to_s
        expect(result).to eq "\u2655"
      end
    end

    context 'when Queen is black' do
      it "returns \u265B" do
        result = blk_queen.to_s
        expect(result).to be "\u265B"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_queen.moved
      expect(wht_queen.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns queen\s move_set' do
      queen_move_set = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1],
                        [0, -1], [1, -1]]

      result = wht_queen.possible_moves
      expect(result).to eq queen_move_set
    end
  end

  # superclass method
  describe '#make_path' do
    context 'for white Queen' do
      context 'when start_sq is [1, 3]' do
        start_sq = [1, 3]

        context 'when Queen moves diagonally 1 space' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [2, 4]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[1, 3], [2, 4]]
          end
        end

        context 'when Queen moves diagonally 5 spaces' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [5, 7]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[1, 3], [2, 4], [3, 5], [4, 6], [5, 7]]
          end
        end

        context 'when Queen moves sideways 1 space' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [1, 2]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[1, 3], [1, 2]]
          end
        end

        context 'when Queen moves sideways 4 spaces' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [1, 6]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[1, 3], [1, 4], [1, 5], [1, 6]]
          end
        end

        context 'when Queen moves down 1 space' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [0, 3]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[1, 3], [0, 3]]
          end
        end

        context 'when Queen moves up 5 spaces' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [6, 3]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[1, 3], [2, 3], [3, 3], [4, 3], [5, 3], [6, 3]]
          end
        end

        context 'when Queen tries to move like a Knight' do
          it 'returns an empty Array' do
            end_sq = [2, 5]

            result = wht_queen.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end

    context 'for black Queen' do
      context 'when start_sq is [5, 2]' do
        start_sq = [5, 2]

        context 'when Queen moves diagonally 1 space' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [4, 3]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 2], [4, 3]]
          end
        end

        context 'when Queen moves diagonally 5 spaces' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [0, 7]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 2], [4, 3], [3, 4], [2, 5], [1, 6], [0, 7]]
          end
        end

        context 'when Queen moves sideways 1 space' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [5, 3]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 2], [5, 3]]
          end
        end

        context 'when Queen moves sideways 4 spaces' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [5, 6]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 2], [5, 3], [5, 4], [5, 5], [5, 6]]
          end
        end

        context 'when Queen moves down 1 space' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [4, 2]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 2], [4, 2]]
          end
        end

        context 'when Queen moves down 6 spaces' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [0, 2]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 2], [4, 2], [3, 2], [2, 2], [1, 2], [0, 2]]
          end
        end

        context 'when Queen tries to move like a Knight' do
          it 'returns an empty Array' do
            end_sq = [4, 4]

            result = blk_queen.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end
