# frozen_string_literal: true

require_relative '../lib/library'

describe EnPassant do
  describe 'class EnPassant' do
    context 'when black pawn can pass by white pawn' do
      board = Board.new
      board.create_new_grid
      board.grid[4][3] = board.wht_pawn
      board.grid[4][4] = board.blk_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king
      candidate_list = [PawnDoubleStep, PawnSingleStep, EnPassant, PawnAttack, Castle, Move]    
      player1 = Player.new(color: 'white')

      it 'is instantiated when white pawn attempts en passant capture' do
        st_sq = [4, 3]
        en_sq = [5, 4]
        args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
        new_move = Move.factory(args, candidate_list)
        expect(new_move).to be_instance_of(EnPassant)
      end

      it 'is NOT instantiated when white pawn steps forward' do
        st_sq = [4, 3]
        en_sq = [5, 3]
        args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1 }
        new_move = Move.factory(args, candidate_list)
        expect(new_move).not_to be_instance_of(EnPassant)
      end
    end

    context 'when white pawn can pass by black pawn' do
      board = Board.new
      board.create_new_grid
      board.grid[3][2] = board.wht_pawn
      board.grid[3][3] = board.blk_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king
      candidate_list = [PawnDoubleStep, PawnSingleStep, EnPassant, PawnAttack, Castle, Move]    
      player2 = Player.new(color: 'black')

      it 'is instantiated when black pawn attempts en passant capture' do
        st_sq = [3, 3]
        en_sq = [2, 2]
        args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player2, test: true }
        new_move = Move.factory(args, candidate_list)
        expect(new_move).to be_instance_of(EnPassant)
      end

      it 'is NOT instantiated when black pawn steps forward' do
        st_sq = [3, 3]
        en_sq = [2, 3]
        args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player2 }
        new_move = Move.factory(args, candidate_list)
        expect(new_move).not_to be_instance_of(EnPassant)
      end
    end
  end

  describe '#move_permitted?' do
    # Only calls self, no tests required
  end

  describe '#pawn_on_correct_row?' do
    board = Board.new

    context 'when white player\'s pawn is on the correct row' do
      board.create_new_grid
      board.grid[4][3] = board.wht_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king
      st_sq = [4, 3]
      en_sq = [5, 4]
      args = { board: board, player: Player.new, start_sq: st_sq, end_sq: en_sq, test: true }
      subject(:en_passant) { described_class.new(args) }

      it 'returns true' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be(true)
      end
    end

    context 'when white player\'s pawn on another row' do
      board.create_new_grid
      board.grid[1][6] = board.wht_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king
      st_sq = [1, 6]
      en_sq = [2, 6]
      args = { board: board, player: Player.new, start_sq: st_sq, end_sq: en_sq }
      subject(:en_passant) { described_class.new(args) }

      it 'returns false' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be(false)
      end
    end

    context 'when black player\'s pawn is on the correct row' do
      board.create_new_grid
      board.grid[3][3] = board.blk_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king
      st_sq = [3, 3]
      en_sq = [2, 4]
      args = { board: board, player: Player.new(color: 'black'), start_sq: st_sq, end_sq: en_sq, test: true }
      subject(:en_passant) { described_class.new(args) }

      it 'returns true' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be(true)
      end
    end

    context 'when black player\'s pawn on another row' do
      board.create_new_grid
      board.grid[5][3] = board.blk_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king
      st_sq = [5, 3]
      en_sq = [4, 3]
      args = { board: board, player: Player.new(color: 'black'), start_sq: st_sq, end_sq: en_sq }
      subject(:en_passant) { described_class.new(args) }

      it 'returns true' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be(false)
      end
    end
  end

  describe '#opp_prev_move_allows_en_passant?' do
    board = Board.new

    context 'for white pawn capturing black pawn' do
      board.create_new_grid
      board.grid[4][3] = board.wht_pawn
      board.grid[4][4] = board.blk_pawn
      board.grid[0][3] = board.wht_king
      board.grid[7][4] = board.blk_king

      context 'when black pawn\'s previous move allows en passant capture' do
        st_sq = [4, 3]
        en_sq = [5, 4]
        valid_en_passant_mv_list = ['Pd2d4', 'Pa7a6+', 'Pd4d5', 'Pe7e5']
        move_list = MoveList.new(valid_en_passant_mv_list)
        args = { board: board, player: Player.new(color: 'white'), start_sq: st_sq, end_sq: en_sq, move_list: move_list }
        subject(:en_passant) { described_class.new(args) }

        it 'returns true' do
          allow(en_passant).to receive(:base_move).and_return([1, 1])
          result = en_passant.opp_prev_move_allows_en_passant?
          expect(result).to be(true)
        end
      end

      context 'when black pawn\'s previous move doesn\'t allow en passant capture' do
        st_sq = [4, 3]
        en_sq = [5, 4]
        not_valid_en_passant_mv_list = ['Pd2d4', 'Pe7e6', 'Pd4d5+', 'Pe6e5']
        move_list = MoveList.new(not_valid_en_passant_mv_list)
        args = { board: board, player: Player.new(color: 'white'), start_sq: st_sq, end_sq: en_sq, move_list: move_list }
        subject(:en_passant) { described_class.new(args) }

        it 'does NOT return true (nil)' do
          allow(en_passant).to receive(:base_move).and_return([1, 1])
          result = en_passant.opp_prev_move_allows_en_passant?
          expect(result).not_to be(true)
        end
      end
    end

    context 'for black pawn capturing white pawn' do
      board.create_new_grid
      board.grid[3][4] = board.wht_pawn
      board.grid[3][3] = board.blk_pawn
      board.grid[0][4] = board.wht_king
      board.grid[7][3] = board.blk_king

      context 'when white pawn\'s previous move allows en passant capture' do
        st_sq = [3, 3]
        en_sq = [2, 4]
        valid_en_passant_mv_list = ['Pa2a3', 'Pd7d5+', 'Pg2g4', 'Pd5d4+', 'Pe2e4']
        move_list = MoveList.new(valid_en_passant_mv_list)
        args = { board: board, player: Player.new(color: 'black'), start_sq: st_sq, end_sq: en_sq, move_list: move_list }
        subject(:en_passant) { described_class.new(args) }

        it 'returns true' do
          allow(en_passant).to receive(:base_move).and_return([1, -1])
          result = en_passant.opp_prev_move_allows_en_passant?
          expect(result).to be(true)
        end
      end

      context 'when white pawn\'s previous move doesn\'t allow en passant capture' do
        st_sq = [3, 3]
        en_sq = [2, 4]
        not_valid_en_passant_mv_list = ['Pa2a3', 'Pd7d5+', 'Pg2g4', 'Pd5d4+', 'Pe3e4']
        move_list = MoveList.new(not_valid_en_passant_mv_list)
        args = { board: board, player: Player.new(color: 'black'), start_sq: st_sq, end_sq: en_sq, move_list: move_list }
        subject(:en_passant) { described_class.new(args) }

        it 'does NOT return true (nil)' do
          allow(en_passant).to receive(:base_move).and_return([1, -1])
          result = en_passant.opp_prev_move_allows_en_passant?
          expect(result).not_to be(true)
        end
      end
    end
  end

  describe '#capture_piece' do
    board = Board.new
    board.create_new_grid
    board.grid[3][4] = board.wht_pawn
    board.grid[3][3] = board.blk_pawn
    board.grid[0][4] = board.wht_king
    board.grid[7][3] = board.blk_king
    st_sq = [3, 3]
    en_sq = [2, 4]
    valid_en_passant_mv_list = ['Pa2a3', 'Pd7d5+', 'Pg2g4', 'Pd5d4+', 'Pe2e4']
    move_list = MoveList.new(valid_en_passant_mv_list)
    args = { board: board, player: Player.new(color: 'black'), start_sq: st_sq, end_sq: en_sq, move_list: move_list }
    subject(:en_passant) { described_class.new(args) }

    it 'sets @captured_piece to the enemy pawn that moved last' do
      en_passant.capture_piece
      expect(en_passant.captured_piece).to be_instance_of(Pawn)
    end
  end

  describe '#transfer_piece' do
    board = Board.new
    st_sq = [3, 3]
    en_sq = [2, 4]
    valid_en_passant_mv_list = ['Pa2a3', 'Pd7d5+', 'Pg2g4', 'Pd5d4+', 'Pe2e4']
    move_list = MoveList.new(valid_en_passant_mv_list)
    args = { board: board, player: Player.new(color: 'black'), start_sq: st_sq, end_sq: en_sq, move_list: move_list }
    subject(:en_passant) { described_class.new(args) }

    it 'sends #update_square to Board 3 times' do
      allow(en_passant).to receive(:capture_piece)
      expect(board).to receive(:update_square).exactly(3).times
      en_passant.transfer_piece
    end
  end
end
