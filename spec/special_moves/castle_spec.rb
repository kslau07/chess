# frozen_string_literal: true

require_relative '../../lib/special_moves/castling'

describe Castling do
  board = Board.new

  describe 'Castling#handles?' do
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

            result = Castling.handles?(args)
            expect(result).to be true
          end
        end

        context 'when King moves 1 space' do
          it 'returns false' do
            king_sq = [0, 4]
            move_1_space_sq = [0, 5]
            args = { start_sq: king_sq, end_sq: move_1_space_sq, board: board, player: player1 }

            result = Castling.handles?(args)
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

          result = Castling.handles?(args)
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

            result = Castling.handles?(args)
            expect(result).to be true
          end
        end

        context 'when King moves 1 space' do
          it 'returns false' do
            king_sq = [7, 4]
            move_1_space_sq = [7, 5]
            args = { start_sq: king_sq, end_sq: move_1_space_sq, board: board, player: player2 }

            result = Castling.handles?(args)
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

          result = Castling.handles?(args)
          expect(result).to be false
        end
      end
    end
  end

  describe '#move_permitted?' do
    st_sq = [7, 4]
    en_sq = [7, 2]
    subject(:castling) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
    let(:board) { instance_double('Board') }
    let(:move_list) { instance_double('MoveList') }

    it 'sends #prev_move_check? to MoveList' do
      allow(board).to receive(:object)
      allow(castling).to receive(:base_move_castling)
      allow(castling).to receive(:king_side_castling?)
      expect(move_list).to receive(:prev_move_check?)
      castling.move_permitted?
    end

    context 'when previous move resulted in check' do
      it 'returns false' do
        allow(board).to receive(:object)
        allow(move_list).to receive(:prev_move_check?).and_return(true)

        result = castling.move_permitted?
        expect(result).to be false
      end
    end

    context 'when base move is [0, 2]' do
      it 'sends #object message to Board 3 times' do
        allow(move_list).to receive(:prev_move_check?)

        expect(board).to receive(:object).exactly(3).times
        allow(castling).to receive(:base_move_castling).and_return([0, 2])
        castling.move_permitted?
      end
    end

    context 'when base move is [0, -2]' do
      it 'sends #object message to Board 3 times' do
        allow(move_list).to receive(:prev_move_check?)

        expect(board).to receive(:object).exactly(3).times
        allow(castling).to receive(:base_move_castling).and_return([0, -2])
        castling.move_permitted?
      end
    end
  end

  describe '#king_side_castling' do
    context 'when white attempts to castle king-side' do
      st_sq = [0, 4]
      en_sq = [0, 6]
      subject(:castling) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[0][7] = board.wht_rook
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when corner piece is a rook' do
        context 'when both squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.wht_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be true
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.wht_king.moved
              corner_piece = board.wht_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.wht_rook.moved
              corner_piece = board.wht_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[0][5] = board.wht_bishop
              corner_piece = board.wht_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end

    context 'when black attempts to caste king-side' do
      st_sq = [7, 4]
      en_sq = [7, 2]
      subject(:castling) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[7][7] = board.blk_rook
        board.grid[7][4] = board.blk_king
        board.grid[0][4] = board.wht_king
      end

      context 'when corner piece is a rook' do
        context 'when both squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.blk_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be true
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.blk_king.moved
              corner_piece = board.blk_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.blk_rook.moved
              corner_piece = board.blk_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[7][5] = board.blk_bishop
              corner_piece = board.blk_rook

              result = castling.king_side_castling?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end
  end

  describe '#queen_side_castling' do
    context 'when white attempts to castle queen-side' do
      st_sq = [0, 4]
      en_sq = [0, 2]
      subject(:castling) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[0][0] = board.wht_rook
        board.grid[0][4] = board.wht_king
        board.grid[7][4] = board.blk_king
      end

      context 'when corner piece is a rook' do
        context 'when all 3 squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.wht_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be true
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.wht_king.moved
              corner_piece = board.wht_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.wht_rook.moved
              corner_piece = board.wht_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[0][1] = board.wht_bishop
              corner_piece = board.wht_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end

    context 'when black attempts to castle queen-side' do
      st_sq = [7, 4]
      en_sq = [7, 2]
      subject(:castling) { described_class.new(board: board, move_list: move_list, start_sq: st_sq, end_sq: en_sq, test: true) }
      let(:move_list) { instance_double('MoveList') }

      before(:each) do
        board.create_new_grid
        board.create_pieces(PieceFactory)
        board.grid[7][7] = board.blk_rook
        board.grid[7][4] = board.blk_king
        board.grid[0][4] = board.wht_king
      end

      context 'when corner piece is a rook' do
        context 'when all 3 squares inbetween are unoccupied' do
          context 'when neither king nor rook have moved' do
            it 'returns true' do
              corner_piece = board.blk_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be true
            end
          end

          context 'when king has moved before' do
            it 'returns false' do
              board.blk_king.moved
              corner_piece = board.blk_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when rook has moved before' do
            it 'returns false' do
              board.blk_rook.moved
              corner_piece = board.blk_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be false
            end
          end

          context 'when one square inbetween is occupied' do
            it 'returns false' do
              board.grid[7][2] = board.blk_bishop
              corner_piece = board.blk_rook

              result = castling.queen_side_castling?(corner_piece)
              expect(result).to be false
            end
          end
        end
      end
    end
  end

  describe '#transfer_piece' do
    kings_sq = [0, 4]
    castling_sq = [0, 6]
    player1 = Player.new(color: 'white')
    let(:king) { instance_double('King') }
    let(:trns_board) { instance_double('Board') }
    subject(:castling) { described_class.new(player: player1, start_sq: kings_sq, end_sq: castling_sq, board: trns_board, test: true) }

    before(:each) do
      allow(trns_board).to receive(:object).and_return('Piece obj')
      allow(castling).to receive(:find_rook)
      allow(castling).to receive(:rook_new_sq).and_return([0, 5])
      allow(castling).to receive(:rook).and_return(board.wht_rook)
      allow(castling).to receive(:corner).and_return([0, 7])
    end

    it 'sends #update_square to Board 4 times' do
      allow(castling).to receive_message_chain(:start_piece, :moved)
      allow(castling).to receive_message_chain(:rook, :moved)

      expect(trns_board).to receive(:update_square).exactly(4).times
      castling.transfer_piece
    end

    it 'sends #moved to start_piece' do
      allow(trns_board).to receive(:update_square)
      allow(castling).to receive_message_chain(:rook, :moved)
      allow(castling).to receive(:start_piece).and_return(king)

      expect(castling).to receive_message_chain(:start_piece, :moved)
      castling.transfer_piece
    end

    it 'sends #moved to rook' do
      allow(trns_board).to receive(:update_square)
      allow(castling).to receive_message_chain(:start_piece, :moved)

      expect(castling).to receive_message_chain(:rook, :moved)
      castling.transfer_piece
    end
  end

  describe '#find_rook' do
    # Only sends messages to self
  end

  describe '#set_kingside_rook' do
    st_sq = [0, 4]
    en_sq = [0, 6]
    args = { start_sq: st_sq, end_sq: en_sq, board: board, test: true }
    subject(:castling) { described_class.new(args) }

    it 'sets @corner to [0, 7]' do
      castling.set_kingside_rook
      expect(castling.corner).to eq [0, 7]
    end

    it 'sets @rook_new_sq to [0, 5]' do
      castling.set_kingside_rook
      expect(castling.rook_new_sq).to eq [0, 5]
    end

    it 'sets @rook to a Rook instance' do
      board.create_new_grid
      board.grid[0][7] = board.wht_rook
      castling.set_kingside_rook

      expect(castling.rook).to be_instance_of(Rook)
    end
  end

  describe '#set_queenside_rook' do
    st_sq = [0, 4]
    en_sq = [0, 2]
    args = { start_sq: st_sq, end_sq: en_sq, board: board, test: true }
    subject(:castling) { described_class.new(args) }

    it 'sets @corner to [0, 0]' do
      castling.set_queenside_rook
      expect(castling.corner).to eq [0, 0]
    end

    it 'sets @rook_new_sq to [0, 3]' do
      castling.set_queenside_rook
      expect(castling.rook_new_sq).to eq [0, 3]
    end

    it 'sets @rook to a Rook instance' do
      board.create_new_grid
      board.grid[0][0] = board.wht_rook
      castling.set_queenside_rook

      expect(castling.rook).to be_instance_of(Rook)
    end
  end
end
