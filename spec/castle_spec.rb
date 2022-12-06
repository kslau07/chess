# frozen_string_literal: true

require_relative '../lib/library'

# fix post_initialize

describe Castle do
  describe 'class Castle' do
    context 'when white player takes turn' do
      board = Board.new
      board.create_new_grid
      board.grid[0][4] = board.wht_king
      board.grid[7][4] = board.blk_king
      candidate_list = [PawnDoubleStep, PawnSingleStep, EnPassant, PawnAttack, Castle, Move]    
      player1 = Player.new(color: 'white')

      context 'when king moves 2 spaces to the right of home space' do
        it 'instantiates Castle' do
          st_sq = [0, 4]
          en_sq = [0, 6]
          args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
          new_move = Move.factory(args, candidate_list)
          expect(new_move).to be_instance_of(Castle)
        end
      end

      context 'when white player moves king 2 spaces to the left of home space' do
        it 'instantiates Castle' do
          st_sq = [0, 4]
          en_sq = [0, 2]
          args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
          new_move = Move.factory(args, candidate_list)
          expect(new_move).to be_instance_of(Castle)
        end
      end

      context 'when white player moves king 1 space' do
        it 'does NOT instantiate Castle' do
          st_sq = [0, 4]
          en_sq = [0, 3]
          args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
          new_move = Move.factory(args, candidate_list)
          expect(new_move).not_to be_instance_of(Castle)
        end
      end
    end

    context 'when black player takes turn' do
      board = Board.new
      board.create_new_grid
      board.grid[0][4] = board.wht_king
      board.grid[7][4] = board.blk_king
      candidate_list = [PawnDoubleStep, PawnSingleStep, EnPassant, PawnAttack, Castle, Move]    
      player1 = Player.new(color: 'black')

      context 'when black player moves king 2 spaces to the right of home space' do
        it 'instantiates Castle' do
          st_sq = [7, 4]
          en_sq = [7, 6]
          args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
          new_move = Move.factory(args, candidate_list)
          expect(new_move).to be_instance_of(Castle)
        end
      end

      context 'when black player moves king 2 spaces to the left of home space' do
        it 'instantiates Castle' do
          st_sq = [7, 4]
          en_sq = [7, 2]
          args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
          new_move = Move.factory(args, candidate_list)
          expect(new_move).to be_instance_of(Castle)
        end
      end

      context 'when black player moves king 1 space' do
        it 'does NOT instantiate Castle' do
          st_sq = [7, 4]
          en_sq = [7, 3]
          args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1, test: true }
          new_move = Move.factory(args, candidate_list)
          expect(new_move).not_to be_instance_of(Castle)
        end
      end
    end
  end

  describe '#move_permitted?' do
    st_sq = [7, 4]
    en_sq = [7, 2]
    subject(:castle) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
    let(:board) { instance_double('Board') }
    let(:move_list) { instance_double('MoveList') }

    it 'sends #prev_move_check? to MoveList' do
      allow(board).to receive(:object)
      allow(castle).to receive(:base_move_castle)
      allow(castle).to receive(:king_side_castle?)
      expect(move_list).to receive(:prev_move_check?)
      castle.move_permitted?
    end

    context 'when previous move resulted in check' do
      it 'returns false' do
        allow(board).to receive(:object)
        allow(move_list).to receive(:prev_move_check?).and_return(true)
        result = castle.move_permitted?
        expect(result).to be(false)
      end
    end

    context 'when base move is [0, 2]' do
      it 'sends #object message to Board 3 times' do
        allow(move_list).to receive(:prev_move_check?)
        expect(board).to receive(:object).exactly(3).times
        allow(castle).to receive(:base_move_castle).and_return([0, 2])
        castle.move_permitted?
      end
    end

    context 'when base move is [0, -2]' do
      it 'sends #object message to Board 3 times' do
        allow(move_list).to receive(:prev_move_check?)
        expect(board).to receive(:object).exactly(3).times
        allow(castle).to receive(:base_move_castle).and_return([0, -2])
        castle.move_permitted?
      end
    end
  end

  describe '#king_side_castle' do
    context 'when white attempts to king-side castle' do
      board = Board.new
      st_sq = [0, 4]
      en_sq = [0, 6]
      subject(:castle) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[0][7] = board.wht_rook
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
        # let(:board) { instance_double('Board') }
        # let(:board) { Board.new }
      end

      context 'when corner piece is a rook' do
        context 'when both squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.wht_rook
              # allow(board).to receive(:object).and_return('unoccupied')
              # allow(castle.start_piece).to receive(:unmoved).and_return(true)
              # allow(corner_piece).to receive(:unmoved).and_return(true)
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(true)
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.wht_king.moved
              corner_piece = board.wht_rook
              # allow(board).to receive(:object).and_return('unoccupied')
              # allow(castle.start_piece).to receive(:unmoved).and_return(true)
              # allow(corner_piece).to receive(:unmoved).and_return(true)
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.wht_rook.moved
              corner_piece = board.wht_rook
              # allow(board).to receive(:object).and_return('unoccupied')
              # allow(castle.start_piece).to receive(:unmoved).and_return(true)
              # allow(corner_piece).to receive(:unmoved).and_return(true)
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[0][5] = board.wht_bishop
              corner_piece = board.wht_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end
        end
      end
    end

    context 'when black attempts to king-side castle' do
      board = Board.new
      st_sq = [7, 4]
      en_sq = [7, 2]
      subject(:castle) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        # board.grid[1][4] = board.wht_rook
        # board.grid[0][7] = board.wht_rook
        board.grid[7][7] = board.blk_rook
        board.grid[7][4] = board.blk_king
        board.grid[0][4] = board.wht_king
        # let(:board) { instance_double('Board') }
        # let(:board) { Board.new }
      end

      context 'when corner piece is a rook' do
        context 'when both squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(true)
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.blk_king.moved
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[7][5] = board.blk_bishop
              # board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end
        end
      end
    end
  end

  describe '#queen_side_castle' do
    context 'when white attempts to queen-side castle' do
      board = Board.new
      st_sq = [0, 4]
      en_sq = [0, 2]
      subject(:castle) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[0][0] = board.wht_rook
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
        # let(:board) { instance_double('Board') }
        # let(:board) { Board.new }
      end

      context 'when corner piece is a rook' do
        context 'when all 3 squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.wht_rook
              # allow(board).to receive(:object).and_return('unoccupied')
              # allow(castle.start_piece).to receive(:unmoved).and_return(true)
              # allow(corner_piece).to receive(:unmoved).and_return(true)
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(true)
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.wht_king.moved
              corner_piece = board.wht_rook
              # allow(board).to receive(:object).and_return('unoccupied')
              # allow(castle.start_piece).to receive(:unmoved).and_return(true)
              # allow(corner_piece).to receive(:unmoved).and_return(true)
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.wht_rook.moved
              corner_piece = board.wht_rook
              # allow(board).to receive(:object).and_return('unoccupied')
              # allow(castle.start_piece).to receive(:unmoved).and_return(true)
              # allow(corner_piece).to receive(:unmoved).and_return(true)
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[0][1] = board.wht_bishop
              corner_piece = board.wht_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end
        end
      end
    end

    context 'when black attempts to queen-side castle' do
      board = Board.new
      st_sq = [7, 4]
      en_sq = [7, 2]
      subject(:castle) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        # board.grid[1][4] = board.wht_rook
        # board.grid[0][7] = board.wht_rook
        board.grid[7][7] = board.blk_rook
        board.grid[7][4] = board.blk_king
        board.grid[0][4] = board.wht_king
        # let(:board) { instance_double('Board') }
        # let(:board) { Board.new }
      end

      context 'when corner piece is a rook' do
        context 'when all 3 squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(true)
            end
          end

          context 'when king has moved before' do
            xit 'returns false' do
              board.blk_king.moved
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[7][2] = board.blk_bishop
              # board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be(false)
            end
          end
        end
      end
    end
  end

  describe '#transfer_piece' do
    st_sq = [0, 4]
    en_sq = [0, 6]
    board = Board.new
    # let(:player1) { instance_double('Player', color: 'white') }
    args = { start_sq: st_sq, end_sq: en_sq, board: board, test: true }
    # hsh = { key: 'value', test: true }
    subject(:castle) { described_class.new(args) }

    it 'sends #moved to start_piece' do
      allow(castle).to receive(:find_rook)
      allow(castle.start_piece).to receive(:moved)
      expect(board).to receive(:update_square).exactly(4).times
      castle.transfer_piece
    end

    xit 'sends #moved to rook' do

    end
  end

  describe '#find_rook' do

  end

  describe '#set_kingside_rook' do

  end

  describe '#set_queenside_rook' do

  end
end

`
context 'when white initiates castle on king\'s side' do

it 'does NOT instantiate Castle when corresponding squares contain a piece' do

  it 'instantiates Castle when corresponding squares are unoccupied'

  # board = Board.new
  # board.create_new_grid
  # board.grid[4][3] = board.wht_pawn
  # board.grid[4][4] = board.blk_pawn
  # board.grid[0][3] = board.wht_king
  # board.grid[7][4] = board.blk_king
  # candidate_list = [PawnDoubleStep, PawnSingleStep, EnPassant, PawnAttack, Castle, Move]    
  # player1 = Player.new(color: 'white')

  xit 'does NOT instantiate Castle when corresponding squares contain a piece' do
    # st_sq = [4, 3]
    # en_sq = [5, 4]
    # args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1 }
    # new_move = Move.factory(args, candidate_list)
    # expect(new_move).to be_instance_of(EnPassant)
  end

  xit '' do
    # st_sq = [4, 3]
    # en_sq = [5, 3]
    # args = { start_sq: st_sq, end_sq: en_sq, board: board, player: player1 }
    # new_move = Move.factory(args, candidate_list)
    # expect(new_move).not_to be_instance_of(EnPassant)
  end

`
