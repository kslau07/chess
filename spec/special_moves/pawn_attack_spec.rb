# frozen_string_literal: true

require_relative '../../lib/special_moves/pawn_attack'

describe PawnAttack do
  board = Board.new

  describe 'PawnAttack#handles?' do
    context 'when it\'s white\'s turn' do
      let(:player) { instance_double('Player', color: 'white') }
      st_sq = [1, 3]
      capture_sq = [2, 2]

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[1][3] = board.wht_pawn
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when start_sq is a Pawn' do
        it 'returns true if it captures black knight' do
          board.grid[2][2] = board.blk_knight
          args = { player: player, start_sq: st_sq, end_sq: capture_sq, board: board }

          result = PawnAttack.handles?(args)
          expect(result).to be true
        end

        it 'returns false if no enemy pieces are within reach' do
          board.grid[2][2] = 'unoccupied'
          args = { player: player, start_sq: st_sq, end_sq: capture_sq, board: board }

          result = PawnAttack.handles?(args)
          expect(result).to be false
        end

        it 'returns false if it moves forward 1 step instead of diagonally' do
          move_forward_square = [2, 3]
          args = { player: player, start_sq: st_sq, end_sq: move_forward_square, board: board }

          result = PawnAttack.handles?(args)
          expect(result).to be false
        end
      end
    end

    context 'when it\'s black\'s turn' do
      board = Board.new
      let(:player) { instance_double('Player', color: 'black') }
      st_sq = [6, 4]
      capture_sq = [5, 5]

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[6][4] = board.blk_pawn
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when start_sq is a Pawn' do
        it 'returns true if it captures white knight' do
          board.grid[5][5] = board.wht_knight
          args = { player: player, start_sq: st_sq, end_sq: capture_sq, board: board }

          result = PawnAttack.handles?(args)
          expect(result).to be true
        end

        it 'returns false if no enemy pieces are within reach' do
          board.grid[2][2] = 'unoccupied'
          args = { player: player, start_sq: st_sq, end_sq: capture_sq, board: board }

          result = PawnAttack.handles?(args)
          expect(result).to be false
        end

        it 'returns false if it moves forward 1 step instead of diagonally' do
          move_forward_square = [5, 4]
          args = { player: player, start_sq: st_sq, end_sq: move_forward_square, board: board }

          result = PawnAttack.handles?(args)
          expect(result).to be false
        end
      end
    end
  end

  describe '#post_initialize' do
    subject(:pawn_attack) { described_class.new({ board: board, test: true }) }

    it 'sends #make_capture_path to Piece' do
      allow_message_expectations_on_nil

      expect(pawn_attack.start_piece).to receive(:make_capture_path)
      pawn_attack.post_initialize
    end
  end

  describe '#move_permitted?' do
    context 'when white\'s turn' do
      st_sq = [1, 3]
      en_sq = [2, 4]
      player = Player.new(color: 'white')
      subject(:pawn_attack) { described_class.new({ start_sq: st_sq, end_sq: en_sq, player: player, board: board, test: true }) }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[1][3] = board.wht_pawn
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when end square is a black piece' do
        it 'returns true' do
          board.grid[2][4] = board.blk_pawn
          allow(pawn_attack).to receive(:assess_move)

          result = pawn_attack.move_permitted?
          expect(result).to be true
        end
      end

      context 'when end square is a friendly piece' do
        it 'returns false' do
          board.grid[2][4] = board.wht_pawn
          allow(pawn_attack).to receive(:assess_move)

          result = pawn_attack.move_permitted?
          expect(result).to be false
        end
      end

      context 'when end square is unoccupied' do
        it 'returns false' do
          board.grid[2][4] = 'unoccupied'
          allow(pawn_attack).to receive(:assess_move)

          result = pawn_attack.move_permitted?
          expect(result).to be false
        end
      end
    end

    context 'when black\'s turn' do
      st_sq = [6, 4]
      en_sq = [5, 5]
      player = Player.new(color: 'black')
      subject(:pawn_attack) { described_class.new({ start_sq: st_sq, end_sq: en_sq, player: player, board: board, test: true }) }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[1][3] = board.wht_pawn
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when end square is a white piece' do
        it 'returns true' do
          board.grid[5][5] = board.wht_pawn
          allow(pawn_attack).to receive(:assess_move)
          result = pawn_attack.move_permitted?
          expect(result).to be true
        end
      end

      context 'when end square is a friendly piece' do
        it 'returns false' do
          board.grid[5][5] = board.blk_pawn
          allow(pawn_attack).to receive(:assess_move)
          result = pawn_attack.move_permitted?
          expect(result).to be false
        end
      end

      context 'when end square is unoccupied' do
        it 'returns false' do
          board.grid[5][5] = 'unoccupied'
          allow(pawn_attack).to receive(:assess_move)
          result = pawn_attack.move_permitted?
          expect(result).to be false
        end
      end
    end
  end
end
