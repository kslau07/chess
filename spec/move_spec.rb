# frozen_string_literal: true

require_relative '../lib/move'
require_relative '../lib/save_load'
require_relative '../lib/board'

describe Move do
  describe 'Move.registry' do
    it 'sets @registry to an Array' do
      expect(Move.registry).to be_an(Array)
    end
  end

  describe 'Move.register' do
    # Sends message to self, no need to test
  end

  describe 'Move.handles?' do
    it 'returns true' do
      args = {}
      expect(Move.handles?(args)).to be true
    end
  end

  describe 'Move.factory' do
    before(:each) do
      class_double('Castling').as_stubbed_const
      class_double('EnPassant').as_stubbed_const
      class_double('PawnDoubleStep').as_stubbed_const
      class_double('PawnSingleStep').as_stubbed_const
      class_double('PawnAttack').as_stubbed_const
    end

    context 'when Castling.handles? returns true' do
      it 'sends new to Castling' do
        args = {}
        allow(Castling).to receive(:handles?).and_return(true)
        cand_list = [Castling, EnPassant, PawnDoubleStep, PawnSingleStep, PawnAttack]
        expect(Castling).to receive(:new)
        Move.factory(args, cand_list)
      end
    end

    context 'when EnPassant.handles? returns true' do
      it 'sends new to EnPassant' do
        args = {}
        allow(Castling).to receive(:handles?).and_return(false)
        allow(EnPassant).to receive(:handles?).and_return(true)
        cand_list = [Castling, EnPassant, PawnDoubleStep, PawnSingleStep, PawnAttack]
        expect(EnPassant).to receive(:new)
        Move.factory(args, cand_list)
      end
    end

    context 'when PawnDoubleStep.handles? returns true' do
      it 'sends new to PawnDoubleStep' do
        args = {}
        allow(Castling).to receive(:handles?).and_return(false)
        allow(EnPassant).to receive(:handles?).and_return(false)
        allow(PawnDoubleStep).to receive(:handles?).and_return(true)
        cand_list = [Castling, EnPassant, PawnDoubleStep, PawnSingleStep, PawnAttack]
        expect(PawnDoubleStep).to receive(:new)
        Move.factory(args, cand_list)
      end
    end

    context 'when PawnSingleStep.handles? returns true' do
      it 'sends new to PawnSingleStep' do
        args = {}
        allow(Castling).to receive(:handles?).and_return(false)
        allow(EnPassant).to receive(:handles?).and_return(false)
        allow(PawnDoubleStep).to receive(:handles?).and_return(false)
        allow(PawnSingleStep).to receive(:handles?).and_return(true)
        cand_list = [Castling, EnPassant, PawnDoubleStep, PawnSingleStep, PawnAttack]
        expect(PawnSingleStep).to receive(:new)
        Move.factory(args, cand_list)
      end
    end

    context 'when PawnAttack.handles? returns true' do
      it 'sends new to PawnAttack' do
        args = {}
        allow(Castling).to receive(:handles?).and_return(false)
        allow(EnPassant).to receive(:handles?).and_return(false)
        allow(PawnDoubleStep).to receive(:handles?).and_return(false)
        allow(PawnSingleStep).to receive(:handles?).and_return(false)
        allow(PawnAttack).to receive(:handles?).and_return(true)
        cand_list = [Castling, EnPassant, PawnDoubleStep, PawnSingleStep, PawnAttack]
        expect(PawnAttack).to receive(:new)
        Move.factory(args, cand_list)
      end
    end
  end


  describe '#initialize' do
    # Sets 2 variables by sending outgoing query messages
    # Outgoing query messages are not tested
  end

  describe '#post_initialize' do
    # Outgoing query, no need to test
  end

  describe '#assess_move' do 
    # Sends messages to self, no need to test
  end

  st_sq = [0, 0]
  en_sq = [1, 1]
  subject(:move) { described_class.new(start_sq: st_sq, end_sq: en_sq, board: board, test: true) }
  let(:board) { instance_double(Board) }

  before(:each) do
    allow(board).to receive(:object)
  end

  describe '#validate_move' do
    it 'sets @validated to true' do
      move.validate_move
      expect(move.validated).to be true
    end
  end

  describe '#move_permitted?' do
    context 'when reachable? returns false' do
      it 'returns false' do
        allow(move).to receive(:unreachable?).and_return(true)
        allow(board).to receive(:path_obstructed?).and_return(true)
        expect(move.move_permitted?).to be false
      end
    end

    context 'when reachable? returns true and path_obstructed? returns false' do
      it 'returns true' do
        allow(move).to receive(:unreachable?).and_return(false)
        allow(board).to receive(:path_obstructed?).and_return(false)
        expect(move.move_permitted?).to be true
      end
    end
  end

  describe '#unreachable?' do
    before do
      allow(move).to receive_message_chain(:start_piece, :make_path).and_return([0, 0])
      allow(move).to receive(:assess_move)
      move.post_initialize
    end

    context 'when @path includes end_sq' do
      it 'returns false' do
        allow(move.path).to receive(:include?).and_return(true)
        result = move.unreachable?
        expect(result).to be false
      end
    end

    context 'when @path does NOT include end_sq' do
      it 'returns true' do
        allow(move.path).to receive(:include?).and_return(false)
        result = move.unreachable?
        expect(result).to be true
      end
    end
  end

  describe '#transfer_piece' do
    let(:blk_pawn) { instance_double('Pawn', color: 'black') }

    before do
      allow(move).to receive(:start_piece).and_return(blk_pawn)
    end

    it 'sends #update_square twice to Board' do
      allow(move.start_piece).to receive(:moved)
      expect(board).to receive(:update_square).twice
      move.transfer_piece
    end

    it 'sends #moved to Piece once' do
      allow(move).to receive(:capture_piece)
      allow(board).to receive(:update_square)
      expect(move.start_piece).to receive(:moved).exactly(1).time
      move.transfer_piece
    end
  end

  describe '#opponent_check' do
    let(:player1) { instance_double('Player', color: 'white') }

    before do
      allow(move).to receive(:player).and_return(player1)
    end

    context 'when board.check? is true' do
      it 'sets @checks to true' do
        allow(move.player).to receive(:color)
        allow(move.board).to receive(:check?).and_return(true)
        move.opponent_check
        expect(move.checks).to be true
      end
    end

    context 'when board.check? is false' do
      it 'does not set @checks to true' do
        allow(move.player).to receive(:color)
        allow(move.board).to receive(:check?).and_return(false)
        move.opponent_check
        expect(move.checks).not_to be true
      end
    end
  end

  describe '#test_checkmate_other_player' do
    context 'when Board#checkmate? is true' do
      it 'sets @checkmates to true' do
        move_data = {}
        allow(board).to receive(:checkmate?).and_return(true)
        move.test_checkmate_other_player(move_data)
        expect(move.checkmates).to be true
      end
    end

    context 'when Board#checkmate? is false' do
      it 'does not set @checkmates to true' do
        move_data = {}
        allow(board).to receive(:checkmate?).and_return(false)
        move.test_checkmate_other_player(move_data)
        expect(move.checkmates).not_to be true
      end
    end
  end

  describe '#capture_piece' do
    let(:wht_bishop) { instance_double('Bishop', color: 'white') }

    context 'when end_obj is a game piece' do
      it 'sets @captured_piece to end_obj' do
        allow(move).to receive(:end_obj).and_return(wht_bishop)
        allow(move.end_obj).to receive(:is_a?).and_return(true)
        move.capture_piece
        expect(move.captured_piece).to be move.end_obj
      end
    end

    context 'when end_obj is NOT a game piece' do
      it '@captured_piece is nil' do
        allow(move).to receive_message_chain(:end_obj, :is_a?).and_return(false)
        move.capture_piece
        expect(move.captured_piece).to be_nil
      end
    end
  end
end
