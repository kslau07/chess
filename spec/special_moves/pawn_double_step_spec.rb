# frozen_string_literal: true

require_relative '../../lib/special_moves/pawn_double_step'

describe PawnDoubleStep do
  board = Board.new

  describe 'PawnDoubleStep#handles?' do
    context 'when it\'s white\'s turn' do
      let(:player) { instance_double('Player', color: 'white') }
      st_sq = [1, 3]

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[1][3] = board.wht_pawn
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when start_sq is a Pawn' do
        it 'returns true if white Pawn moves 2 spaces forward' do
          double_step_sq = [3, 3]
          args = { player: player, start_sq: st_sq, end_sq: double_step_sq, board: board }

          result = PawnDoubleStep.handles?(args)
          expect(result).to be true
        end

        it 'returns false if white Pawn moves 1 space forward' do
          single_step_sq = [2, 3]
          args = { player: player, start_sq: st_sq, end_sq: single_step_sq, board: board }

          result = PawnDoubleStep.handles?(args)
          expect(result).to be false
        end

        it 'returns false if white Pawn moves diagonally' do
          move_forward_square = [2, 2]
          args = { player: player, start_sq: st_sq, end_sq: move_forward_square, board: board }

          result = PawnDoubleStep.handles?(args)
          expect(result).to be false
        end
      end
    end

    context 'when it\'s black\'s turn' do
      let(:player) { instance_double('Player', color: 'black') }
      st_sq = [6, 4]

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[6][4] = board.blk_pawn
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when start_sq is a Pawn' do
        it 'returns true if black Pawn moves 2 spaces forward' do
          double_step_sq = [4, 4]
          args = { player: player, start_sq: st_sq, end_sq: double_step_sq, board: board }

          result = PawnDoubleStep.handles?(args)
          expect(result).to be true
        end

        it 'returns false if black Pawn moves 1 space forward' do
          single_step_sq = [5, 4]
          args = { player: player, start_sq: st_sq, end_sq: single_step_sq, board: board }

          result = PawnDoubleStep.handles?(args)
          expect(result).to be false
        end

        it 'returns false if black Pawn moves diagonally' do
          move_forward_square = [5, 3]
          args = { player: player, start_sq: st_sq, end_sq: move_forward_square, board: board }

          result = PawnDoubleStep.handles?(args)
          expect(result).to be false
        end
      end
    end
  end

  describe '#post_initialize' do
    subject(:pawn_double_step) { described_class.new({ board: board, test: true }) }

    it 'sends #make_capture_path to Piece' do
      allow_message_expectations_on_nil
      allow(pawn_double_step).to receive(:assess_move)

      expect(pawn_double_step.start_piece).to receive(:make_double_step_path)
      pawn_double_step.post_initialize
    end
  end
end
