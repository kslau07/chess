# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'
require_relative '../lib/move'

describe Game do
  xit '' do
    allow(subject).to receive(:gets).and_return '10', '20'
    subject.play
  end
end

describe Game do
  subject(:game) { Game.new }

  
  describe '#initialize' do
    # Not tested
    it '' do
      # p ['game: ', subject.class]
    end
  end

  describe '#play' do
    # Script method, not tested
    # Only query and command methods are tested
  end
  
  # Script method
  describe '#turn_loop' do
  end

  # A query method expects a return value
  # A command method expects to set a value
end



describe Move do
  subject(:move) { described_class.new }

  before(:each) do
    allow_any_instance_of(Move).to receive(:move_sequence)
  end

  # Script method
  describe '#move_sequence' do
  end

  # Command and Query: needs testing
  describe '#input_move' do
    context 'when user input is good' do
      it 'receives 2 inputs from player' do
        allow(subject).to receive(:valid?).and_return(true)
        expect(subject).to receive(:gets).and_return('10', '20').twice
        subject.input_move
      end
    end

    context 'when user input is first invalid, then valid' do
      xit 'completes loop and receives error message once' do
      end
    end
  end

  # Query method
  describe '#board_object' do
    
    it 'returns "unoccupied"' do
      position_arr = [3, 3]
      result = subject.board_object(position_arr)
      expect(result).to eq('unoccupied')
    end

  end

  describe '#valid' do

  end

  # Command method
  describe '#transfer_piece' do
    before do
    end

    it 'sends #update_square twice to @board' do
      start_sq = [1, 0]
      end_sq = [2, 0]
      pawn = instance_double(Pawn)
      allow(pawn).to receive(:moved)
      allow(subject).to receive(:board_object).and_return(pawn)

      expect(subject.board).to receive(:update_square).twice
      subject.transfer_piece(start_sq, end_sq)
    end
  end
end