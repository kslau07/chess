# frozen_string_literal: true

require_relative '../../lib/piece'
require_relative '../../lib/pieces/pawn'

describe Pawn do
  let(:wht_pawn) { described_class.new(color: 'white') }
  let(:blk_pawn) { described_class.new(color: 'black') }

  describe '#to_s' do
    context 'when Pawn is white' do
      it "returns \u2659" do
        result = wht_pawn.to_s
        expect(result).to eq "\u2659"
      end
    end

    context 'when Pawn is black' do
      it "returns \u265F" do
        result = blk_pawn.to_s
        expect(result).to be "\u265F"
      end
    end
  end

  describe '#moved' do
    it 'sets @unmoved to false' do
      wht_pawn.moved
      expect(wht_pawn.unmoved).to be false
    end
  end

  describe '#make_path' do
    let(:board) { instance_double('Board') }
    start_sq = [4, 7]
    end_sq = [5, 7]

    it 'returns an empty Array' do
      result = wht_pawn.make_path(board, start_sq, end_sq)
      expect(result).to be_empty
    end
  end

  describe '#make_single_step_path' do
    context 'when Pawn is white and start square is [3, 1]' do
      it 'returns [[3, 1], [4, 1]]' do
        start_sq = [3, 1]
        result = wht_pawn.make_single_step_path(start_sq)
        expect(result).to eq [[3, 1], [4, 1]]
      end
    end

    context 'when Pawn is black and start square is [5, 6]' do
      it 'returns [[5, 6], [4, 6]]' do
        start_sq = [5, 6]
        result = blk_pawn.make_single_step_path(start_sq)
        expect(result).to eq [[5, 6], [4, 6]]
      end
    end
  end

  describe '#make_double_step_path' do
    context 'when Pawn is white and start square is [1, 6]' do
      it 'returns [[1, 6], [2, 6], [3, 6]]' do
        start_sq = [1, 6]
        # end_sq = [3, 6]
        result = wht_pawn.make_double_step_path(start_sq)
        expect(result).to eq [[1, 6], [2, 6], [3, 6]]
      end
    end

    context 'when Pawn is black and start square is [6, 1]' do
      it 'returns [[6, 1], [5, 1], [4, 1]]' do
        start_sq = [6, 1]
        result = blk_pawn.make_double_step_path(start_sq)
        expect(result).to eq [[6, 1], [5, 1], [4, 1]]
      end
    end
  end

  describe '#make_capture_path' do
    let(:board) { double('Board') }

    context 'when white pawn moves forward 1 space diagonally' do
      start_sq = [4, 2]
      end_sq = [5, 1]
      capturable_squares_ary = [[5, 1], [5, 3]]

      it 'returns an Array' do
        allow(wht_pawn).to receive(:capturable_squares).and_return(capturable_squares_ary)
        result = wht_pawn.make_capture_path(board, start_sq, end_sq)
        expect(result).to be_instance_of Array
      end

      it 'returns [[4, 2], [5, 1]]' do
        allow(wht_pawn).to receive(:capturable_squares).and_return(capturable_squares_ary)
        result = wht_pawn.make_capture_path(board, start_sq, end_sq)
        expect(result).to eq [[4, 2], [5, 1]]
      end
    end

    context 'when white pawn moves forward 1 step' do
      start_sq = [4, 2]
      end_sq = [5, 2]
      capturable_squares_ary = [[5, 1], [5, 3]]

      it 'returns an empty Array' do
        allow(wht_pawn).to receive(:capturable_squares).and_return(capturable_squares_ary)
        result = wht_pawn.make_capture_path(board, start_sq, end_sq)
        expect(result).to be_empty
      end
    end

    context 'when black pawn moves forward 1 space diagonally' do
      start_sq = [3, 6]
      end_sq = [2, 7]
      capturable_squares_ary = [[2, 7], [2, 5]]

      it 'returns an Array' do
        allow(blk_pawn).to receive(:capturable_squares).and_return(capturable_squares_ary)
        result = blk_pawn.make_capture_path(board, start_sq, end_sq)
        expect(result).to be_instance_of Array
      end

      it 'returns [[4, 2], [5, 1]]' do
        allow(blk_pawn).to receive(:capturable_squares).and_return(capturable_squares_ary)
        result = blk_pawn.make_capture_path(board, start_sq, end_sq)
        expect(result).to eq [[3, 6], [2, 7]]
      end
    end
  end

  describe '#capturable_squares' do
    context 'when white Pawn moves and start_sq is [1, 2]' do
      start_sq = [1, 2]

      it 'returns [[2, 3], [2, 1]]' do
        result = wht_pawn.capturable_squares(start_sq)
        expect(result).to eq [[2, 3], [2, 1]]
      end
    end

    context 'when black Pawn moves and start_sq is [6, 4]' do
      start_sq = [6, 4]

      it 'returns [[5, 5], [5, 3]]' do
        result = blk_pawn.capturable_squares(start_sq)
        expect(result).to eq [[5, 5], [5, 3]]
      end
    end
  end
end
