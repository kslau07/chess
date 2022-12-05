# frozen_string_literal: true

require_relative '../lib/board'

# EnPassant#handles is a preliminary check, the deeper check happens
# in #opp_prev_move_allows_en_passant?, which is why EnPassant is instantiated
# even when the move_list is not valid.

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
        args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1 }
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
        args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player2 }
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
    board.create_new_grid
    board.grid[4][3] = board.wht_pawn
    board.grid[4][4] = board.blk_pawn
    board.grid[0][3] = board.wht_king
    board.grid[7][4] = board.blk_king
    st_sq = [4, 3]
    en_sq = [5, 4]
    args = { board: board, player: Player.new, start_sq: st_sq, end_sq: en_sq }
    subject(:en_passant) { described_class.new(args) }

    context 'when white player\'s pawn is on the correct row' do
      it 'returns true' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be(true)
      end
    end

    context 'when white player\'s pawn on another row' do
      it 'returns false' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be 
      end
    end

    context 'when black player\'s pawn is on the correct row' do
      xit 'returns true' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be 
      end
    end

    context 'when black player\'s pawn on another row' do
      xit 'returns false' do
        result = en_passant.pawn_on_correct_row?
        expect(result).to be 
      end
    end
  end

  # describe '#move_permitted?' do
  #   context 'when white player\'s pawn is on the correct row' do
  #     board = Board.new
  #     board.create_new_grid
  #     board.grid[4][3] = board.wht_pawn
  #     board.grid[4][4] = board.blk_pawn
  #     board.grid[0][3] = board.wht_king
  #     board.grid[7][4] = board.blk_king
  #     st_sq = [4, 3]
  #     en_sq = [5, 4]
  #     args = { board: board, player: Player.new, start_sq: st_sq, end_sq: en_sq }
  #     subject(:en_passant) { described_class.new(args) }

  #     it 'returns true when #opp_prev_move_allows_en_passant? is also true' do
  #       allow(en_passant).to receive(:pawn_on_correct_row?).and_return(true)
  #       allow
  #       result = en_passant.move_permitted?
  #       expect(result).to be(true)
  #     end
  #   end
  # end




  # context 'when black pawn moves 2 steps and en passant capture for white is valid' do
  #   xit 'returns true' do
  #     valid_en_passant_move_list = ['Pd2d4', 'Pa7a6+', 'Pd4d5', 'Pe7e5']
  #     move_list = MoveList.new(valid_en_passant_move_list)
  #     player1 = Player.new(color: 'white')
  #     args = { start_sq: [4, 3], end_sq: [5, 4], board: board, player: player1, move_list: move_list, test: false }
  #     new_move = Move.factory(args, candidate_list)
  #     expect(new_move).to be_instance_of(EnPassant)
  #   end
  # end
  # context 'when black pawn moves 1 step and en passant capture for white is NOT valid' do
  #   it 'returns true' do
  #     # invalid_en_passant_move_list = ['Pd2d4', 'Pe7e6', 'Pd4d5+', 'Pe6e5']
  #     # move_list = MoveList.new(invalid_en_passant_move_list)
  #     move_list = MoveList.new
  #     player1 = Player.new(color: 'white')
  #     st_sq = [4, 3]
  #     en_sq = [4, 4]
  #     args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, move_list: move_list, test: false }
  #     new_move = Move.factory(args, candidate_list)
  #     expect(new_move).to be_instance_of(EnPassant)
  #   end
  # end
end
