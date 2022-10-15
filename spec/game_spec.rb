# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/move'
require_relative '../lib/board'
require_relative '../lib/move_list'
require_relative '../lib/display'
require_relative '../lib/board_layout'
require_relative '../lib/piece_factory'
require_relative '../lib/pieces/pawn'
require_relative '../lib/pieces/bishop'
require_relative '../lib/pieces/knight'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/queen'
require_relative '../lib/pieces/king'

describe Game do
  subject(:game) { described_class.new }

  describe '#initialize' do
    it 'sets @player1 to a kind of Player' do
      expect(subject.player1).to be_a(Player)
    end

    it 'sets @player2 to a kind of Player' do
      expect(subject.player2).to be_a(Player)
    end

    it 'sets @current_player to a kind of Player' do
      expect(subject.current_player).to be_a(Player)
    end
  end

  describe '#play' do
    before do
      allow(game).to receive(:gets).and_return('a')
    end

    it 'calls Display.greeting' do
      allow(game).to receive(:start_sequence)
      allow(game).to receive(:turn_sequence)
      allow(game).to receive(:play_again)
      allow(game).to receive(:game_over).and_return(true)
      expect(Display).to receive(:greeting) # nil
      game.play
    end
  end

  describe '#post_initialize' do
    it 'is invoked when Game is initialized' do
      expect_any_instance_of(Game).to receive(:post_initialize)
      described_class.new
    end

    it 'sets @board to Board' do
      expect(subject.board).to be_a(Board)
    end

    it 'sets @move_list to MoveList' do
      expect(subject.move_list).to be_a(MoveList)
    end
  end

  describe '#setup_board' do
    it 'is invoked when Game is initialized' do
      expect_any_instance_of(Game).to receive(:setup_board)
      described_class.new
    end
  end

  describe '#create_move' do
    it 'sends message to move.factory' do
      start_sq = [0, 0]
      end_sq = [1, 1]
      expect(Move).to receive(:factory)
      subject.create_move(start_sq, end_sq)
    end
  end

  # private methods
  # describe '#setup_board' do
  # end

  # describe '#turn_sequence' do
  # end

  # describe '#start_sequence' do
  # end

  # describe '#checkmate_seq' do
  # end

  # describe '#move_data' do
  # end

  # describe '#legal_move' do
  # end

  # describe '#switch_players' do
  # end

  # describe '#other_player' do
  # end

  # describe '#win' do
  # end

  # describe '#tie' do
  # end

  # describe '#play_again' do
  # end
end
