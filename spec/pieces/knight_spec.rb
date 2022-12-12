# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/knight'

describe Knight do
  let(:wht_knight) { described_class.new(color: 'white') }
  let(:blk_knight) { described_class.new(color: 'black') }
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
    context 'when Knight is white' do
      it "returns \u2658" do
        result = wht_knight.to_s
        expect(result).to eq "\u2658"
      end
    end

    context 'when Knight is black' do
      it "returns \u265E" do
        result = blk_knight.to_s
        expect(result).to be "\u265E"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_knight.moved
      expect(wht_knight.unmoved).to be false
    end
  end

  describe '#possible_moves' do
    it 'returns knight\s move_set' do
      knight_move_set = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2],
                         [1, -2], [2, -1]]

      result = wht_knight.possible_moves
      expect(result).to eq knight_move_set
    end
  end

  # superclass method
  describe '#make_path' do
    context 'for white Knight' do
      context 'when start_sq is [3, 4]' do
        start_sq = [3, 4]

        context 'when Knight moves up 2 and 1 right' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [5, 5]

            result = wht_knight.make_path(board, start_sq, end_sq)
            expect(result).to eq [[3, 4], [5, 5]]
          end
        end

        context 'when Knight moves down 1 and 2 left' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [2, 2]

            result = wht_knight.make_path(board, start_sq, end_sq)
            expect(result).to eq [[3, 4], [2, 2]]
          end
        end

        context 'when Knight tries to move sideways' do
          it 'returns an empty Array' do
            end_sq = [4, 0]

            result = wht_knight.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when Knight tries to move vertically' do
          it 'returns an empty Array' do
            end_sq = [5, 4]

            result = wht_knight.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end

    context 'for black Knight' do
      context 'when start_sq is [5, 4]' do
        start_sq = [5, 4]

        context 'when Knight moves up 2 and 1 right' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [7, 5]

            result = blk_knight.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 4], [7, 5]]
          end
        end

        context 'when Knight moves down 1 and 2 left' do
          it 'returns a path (Array) that is not empty' do
            end_sq = [4, 2]

            result = blk_knight.make_path(board, start_sq, end_sq)
            expect(result).to eq [[5, 4], [4, 2]]
          end
        end

        context 'when Knight tries to move sideways' do
          it 'returns an empty Array' do
            end_sq = [5, 2]

            result = blk_knight.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end

        context 'when Knight tries to move vertically' do
          it 'returns an empty Array' do
            end_sq = [0, 4]

            result = blk_knight.make_path(board, start_sq, end_sq)
            expect(result).to be_empty
          end
        end
      end
    end
  end
end
