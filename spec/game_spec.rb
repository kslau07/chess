# frozen_string_literal: true

require_relative '../lib/game'
require_relative '../lib/piece'
Dir['../lib/pieces/*.rb'].sort.each { |file| require file }

describe Game do
  subject(:game) { described_class.new(player1: player1, player2: player2, move_list: move_list, board: board, move: move, display: display) }
  let(:player1) { double('player1') }
  let(:player2) { double('player2') }
  let(:move_list) { double('move_list') }
  let(:board) { double('board') }
  let(:move) { double('move') }
  let(:display) { double('display') }

  before(:each) do
    allow_message_expectations_on_nil
    allow(move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(true)
    # game = Game.new(player1: player1, player2: player2, move_list: move_list, board: board, move: move, display: display)
  end

  describe '#initialize' do
    # no need to test, only creates instance variables
  end

  describe '#post_initialize' do
    # no need to test, only creates instance variables
  end

  describe '#configure_board' do
    let(:board_config) { class_double('BoardConfig').as_stubbed_const }

    it 'instantiates BoardConfig' do
      expect(board_config).to receive(:new)
      game.configure_board('standard')
    end
  end

  describe '#turn_sequence' do
    before(:each) do
      allow(display).to receive(:draw_board)
      allow(game).to receive(:produce_legal_move)
      allow(board).to receive(:promote_pawn).with(game.new_move)
      allow(game.new_move).to receive(:opponent_check).and_return(true)
      allow(move_list).to receive(:add)
      allow(game.new_move).to receive(:checks).and_return(false)
      allow(game).to receive(:check_game_over)
    end

    it 'sends #draw_board to Display' do
      allow(board).to receive(:promotion?).with(game.new_move)

      expect(display).to receive(:draw_board).with(board)
      game.turn_sequence
    end

    context 'when pawn promotion condition is true' do
      it 'sends Board#promote_pawn' do
        allow(board).to receive(:promotion?).with(game.new_move).and_return(true)

        expect(board).to receive(:promote_pawn)
        game.turn_sequence
      end
    end

    context 'when pawn promotion condition is false' do
      it 'does not send Board#promote_pawn' do
        allow(board).to receive(:promotion?).with(game.new_move).and_return(false)

        expect(board).not_to receive(:promote_pawn)
        game.turn_sequence
      end
    end

    it 'sends #add to MoveList' do
      allow(board).to receive(:promotion?).with(game.new_move)
      expect(move_list).to receive(:add).with(game.new_move)
      game.turn_sequence
    end
  end

  describe '#produce_legal_move' do
    before do
      allow(game).to receive(:validate_turn_input)
      allow(game).to receive(:create_move)
      allow(game.current_player).to receive(:color)
      allow(game).to receive(:revert_board)
      allow(game).to receive(:revert_board)
    end

    context 'when new_move is valid' do
      it 'sends #transfer_piece to Move' do
        serialized_board = 'json_string'
        allow(game.new_move).to receive(:validated).and_return(true)
        allow(game.board).to receive(:check?).and_return(false)
        expect(game.new_move).to receive(:transfer_piece)
        game.produce_legal_move(serialized_board)
      end
    end

    context 'when new_move is invalid then valid' do
      it 'receives #invalid_input_message once' do
        serialized_board = 'json_string'
        allow(game.new_move).to receive(:validated).and_return(false, true)
        allow(game.board).to receive(:check?).and_return(true, false)
        allow(game.new_move).to receive(:transfer_piece)
        expect(game.display).to receive(:invalid_input_message).exactly(1).time
        game.produce_legal_move(serialized_board)
      end
    end
  end

  describe '#set_current_player' do
    it 'sets current_player to player1 when move_list is even' do
      allow(game.move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(true)
      game.set_current_player
      expect(game.current_player).to be game.player1
    end

    it 'does NOT set current_player to player1 when move_list is odd' do
      allow(game.move_list).to receive_message_chain(:all_moves, :length, :even?).and_return(false)
      game.set_current_player
      expect(game.current_player).not_to be game.player1
    end
  end

  describe '#switch_players' do
    it 'changes current_player' do
      curr_plyr = game.instance_variable_get(:@current_player)
      game.switch_players
      expect(game.current_player).not_to be curr_plyr
    end
  end

  describe '#other_player' do
    it 'returns player who is not current_player' do
      curr_play = game.instance_variable_get(:@current_player)
      expect(game.other_player).not_to be curr_play
    end
  end

  describe '#check_draw' do
    # Calls self, no testing required
  end

  describe '#three_fold_repetition?' do
    context 'when move_list contains fewer than 12 moves' do
      it 'returns false' do
        short_mv_list = %w[Rc3d3 Rf6g6 Rd3c3]
        allow(move_list).to receive(:all_moves).and_return(short_mv_list)

        expect(game.three_fold_repetition?).to be false
      end
    end

    context 'when move_list contains 12 or more moves' do
      context 'when the last 12 moves show a 3-fold repetition' do
        it 'returns true' do
          mv_list_with_repetition = %w[Rc3d3 Rf6g6 Rd3c3 Rg6f6 Rc3d3 Rf6g6 Rd3c3 Rg6f6 Rc3d3 Rf6g6 Rd3c3 Rg6f6]

          allow(move_list).to receive(:all_moves).and_return(mv_list_with_repetition)
          expect(game.three_fold_repetition?).to be true
        end
      end

      context 'when the last 12 moves do not show a 3-fold repetition' do
        it 'returns false' do
          mv_list_no_repetition = %w[Pd2d4 Pd7d5 Pe2e4 Nb8c6 Bf1b5 Bc8f5 Bb5xc6+
                                     Pb7xc6 Pe4xd5 Qd8xd5 Qd1g4 Qd5xd4 Ng1f3 Bf5xc2]

          allow(move_list).to receive(:all_moves).and_return(mv_list_no_repetition)
          expect(game.three_fold_repetition?).to be false
        end
      end
    end
  end

  describe '#insufficient_material?' do
    it 'sends #names_of_pcs_remaining to Board' do
      pieces = [King, Queen, King]

      expect(board).to receive(:names_of_pcs_remaining).and_return(pieces)
      game.insufficient_material?
    end

    it 'returns true when pieces remaining are: King, King' do
      two_pieces = [King, King]

      expect(board).to receive(:names_of_pcs_remaining).and_return(two_pieces)
      game.insufficient_material?
    end

    it 'returns true when pieces remaining are: King, King, Bishop' do
      three_pieces = [King, King, Bishop]

      expect(board).to receive(:names_of_pcs_remaining).and_return(three_pieces)
      game.insufficient_material?
    end

    it 'returns true when pieces remaining are: Bishop, King, King (switched order)' do
      three_pieces = [Bishop, King, King]

      expect(board).to receive(:names_of_pcs_remaining).and_return(three_pieces)
      game.insufficient_material?
    end

    it 'returns true when pieces remaining are: King, King, Knight' do
      three_pieces = [King, King, Knight]

      expect(board).to receive(:names_of_pcs_remaining).and_return(three_pieces)
      game.insufficient_material?
    end


    context 'when there are at least 4 pieces left' do
      it 'returns false when there are 4 pieces' do
        four_pieces = [King, Rook, King, Bishop]
        expect(board).to receive(:names_of_pcs_remaining).and_return(four_pieces)

        result = game.insufficient_material?
        expect(result).to be false
      end

      it 'returns false when there are 5 pieces' do
        five_pieces = [King, Pawn, King, Pawn, Pawn]
        expect(board).to receive(:names_of_pcs_remaining).and_return(five_pieces)

        result = game.insufficient_material?
        expect(result).to be false
      end
    end
  end

  describe '#fifty_move_rule?' do
    context 'when a Pawn moved or a capture was made in the last 50 moves' do
      # let(:move_list_fifty) { instance_double('MoveList') }

      it 'returns false' do
        fifty_moves_not_a_draw = %w[Pd2d4 Pd7d5 Pe2e4 Pe7e5 Bc1f4 Qd8d6 Pd4xe5
                                    Qd6b6 Pe5e6 Pd5xe4 Bf1c4 Qb6xb2 Nb1c3 Nb8c6
                                    Pe6e7 Bf8xe7 Ng1h3 Ng8f6 0-0 Pa7a5 Ra1b1 Qb2xc3
                                    Rf1e1 Qc3xc4 Nh3g5 Qc4xa2 Ng5xe4 Nf6xe4 Re1xe4
                                    Bc8f5 Rb1xb7 0-0-0 Qd1e1 Nc6b4 Pg2g4 Qa2xc2
                                    Re4xe7 Nb4d3 Qe1e3 Qc2d1+ Kg1g2 Qd1xg4+ Bf4g3
                                    Nd3e1+ Qe3xe1 Rd8d3 Rb7xc7+ Kc8b8 Rc7c4+ Qg4g3]
        allow(move_list).to receive(:all_moves).and_return(fifty_moves_not_a_draw)

        result = game.fifty_move_rule?
        expect(result).to eq false
      end
    end

    context 'when neither a Pawn moved nor any capture was made in the last 50 moves' do
      it 'returns true' do
        fifty_moves_draw = %w[Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1c3 Nb3c1
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1c3 Nb3c1
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1e5 Nb3c1
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1c3 Nb3c1
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1f6 Nb3c1
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1c3 Nb3e5
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1e5 Nb3c1
                              Bb2d4 Nc1b3 Bd4e5 Nb3c5 Be5a1 Nc5b3 Ba1a1 Nb3c1]
        allow(move_list).to receive(:all_moves).and_return(fifty_moves_draw)

        result = game.fifty_move_rule?
        expect(result).to eq true
      end
    end
  end

  describe '#all_pieces_stuck?' do
  
  end

  describe 'checkmate_seq' do
    it 'sends #test_checkmate_other_player to Move' do
      allow_message_expectations_on_nil
      allow(game.new_move).to receive(:checkmates).and_return(false)
      expect(game.new_move).to receive(:test_checkmate_other_player)
      game.checkmate_seq
    end
  end

  describe '#win' do
    before do
      allow(display).to receive(:draw_board).with(board)
      allow(display).to receive(:win).with(player1)
    end

    it 'returns true for @game_end' do
      game.win(player1)
      expect(game.game_end).to be true
    end
  end

  describe '#tie' do
    it 'returns true for @game_end' do
      game.tie
      expect(game.game_end).to be true
    end
  end

  describe '#game_over?' do
    # calls method within class, ignore
  end

  describe '#play_again_init' do
    it 'sets @game_end to false' do
      allow(game.move_list).to receive(:set)
      allow(game).to receive(:set_current_player)
      game.play_again_init(board)
      expect(game.game_end).to be false
    end

    it 'sets @board to board' do
      allow(game.move_list).to receive(:set)
      allow(game).to receive(:set_current_player)
      game.play_again_init(board)
      expect(game.board).to be board
    end

    it 'sets move_list to an empty array' do
      allow(game).to receive(:set_current_player)
      expect(move_list).to receive(:set).with(kind_of(Array))
      game.play_again_init(board)
    end
  end
end
