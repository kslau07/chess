# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/move'

def basic_pawn_setup

end

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
  end

  describe '#reachable?' do
    context 'when end_sq is reachable by Bishop' do
      it 'returns true' do
        start_sq = [0, 2]
        end_sq = [2, 4]
        piece = Bishop.new
        subject.instance_variable_set(:@path, piece.find_route(start_sq, end_sq))
        subject.instance_variable_set(:@end_sq, end_sq)

        expect(subject.reachable?).to be(true)
      end
    end

    context 'when end_sq is NOT reachable by Bishop' do
      it 'returns true' do
        start_sq = [0, 2]
        end_sq = [7, 7]
        piece = Bishop.new
        subject.instance_variable_set(:@path, piece.find_route(start_sq, end_sq))
        subject.instance_variable_set(:@end_sq, end_sq)

        expect(subject.reachable?).to be(false)
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
        path = piece.find_route(start_sq, end_sq)
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
        path = piece.find_route(start_sq, end_sq)
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
        path = piece.find_route(start_sq, end_sq)
        subject.instance_variable_set(:@path, path)

        result = subject.path_obstructed?(path, start_sq, end_sq)
        expect(result).to be(true)
      end
    end
  end

  # Command method
  describe '#transfer_piece' do
    xit '' do
    end
  end
end

# describe '#transfer_piece' do
#   xit 'sends #update_square twice to @board' do
#     start_sq = [1, 0]
#     end_sq = [2, 0]
#     pawn = instance_double(Pawn)
#     allow(pawn).to receive(:moved)
#     allow(subject).to receive(:board_object).and_return(pawn)

#     expect(subject.board).to receive(:update_square).twice
#     subject.transfer_piece(start_sq, end_sq)
#   end
# end