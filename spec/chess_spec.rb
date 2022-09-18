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

  describe '#turn_loop' do
    # Script method
  end

  # A query method expects a return value
  # A command method expects to set a value
end



describe Move do
  subject(:move) { described_class.new }

  describe '#move_sequence' do
    # private script
  end

  describe '#input_move' do
    # Command and Query: needs testing

    context 'when user input is good' do
      before do
        allow_any_instance_of(Move).to receive(:move_sequence) # used during instantiation
      end

      it 'receives 2 inputs from player' do
        allow(move).to receive(:valid?).and_return(true)
        expect(move).to receive(:gets).and_return('10').twice
        move.input_move
      end
    end
  end

  describe '#board_object' do
    # Query method

    it 'returns a string' do
      subject
    end

  end

  describe '#valid' do

  end

  describe '#transfer_piece' do
    # Command method
    # test
    before do
    end

    xit 'sends #update_square twice to @board' do
      allow_any_instance_of(Move).to receive(:move_sequence)

      player = 'player'
      board = instance_double(Board)
      pawn = instance_double(Pawn, 'white')
      pawn.as_null_object
      move = Move.new(player, board)
      allow(move).to receive(:board_object).and_return(pawn)

      start_sq = [0, 0]
      end_sq = [1, 1]
      expect(board).to receive(:update_square).twice
      move.transfer_piece(start_sq, end_sq)
    end
  end
end