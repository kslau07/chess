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
      args = { key1: 'value1' }
      expect(Move.handles?(args)).to be(true)
    end
  end

  describe 'Move.factory' do
    before(:each) do
      class_double('Castle').as_stubbed_const
      class_double('EnPassant').as_stubbed_const
      class_double('PawnDoubleStep').as_stubbed_const
    end

    context 'when Castle.handles? returns true' do
      it 'sends new to Castle' do
        args = {}
        allow(Castle).to receive(:handles?).and_return(true)
        cand_list = [Castle, EnPassant, PawnDoubleStep]
        expect(Castle).to receive(:new)
        Move.factory(args, cand_list)
      end
    end

    context 'when EnPassant.handles? returns true' do
      it 'sends new to EnPassant' do
        args = {}
        allow(Castle).to receive(:handles?).and_return(false)
        allow(EnPassant).to receive(:handles?).and_return(true)
        cand_list = [Castle, EnPassant, PawnDoubleStep]
        expect(EnPassant).to receive(:new)
        Move.factory(args, cand_list)
      end
    end
  end

  subject(:move) { described_class.new(board: board) }
  let(:board) { instance_double(Board) }

  before(:each) do
    allow_message_expectations_on_nil
    allow(board).to receive(:object)
    allow(move.start_piece).to receive(:make_path)
    allow(move).to receive(:post_initialize)
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

  describe '#validate_move' do
    it 'sets @validated to true' do
      move.validate_move
      expect(move.validated).to be(true)
    end
  end

  describe '#move_permitted?' do
    context 'when reachable? returns false' do
      it 'returns false' do
        # returns true or false depending on return values of 2 method calls
        allow(move).to receive(:unreachable?).and_return(true)
        allow(board).to receive(:path_obstructed?).and_return(true)
        expect(move.move_permitted?).to be(false)
      end
    end

    context 'when reachable? returns true and path_obstructed? returns false' do
      it 'returns true' do
        allow(move).to receive(:unreachable?).and_return(false)
        allow(board).to receive(:path_obstructed?).and_return(false)
        expect(move.move_permitted?).to be(true)
      end
    end
  end

  describe '#unreachable?' do
    context 'when @path includes end_sq' do
      it 'returns false' do
        # We thought we would have to inject path, but we can use allow
        # since we have moved past initialize. The initialize method is the
        # hardest to set up for testing.
        allow(move.path).to receive(:include?).and_return(true)
        result = move.unreachable?
        expect(result).to be(false)
      end
    end

    context 'when @path does NOT include end_sq' do
      it 'returns true' do
        allow(move.path).to receive(:include?).and_return(false)
        result = move.unreachable?
        expect(result).to be(true)
      end
    end
  end

  describe '#transfer_piece' do
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
    context 'when board.check? is true' do
      it 'sets @checks to true' do
        allow(move.player).to receive(:color) # you can stub it if it has a reader
        allow(move.board).to receive(:check?).and_return(true)
        move.opponent_check
        expect(move.checks).to be(true)
      end
    end

    context 'when board.check? is false' do
      it 'does not set @checks to true' do
        allow(move.player).to receive(:color)
        allow(move.board).to receive(:check?).and_return(false)
        move.opponent_check
        expect(move.checks).not_to be(true)
      end
    end
  end

  describe '#test_checkmate_other_player' do
    context 'when Board#checkmate? is true' do
      it 'sets @checkmates to true' do
        move_data = {} # should we pass real data instead? check solutions
        allow(board).to receive(:checkmate?).and_return(true)
        move.test_checkmate_other_player(move_data)
        expect(move.checkmates).to be(true)
      end
    end

    context 'when Board#checkmate? is false' do
      it 'does not set @checkmates to true' do
        move_data = {}
        allow(board).to receive(:checkmate?).and_return(false)
        move.test_checkmate_other_player(move_data)
        expect(move.checkmates).not_to be(true)
      end
    end
  end

  # problem: we do not set @end_obj to anything, it is nil in these tests
  # solution: we need to set them when we instantiate Move
  describe '#capture_piece' do
    context 'when end_obj is a game piece' do
      it 'sets @captured_piece to end_obj' do
        allow(move.end_obj).to receive(:is_a?).and_return(true)
        move.capture_piece
        expect(move.captured_piece).to be(move.end_obj)
      end
    end

    context 'when end_obj is NOT a game piece' do
      it '@captured_piece is nil' do
        allow(move.end_obj).to receive(:is_a?).and_return(true)
        move.capture_piece
        expect(move.captured_piece).to be(true)
      end
    end
  end
end
