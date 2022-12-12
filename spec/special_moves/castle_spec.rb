# frozen_string_literal: true

# require_relative '../lib/library'
require_relative '../../lib/special_moves/castle'


describe Castle do
  board = Board.new

  describe 'Castle#handles?' do
    context 'when it\'s white\'s turn' do
      player1 = Player.new(color: 'white')

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
      end

      after(:all) do
        board.create_new_grid
      end

      context 'when piece is a King' do
        before(:each) do
          board.grid[0][4] = board.wht_king
        end

        context 'when King moves 2 spaces' do
          it 'returns true' do
            king_sq = [0, 4]
            move_2_spaces_sq = [0, 6]
            args = { start_sq: king_sq, end_sq: move_2_spaces_sq, board: board, player: player1 }
            result = Castle.handles?(args)
            expect(result).to be true
          end
        end

        context 'when King moves 1 space' do
          it 'returns false' do
            king_sq = [0, 4]
            move_1_space_sq = [0, 5]
            args = { start_sq: king_sq, end_sq: move_1_space_sq, board: board, player: player1 }
            result = Castle.handles?(args)
            expect(result).to be false
          end
        end
      end

      context 'when piece is not a King' do
        it 'returns false' do
          board.grid[0][4] = board.wht_queen
          not_king_sq = [0, 4]
          move_2_spaces_sq = [0, 6]
          args = { start_sq: not_king_sq, end_sq: move_2_spaces_sq, board: board, player: player1 }
          result = Castle.handles?(args)
          expect(result).to be false
        end
      end
    end

    context 'when it\'s black\'s turn' do
      player2 = Player.new(color: 'black')

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
      end

      after(:all) do
        board.create_new_grid
      end

      context 'when piece is a King' do
        before(:each) do
          board.grid[7][4] = board.blk_king
        end

        context 'when King moves 2 spaces' do
          it 'returns true' do
            king_sq = [7, 4]
            move_2_spaces_sq = [7, 6]
            args = { start_sq: king_sq, end_sq: move_2_spaces_sq, board: board, player: player2 }
            result = Castle.handles?(args)
            expect(result).to be true
          end
        end

        context 'when King moves 1 space' do
          it 'returns false' do
            king_sq = [7, 4]
            move_1_space_sq = [7, 5]
            args = { start_sq: king_sq, end_sq: move_1_space_sq, board: board, player: player2 }
            result = Castle.handles?(args)
            expect(result).to be false
          end
        end
      end

      context 'when piece is not a King' do
        it 'returns false' do
          board.grid[7][4] = board.blk_queen
          not_king_sq = [7, 4]
          move_2_spaces_sq = [7, 6]
          args = { start_sq: not_king_sq, end_sq: move_2_spaces_sq, board: board, player: player2 }
          result = Castle.handles?(args)
          expect(result).to be false
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
        expect(result).to be false
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
      # board = Board.new
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
              expect(result).to be true
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
              expect(result).to be false
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
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[0][5] = board.wht_bishop
              corner_piece = board.wht_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end

    context 'when black attempts to king-side castle' do
      # board = Board.new
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
              expect(result).to be true
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.blk_king.moved
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[7][5] = board.blk_bishop
              # board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.king_side_castle?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end
  end

  describe '#queen_side_castle' do
    context 'when white attempts to queen-side castle' do
      # board = Board.new
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
              expect(result).to be true
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
              expect(result).to be false
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
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[0][1] = board.wht_bishop
              corner_piece = board.wht_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end

    context 'when black attempts to queen-side castle' do
      # board = Board.new
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
              expect(result).to be true
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.blk_king.moved
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[7][2] = board.blk_bishop
              # board.blk_rook.moved
              corner_piece = board.blk_rook
              result = castle.queen_side_castle?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end
  end

  describe '#transfer_piece' do
    kings_sq = [0, 4]
    castle_sq = [0, 6]
    player1 = Player.new(color: 'white')
    let(:king) { instance_double('King') }
    let(:trns_board) { instance_double('Board') }
    subject(:castle) { described_class.new(player: player1, start_sq: kings_sq, end_sq: castle_sq, board: trns_board, test: true) }

    before(:each) do
      allow(trns_board).to receive(:object).and_return('Piece obj')
      allow(castle).to receive(:find_rook)
      allow(castle).to receive(:rook_new_sq).and_return([0, 5])
      allow(castle).to receive(:rook).and_return(board.wht_rook)
      allow(castle).to receive(:corner).and_return([0, 7])
    end

    it 'sends #update_square to Board 4 times' do
      allow(castle).to receive_message_chain(:start_piece, :moved)
      allow(castle).to receive_message_chain(:rook, :moved)
      expect(trns_board).to receive(:update_square).exactly(4).times
      castle.transfer_piece
    end

    it 'sends #moved to start_piece' do
      allow(trns_board).to receive(:update_square)
      allow(castle).to receive_message_chain(:rook, :moved)
      allow(castle).to receive(:start_piece).and_return(king)
      expect(castle).to receive_message_chain(:start_piece, :moved)
      castle.transfer_piece
    end

    it 'sends #moved to rook' do
      allow(trns_board).to receive(:update_square)
      allow(castle).to receive_message_chain(:start_piece, :moved)
      expect(castle).to receive_message_chain(:rook, :moved)
      castle.transfer_piece
    end
  end

  describe '#find_rook' do
    # Only sends messages to self
  end

  describe '#set_kingside_rook' do
    st_sq = [0, 4]
    en_sq = [0, 6]
    args = { start_sq: st_sq, end_sq: en_sq, board: board, test: true }
    subject(:castle) { described_class.new(args) }

    it 'sets @corner to [0, 7]' do
      castle.set_kingside_rook
      expect(castle.corner).to eq [0, 7]
    end

    it 'sets @rook_new_sq to [0, 5]' do
      castle.set_kingside_rook
      expect(castle.rook_new_sq).to eq [0, 5]
    end

    it 'sets @rook to a Rook instance' do
      board.create_new_grid
      board.grid[0][7] = board.wht_rook
      castle.set_kingside_rook
      expect(castle.rook).to be_instance_of(Rook)
    end
  end

  describe '#set_queenside_rook' do
    st_sq = [0, 4]
    en_sq = [0, 2]
    args = { start_sq: st_sq, end_sq: en_sq, board: board, test: true }
    subject(:castle) { described_class.new(args) }

    it 'sets @corner to [0, 0]' do
      castle.set_queenside_rook
      expect(castle.corner).to eq [0, 0]
    end

    it 'sets @rook_new_sq to [0, 3]' do
      castle.set_queenside_rook
      expect(castle.rook_new_sq).to eq [0, 3]
    end

    it 'sets @rook to a Rook instance' do
      board.create_new_grid
      board.grid[0][0] = board.wht_rook
      castle.set_queenside_rook
      expect(castle.rook).to be_instance_of(Rook)
    end
  end
end

