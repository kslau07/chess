# frozen_string_literal: true

require_relative '../lib/check'
require_relative '../lib/piece'
require_relative '../lib/board'
require_relative '../lib/pieces/king'

describe Check do
  subject(:class_instance) { Class.new.include(described_class).new }
  let(:player) { instance_double('Player') }

  # We need a bool val, test both cases
  describe '#check?' do
    context 'when there exists a path for enemy to check king' do
      it 'returns true' do
        kings_sq = [0, 4]
        check_paths = [['check path 1'], ['check path 2']]
        allow(player).to receive(:color).and_return('white')
        allow(class_instance).to receive(:square_of_king).and_return(kings_sq)
        allow(class_instance).to receive(:find_check_paths).and_return(check_paths)

        # How do we take control of iteration on pipe variables and stub a return
        # value?

        # In this case, the message send #path_obstructed? did not specify a
        # a receiver, so the receiver was implicit (self). We can take control
        # of this method call using allow with class under test (class_instance).
        allow(class_instance).to receive(:path_obstructed?).and_return(false, false)

        result = class_instance.check?(player.color)
        expect(result).to be true
      end
    end

    context 'when no check paths exist' do
      it 'returns false' do
        kings_sq = [0, 4]
        check_paths = [] # no paths
        allow(player).to receive(:color).and_return('white')
        allow(class_instance).to receive(:square_of_king).and_return(kings_sq)
        allow(class_instance).to receive(:find_check_paths).and_return(check_paths)

        # We were going to stub the method call inside the iterator, but the
        # block is not run if Array is empty. (path_obstructed? is not called)
        # allow(class_instance).to receive(:path_obstructed?).and_return()

        result = class_instance.check?(player.color)
        expect(result).to be false
      end
    end
  end

  describe '#find_check_paths' do
    context 'when next square is an enemy piece' do
      let(:wht_bishop) { instance_double('Bishop', color: 'white') }
      bishops_check_path = [[4, 7], [5, 6], [6, 5], [7, 4]]
      next_square = [[4, 7]]
      player_color = 'black'
      kings_sq = [7, 4]

      it 'sends #object to Board (self)' do
        allow(class_instance).to receive(:object).and_return(wht_bishop)
        allow(class_instance).to receive(:squares).and_return(next_square)
        allow(class_instance).to receive(:enemy_piece?).and_return(true)
        allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

        expect(class_instance).to receive(:object).twice
        class_instance.find_check_paths(player_color, kings_sq)
      end

      it 'sends #make_capture_path to enemy_piece' do
        allow(class_instance).to receive(:object).and_return(wht_bishop)
        allow(class_instance).to receive(:squares).and_return(next_square)
        allow(class_instance).to receive(:enemy_piece?).and_return(true)

        expect(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)
        class_instance.find_check_paths(player_color, kings_sq)
      end

      context 'when enemy piece has 1 path that can reach the king' do
        it 'returns an Array' do
          allow(class_instance).to receive(:object).and_return(wht_bishop)
          allow(class_instance).to receive(:squares).and_return(next_square)
          allow(class_instance).to receive(:enemy_piece?).and_return(true)
          allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

          result = class_instance.find_check_paths(player_color, kings_sq)
          expect(result).to be_instance_of(Array)
        end

        it 'returns an Array with size of 1' do
          allow(class_instance).to receive(:object).and_return(wht_bishop)
          allow(class_instance).to receive(:squares).and_return(next_square)
          allow(class_instance).to receive(:enemy_piece?).and_return(true)
          allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

          result = class_instance.find_check_paths(player_color, kings_sq)
          expect(result.size).to eq 1
        end
      end

      context 'when enemy piece has no paths that can reach the king' do
        it 'returns an empty Array' do
          no_paths = []
          allow(class_instance).to receive(:object).and_return(wht_bishop)
          allow(class_instance).to receive(:squares).and_return(next_square)
          allow(class_instance).to receive(:enemy_piece?).and_return(true)
          allow(wht_bishop).to receive(:make_capture_path).and_return(no_paths)

          result = class_instance.find_check_paths(player_color, kings_sq)
          expect(result).to be_empty
        end
      end
    end

    context 'when next square is a friendly piece' do
      let(:blk_pawn) { instance_double('Pawn', color: 'black') }
      # bishops_check_path = [[4, 7], [5, 6], [6, 5], [7, 4]]
      next_square = [[6, 1]]
      player_color = 'black'
      kings_sq = [7, 4]

      it 'sends #object to Board (self) only once' do
        allow(class_instance).to receive(:object).and_return(blk_pawn)
        allow(class_instance).to receive(:squares).and_return(next_square)
        allow(class_instance).to receive(:enemy_piece?).and_return(false)
        # allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

        expect(class_instance).to receive(:object).once
        class_instance.find_check_paths(player_color, kings_sq)
      end

      it 'does not send #make_capture_path to enemy_piece' do
        allow(class_instance).to receive(:object).and_return(blk_pawn)
        allow(class_instance).to receive(:squares).and_return(next_square)
        allow(class_instance).to receive(:enemy_piece?).and_return(false)
        # allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

        expect(class_instance).not_to receive(:make_capture_path)
        # expect(class_instance).to receive(:object).once
        class_instance.find_check_paths(player_color, kings_sq)
      end
    end

    context 'when there is 1 path that checks player\'s King' do
      let(:wht_bishop) { instance_double('Bishop', color: 'white') }
      bishops_check_path = [[4, 7], [5, 6], [6, 5], [7, 4]]
      next_square = [[4, 7]]
      player_color = 'black'
      kings_sq = [7, 4]

      matcher :contain_one_array do
        match do |ary|
          n = 0
          ary.each do |elem|
            n += 1 if elem.instance_of?(Array)
          end
          n == 1
        end
      end

      it 'includes 1 Array' do
        allow(class_instance).to receive(:object).and_return(wht_bishop)
        allow(class_instance).to receive(:squares).and_return(next_square)
        allow(class_instance).to receive(:enemy_piece?).and_return(true)
        allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

        result = class_instance.find_check_paths(player_color, kings_sq)
        expect(result).to contain_one_array
      end
    end

    context 'when there are 2 paths that check player\'s King' do
      let(:wht_bishop) { instance_double('Bishop', color: 'white') }
      let(:wht_rook) { instance_double('Rook', color: 'white') }
      bishops_check_path = [[4, 7], [5, 6], [6, 5], [7, 4]]
      rooks_check_path = [[4, 4], [5, 4], [6, 4], [7, 4]]
      next_two_squares = [[4, 7], [4, 4]]
      player_color = 'black'
      kings_sq = [7, 4]

      matcher :contain_two_arrays do
        match do |ary|
          n = 0
          ary.each do |elem|
            n += 1 if elem.instance_of?(Array)
          end
          n == 2
        end
      end

      it 'includes 2 Arrays' do
        allow(class_instance).to receive(:object).and_return(wht_bishop, wht_rook)
        allow(class_instance).to receive(:squares).and_return(next_two_squares)
        allow(class_instance).to receive(:enemy_piece?).and_return(true)
        allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)
        allow(wht_rook).to receive(:make_capture_path).and_return(rooks_check_path)

        result = class_instance.find_check_paths(player_color, kings_sq)
        expect(result).to contain_two_arrays
      end
    end

    context 'when no paths exist that can check player\'s King' do
      # let(:wht_bishop) { instance_double('Bishop', color: 'white') }
      # bishops_check_path = [[4, 7], [5, 6], [6, 5], [7, 4]]
      next_square = [[4, 3]]
      player_color = 'black'
      kings_sq = [7, 4]

      it 'returns an empty Array' do
        allow(class_instance).to receive(:object).and_return('unoccupied')
        allow(class_instance).to receive(:squares).and_return(next_square)
        allow(class_instance).to receive(:enemy_piece?).and_return(false)
        # allow(wht_bishop).to receive(:make_capture_path).and_return(bishops_check_path)

        result = class_instance.find_check_paths(player_color, kings_sq)
        expect(result).to be_empty
      end
    end
  end

  describe '#square_of_king' do
    next_square = [[0, 4]]

    before(:each) do
      allow(class_instance).to receive(:squares).and_return(next_square)
    end

    context 'when next square is a King' do
      wht_king = King.new(color: 'white') # use real object because method uses instance_of?

      it 'returns location of king [0, 4] if color matches player color' do
        player_color = 'white'
        allow(class_instance).to receive(:object).and_return(wht_king)
        result = class_instance.square_of_king(player_color)
        expect(result).to eq [0, 4]
      end

      it 'returns nil if not player\'s color' do
        player_color = 'black'
        allow(class_instance).to receive(:object).and_return(wht_king)
        result = class_instance.square_of_king(player_color)
        expect(result).to be_nil
      end
    end

    context 'when next square is not a King' do
      it 'returns nil' do
        player_color = 'black'
        allow(class_instance).to receive(:object).and_return('unoccupied')
        result = class_instance.square_of_king(player_color)
        expect(result).to be_nil
      end
    end
  end

  describe '#checkmate?' do
    context 'if King cannot move' do
      let(:player) { instance_double('Player', color: 'black') }
      let(:blk_king) { instance_double('King', color: 'black') }
      kings_sq = [7, 4]

      before(:each) do
        allow(class_instance).to receive(:king_cannot_move?).and_return(true)
      end

      it 'returns true if another piece cannot remove the check (indefensible)' do
        allow(class_instance).to receive(:square_of_king).and_return(kings_sq)
        allow(class_instance).to receive(:object).and_return(blk_king)
        allow(class_instance).to receive(:king_not_defendable?).and_return(true)
        move_data = { player: player }

        result = class_instance.checkmate?(move_data)
        expect(result).to be true
      end

      it 'returns false if check can be removed by another piece' do
        allow(class_instance).to receive(:square_of_king).and_return(kings_sq)
        allow(class_instance).to receive(:object).and_return(blk_king)
        allow(class_instance).to receive(:king_not_defendable?).and_return(false)
        move_data = { player: player }

        result = class_instance.checkmate?(move_data)
        expect(result).to be false
      end
    end

    context 'if King can remove check by itself' do
      let(:player) { instance_double('Player', color: 'black') }
      let(:blk_king) { instance_double('King', color: 'black') }
      kings_sq = [7, 4]

      it 'returns false' do
        allow(class_instance).to receive(:square_of_king).and_return(kings_sq)
        allow(class_instance).to receive(:object).and_return(blk_king)
        allow(class_instance).to receive(:king_cannot_move?).and_return(false)
        move_data = { player: player }

        result = class_instance.checkmate?(move_data)
        expect(result).to be false
      end
    end
  end

  # describe '#king_cannot_move?' do
  #   let(:king) { instance_double('King', color: 'white') }
  #   kings_sq = [7, 4]
  #   move_data = {}
  #   k_possible_moves = [[1, 0], [1, 1],
  #                       [0, 1], [-1, 1],
  #                       [-1, 0], [-1, -1],
  #                       [0, -1], [1, -1]].freeze

  #   before do
  #     allow(king).to receive(:possible_moves).and_return(k_possible_moves)
  #   end

  #   context 'when King has at least 1 legal move' do
  #     it 'returns false' do
  #       allow(class_instance).to receive(:out_of_bound?).and_return(false)
  #       allow(class_instance).to receive(:legal_move?).and_return(true)

  #       result = class_instance.king_cannot_move?(king, kings_sq, move_data)
  #       expect(result).to be false
  #     end
  #   end

  #   context 'when King has no legal moves' do
  #     it 'returns true' do
  #       allow(class_instance).to receive(:out_of_bound?).and_return(false)
  #       allow(class_instance).to receive(:legal_move?).and_return(false)

  #       result = class_instance.king_cannot_move?(king, kings_sq, move_data)
  #       expect(result).to be true
  #     end
  #   end
  # end

  # describe '#king_not_defendable?' do
  #   board = Board.new
  #   board.create_new_grid
  #   board.grid[7][4] = board.blk_king
  #   board.grid[6][6] = board.blk_pawn
  #   board.grid[4][7] = board.wht_bishop

  #   context 'when black King is checked by white Bishop' do
  #     color = 'black'
  #     kings_sq = [7, 4]
  #     move_data = {}
  #     single_check_path = [[4, 7], [5, 6], [6, 5], [7, 4]]

  #     before do
  #       allow(class_instance).to receive(:find_check_paths).with(color, kings_sq).and_return(single_check_path)
  #       allow(class_instance).to receive(:grid).and_return(board.grid)
  #     end

  #     context 'when black Pawn can remove check by white Bishop' do
  #       it 'returns false' do
  #         allow(class_instance).to receive(:legal_move?).and_return(true)

  #         result = class_instance.king_not_defendable?(color, kings_sq, move_data)
  #         expect(result).to be false
  #       end
  #     end

  #     context 'when black Pawn cannot remove check by white Bishop' do
  #       it 'returns true' do
  #         allow(class_instance).to receive(:legal_move?).and_return(false)

  #         result = class_instance.king_not_defendable?(color, kings_sq, move_data)
  #         expect(result).to be true
  #       end
  #     end
  #   end
  # end

  describe '#legal_move?' do
    context 'change me' do
      xit 'change me' do
        result = class_instance.method_call
        expect(result).to eq 'abcd'
      end
    end
  end
end
