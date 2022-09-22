# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/bishop'
require_relative '../lib/knight'
require_relative '../lib/rook'
require_relative '../lib/queen'
require_relative '../lib/king'
require_relative '../lib/move'

describe Move do
  subject(:move) { described_class.new }

  # perhaps move to example block
  before(:each) do
    allow_any_instance_of(Move).to receive(:move_sequence)
  end

  # Script method
  describe '#move_sequence' do
  end

  # Command and Query: needs testing
  describe '#input_move' do
    # perhaps move before block to example blocks
    before(:each) do
      move.board.grid[1][0] = Pawn.new
      move.board.grid[2][0] = 'unoccupied'
    end

    context 'when user input is good for Pawn on [1][0]' do
      it 'receives 2 inputs from player' do
        allow(Display).to receive(:puts)
        expect(subject).to receive(:gets).and_return('10', '20')

        expect(Display).not_to receive(:invalid_input_message)
        subject.input_move
      end
    end

    context 'when user input is first invalid, then valid for Pawn on [1][0]' do
      it 'completes loop and receives error message once' do
        allow(Display).to receive(:puts)
        expect(subject).to receive(:gets).and_return('99', '99', '10', '20')

        expect(Display).to receive(:invalid_input_message).once
        subject.input_move
      end
    end
  end

  # Query method
  describe '#board_object' do
    it 'returns "unoccupied"' do
      position_arr = [4, 7]
      result = subject.board_object(position_arr)
      expect(result).to eq('unoccupied')
    end
  end

  describe '#move_valid?' do
    context 'when start_sq and end_sq are permitted for Bishop' do
      before do
        move.board.grid[0][2] = Bishop.new
        # move.board.grid[5][7] = 'unoccupied'
        move.instance_variable_set(:@start_sq, [0, 2])
        move.instance_variable_set(:@end_sq, [5, 7])
      end

      it 'returns true' do
        result = subject.move_valid?
        expect(result).to eq(true)
      end
    end

    context 'when end_sq is not allowed for Bishop' do
      before do
        move.board.grid[0][2] = Bishop.new
        # move.board.grid[5][5] = 'unoccupied'
        move.instance_variable_set(:@start_sq, [1, 0])
        move.instance_variable_set(:@end_sq, [5, 5])
      end

      it 'returns false' do
        result = subject.move_valid?
        expect(result).to eq(false)
      end
    end

    context 'when "en passant" is a possible move and player executes move' do
      before do
        move.board.grid[1][3] = Pawn.new(color: 'white')
        move.board.grid[3][4] = Pawn.new(color: 'black')
        # move.board.grid[5][7] = 'unoccupied'
        move.instance_variable_set(:@start_sq, [0, 2])
        move.instance_variable_set(:@end_sq, [5, 7])
      end

      # it 'returns true' do

      # end


      it "captures the opponent's pawn" do
        result = subject.move_valid?
        expect(result).to eq(true)
      end
    end
  end

  describe '#reachable?' do
    context 'when end_sq is reachable by Bishop' do
      it 'returns true' do
        start_sq = [0, 2]
        end_sq = [2, 4]
        piece = Bishop.new
        subject.instance_variable_set(:@path, piece.generate_path(start_sq, end_sq))
        subject.instance_variable_set(:@end_sq, end_sq)

        expect(subject.reachable?).to be(true)
      end
    end

    context 'when end_sq is NOT reachable by Bishop' do
      it 'returns true' do
        start_sq = [0, 2]
        end_sq = [7, 7]
        piece = Bishop.new
        subject.instance_variable_set(:@path, piece.generate_path(start_sq, end_sq))
        subject.instance_variable_set(:@end_sq, end_sq)

        expect(subject.reachable?).to be(false)
      end
    end
  end

  describe '#reachable_by_pawn?' do
    context 'when Pawn move is 2 squares but is obstructed by a piece' do
      # This is already covered by #path_obstructed
    end

    context 'when Pawn move is 1 square but is obstructed by a piece' do
      # Covered by #path_obstructed
    end

    context 'when Pawn tries to move diagonally forward 1 space and space is empty' do
      it 'returns false' do
        start_sq = [1, 6]
        end_sq = [2, 5]
        piece = Pawn.new
        subject.board.grid[1, 6] = piece
        subject.board.grid[2, 5] = 'unoccupied'
        subject.instance_variable_set(:@path, piece.generate_path(start_sq, end_sq))
        subject.instance_variable_set(:@start_piece, piece)
        subject.instance_variable_set(:@start_sq, start_sq)
        subject.instance_variable_set(:@end_sq, end_sq)
        subject.instance_variable_set(:@end_piece, 'unoccupied')

        expect(subject.reachable_by_pawn?).to be(false)
      end
    end

    context 'when Pawn tries to move diagonally forward 1 space and space is occupied by own piece' do
      xit 'returns false' do
        # This logic is handled by #path_obstructed
      end
    end
  end

  describe '#path_obstructed?' do
    context "when Bishop's path is not blocked by other pieces" do
      before do
        subject.board.grid[0][2] = Bishop.new(color: 'white')
        subject.board.grid[1][0] = Pawn.new(color: 'white')
      end

      it 'returns false' do
        start_sq = [0, 2]
        end_sq = [5, 7]
        piece = Bishop.new
        path = piece.generate_path(start_sq, end_sq)
        subject.instance_variable_set(:@path, path)

        result = subject.path_obstructed?(path, start_sq, end_sq)
        expect(result).to be(false)
      end
    end

    context "when Bishop's path is blocked by own Pawn" do
      before do
        subject.board.grid[0][2] = Bishop.new(color: 'white')
        subject.board.grid[1][3] = Pawn.new(color: 'white')
      end

      it 'it returns true' do
        start_sq = [0, 2]
        end_sq = [2, 4]
        piece = Bishop.new
        path = piece.generate_path(start_sq, end_sq)
        subject.instance_variable_set(:@path, path)

        result = subject.path_obstructed?(path, start_sq, end_sq)
        expect(result).to be(true)
      end
    end

    context "when Bishop's path is blocked by opponent's Pawn" do
      before do
        subject.board.grid[0][2] = Bishop.new(color: 'black')
        subject.board.grid[1][3] = Pawn.new(color: 'white')
      end

      it 'it returns true' do
        start_sq = [0, 2]
        end_sq = [2, 4]
        piece = Bishop.new
        path = piece.generate_path(start_sq, end_sq)
        subject.instance_variable_set(:@path, path)

        result = subject.path_obstructed?(path, start_sq, end_sq)
        expect(result).to be(true)
      end
    end


    context "when Bishop's end square contains own color Pawn" do
      before do
        subject.board.grid[0][2] = Bishop.new(color: 'white')
        subject.board.grid[1][3] = Pawn.new(color: 'white')
      end

      it 'it returns true' do
        start_sq = [0, 2]
        end_sq = [1, 3]
        piece = Bishop.new
        path = piece.generate_path(start_sq, end_sq)
        subject.instance_variable_set(:@path, path)

        result = subject.path_obstructed?(path, start_sq, end_sq)
        expect(result).to be(true)
      end
    end

    context "when Bishop's end square contains opponent's Pawn" do
      before do
        subject.board.grid[0][2] = Bishop.new(color: 'white')
        subject.board.grid[1][3] = Pawn.new(color: 'black')
      end

      it 'it returns false' do
        start_sq = [0, 2]
        end_sq = [1, 3]
        piece = Bishop.new
        path = piece.generate_path(start_sq, end_sq)
        subject.instance_variable_set(:@path, path)

        result = subject.path_obstructed?(path, start_sq, end_sq)
        expect(result).to be(false)
      end
    end
  end

  # Command method
  describe '#transfer_piece' do
    xit '' do
    end
  end
end
