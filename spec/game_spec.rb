# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:player) { double('player')}
  let(:move_list) { double('move_list') }
  let(:board) { double('board') }
  let(:move) { double('move') }
  let(:display) { double('display') }

  before(:each) do
    allow(move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(true)
    @game = Game.new(player1: player, player2: player, move_list: move_list, board: board, move: move, display: display)
  end

  describe '#initialize' do
    # no need to test, only creates instance variables
  end

  describe '#post_initialize' do
    # no need to test, only creates instance variables
  end

  describe '#configure_board' do
    let(:board_config) { class_double('BoardConfig').as_stubbed_const }

    # Outgoing message, must test
    it 'instantiates BoardConfig' do
      expect(board_config).to receive(:new)
      @game.configure_board('standard')
    end
  end
end

