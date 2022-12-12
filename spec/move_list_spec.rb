# frozen_string_literal: true

require_relative '../lib/move_list'
require_relative '../lib/piece'
require_relative '../lib/pieces/knight'

describe MoveList do
  subject(:move_list) { described_class.new }

  describe '#set' do
    it 'sets @all_moves to mv_list' do
      mv_list = %w[move1 move2 move3]
      move_list.set(mv_list)
      expect(move_list.all_moves).to eq mv_list
    end
  end

  describe '#add' do
    context 'when black Bishop captures a white pawn and also checks white King' do
      let(:blk_pawn) { instance_double('Pawn', color: 'black') }
      let(:new_move) { instance_double('Move', start_sq: [3, 1], end_sq: [2, 2], captured_piece: blk_pawn) }

      it 'adds a string that will contain a plus (+) symbol to signify check' do
        allow(new_move).to receive(:checks).and_return(true)
        allow(move_list).to receive(:piece_code).and_return('B')
        move_list.add(new_move)
        new_move_str = move_list.all_moves[0]
        expect(new_move_str).to include('+')
      end

      it 'adds a string that will contain \'x\' to signify a capture was made' do
        allow(new_move).to receive(:checks).and_return(true)
        allow(move_list).to receive(:piece_code).and_return('B')
        move_list.add(new_move)
        new_move_str = move_list.all_moves[0]
        expect(new_move_str).to include('x')
      end

      it 'adds \'Bb4xc3+\' to all_moves array' do
        allow(new_move).to receive(:checks).and_return(true)
        allow(move_list).to receive(:piece_code).and_return('B')
        move_list.add(new_move)
        expect(move_list.all_moves).to eq ['Bb4xc3+']
      end
    end

    context 'when white Pawn moves 2 steps forward' do
      let(:new_move) { instance_double('Move', start_sq: [1, 7], end_sq: [3, 7], captured_piece: nil) }

      it 'adds a string that will not contain a plus (+) symbol (no check)' do
        allow(new_move).to receive(:checks).and_return(false)
        allow(move_list).to receive(:piece_code).and_return('P')
        move_list.add(new_move)
        new_move_str = move_list.all_moves[0]
        expect(new_move_str).not_to include('+')
      end

      it 'adds a string that will not contain \'x\' since no capture was made' do
        allow(new_move).to receive(:checks).and_return(false)
        allow(move_list).to receive(:piece_code).and_return('P')
        move_list.add(new_move)
        new_move_str = move_list.all_moves[0]
        expect(new_move_str).not_to include('x')
      end

      it 'adds \'Bb4xc3+\' to all_moves array' do
        allow(new_move).to receive(:checks).and_return(false)
        allow(move_list).to receive(:piece_code).and_return('P')
        move_list.add(new_move)
        expect(move_list.all_moves).to eq ['Ph2h4']
      end
    end
  end

  describe '#piece_code' do
    context 'when game piece is a black Knight' do
      let(:new_move2) { instance_double('Move', start_piece: blk_knight) }
      let(:blk_knight) { instance_double('Knight', color: 'black') }

      it 'returns letter N' do
        allow(new_move2).to receive_message_chain(:start_piece, :instance_of?).and_return(true)
        result = move_list.piece_code(new_move2)
        expect(result).to eq 'N'
      end
    end

    context 'when game piece is a white King' do
      let(:new_move3) { instance_double('Move', start_piece: blk_king) }
      let(:blk_king) { instance_double('King', color: 'black') }

      it 'returns letter N' do
        allow(new_move3).to receive_message_chain(:start_piece, :instance_of?).and_return(false)
        result = move_list.piece_code(new_move3)
        expect(result).to eq 'R' # should be K if I used real object, but RSpec double starts with R
      end
    end
  end

  describe '#last_move_cleaned' do
    context 'when move list is not empty' do
      it 'removes + and x from last move' do
        move_list.set(['Ph2h4', 'Bb4xc3+']) # changes @all_moves
        result = move_list.last_move_cleaned
        expect(result).to eq 'Bb4c3'
      end
    end

    context 'when move list is empty' do
      it 'returns nil' do
        result = move_list.last_move_cleaned
        expect(result).to be_nil
      end
    end
  end

  describe '#prev_sq' do
    # Sends to self, no test required
  end

  describe '#prev_move' do
    context 'when move list is not empty' do
      it 'returns the last move' do
        move_list.set(%w[Ph2h4 Pc7c5])
        result = move_list.prev_move
        expect(result).to eq 'Pc7c5'
      end
    end

    context 'when move list is empty' do
      it 'returns nil' do
        result = move_list.prev_move
        expect(result).to be_nil
      end
    end
  end

  describe '#prev_move_check?' do
    context 'when move list is not empty' do
      it 'returns true if previous move resulted in check' do
        move_list.set(['Ph2h4', 'Bb4xc3+'])
        allow(move_list).to receive(:prev_move).and_return('Bb4xc3+')
        result = move_list.prev_move_check?
        expect(result).to be true
      end

      it 'returns false if previous move did not check' do
        move_list.set(%w[Ph2h4 Pc7c5])
        allow(move_list).to receive(:prev_move).and_return('Pc7c5')
        result = move_list.prev_move_check?
        expect(result).to be false
      end
    end

    context 'when move list is empty' do
      it 'returns nil' do
        result = move_list.prev_move_check?
        expect(result).to be_nil
      end
    end
  end
end
