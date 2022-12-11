# frozen_string_literal: true

require_relative '../lib/chess_tools'
require_relative '../lib/display'
require_relative '../lib/piece'
require_relative '../lib/pieces/rook'
require_relative '../lib/pieces/pawn'


describe ChessTools do
  subject(:class_instance) { Class.new.include(described_class).new }

  describe '#base_move' do
    context 'when color is white' do
      context 'when start square is [0, 0]' do
        begin_sq = [0, 0]

        it 'returns [1, 0] if end square is [1, 0]' do
          finish_sq = [1, 0]
          color = 'white'

          result = class_instance.base_move(begin_sq, finish_sq, color)
          expect(result).to eq([1, 0])
        end

        it 'returns [0, 7] if end square is [0, 7]' do
          finish_sq = [0, 7]
          color = 'white'

          result = class_instance.base_move(begin_sq, finish_sq, color)
          expect(result).to eq([0, 7])
        end
      end

      context 'when start square is [2, 4]' do
        begin_sq = [2, 4]

        it 'returns [3, -3] if end square is [5, 1]' do
          finish_sq = [5, 1]
          color = 'white'

          result = class_instance.base_move(begin_sq, finish_sq, color)
          expect(result).to eq([3, -3])
        end

        it 'returns [-2, 0] if end square is [5, 1]' do
          finish_sq = [0, 4]
          color = 'white'

          result = class_instance.base_move(begin_sq, finish_sq, color)
          expect(result).to eq([-2, 0])
        end
      end
    end

    context 'when color is black' do
      context 'when start square is [7, 4]' do
        begin_sq = [7, 4]

        it 'returns [1, 1] if end square is [6, 3]' do
          finish_sq = [6, 3]
          color = 'black'

          result = class_instance.base_move(begin_sq, finish_sq, color)
          expect(result).to eq([1, 1])
        end

        it 'returns [5, 0] if end square is [2, 4]' do
          finish_sq = [2, 4]
          color = 'black'

          result = class_instance.base_move(begin_sq, finish_sq, color)
          expect(result).to eq([5, 0])
        end
      end
    end
  end

  describe '#out_of_bound?' do
    let(:board) { instance_double('Board') }

    def board_squares
      arr_of_squares = []
      8.times do |x|
        8.times do |y|
          arr_of_squares << [x, y]
        end
      end
      arr_of_squares
    end

    context 'when start square is inbounds' do
      start_sq = [0, 0]

      it 'returns false when end square is also inbounds, [1, 1]' do
        end_sq = [1, 1]
        allow(board).to receive(:squares).and_return(board_squares)

        result = class_instance.out_of_bound?(board, start_sq, end_sq)
        expect(result).to be(false)
      end

      it 'returns true when end square is out of bounds, [8, 8]' do
        end_sq = [8, 8]
        allow(board).to receive(:squares).and_return(board_squares)

        result = class_instance.out_of_bound?(board, start_sq, end_sq)
        expect(result).to be(true)
      end

      it 'returns true when end square is out of bounds, [-100, -100]' do
        end_sq = [-100, -100]
        allow(board).to receive(:squares).and_return(board_squares)

        result = class_instance.out_of_bound?(board, start_sq, end_sq)
        expect(result).to be(true)
      end

      it 'returns true when end square is out of bounds, [150, 0]' do
        end_sq = [150, 0]
        allow(board).to receive(:squares).and_return(board_squares)

        result = class_instance.out_of_bound?(board, start_sq, end_sq)
        expect(result).to be(true)
      end
    end
  end

  describe '#translate_notation_to_square_index' do
    it 'returns [2, 2] when cleaned move string is \'Bb4c3\'' do
      cleaned_move_str = 'Bb4c3'
      result = class_instance.translate_notation_to_square_index(cleaned_move_str)
      expect(result).to eq([2, 2])
    end

    it 'returns [3, 7] when cleaned move string is \'Ph2h4\'' do
      cleaned_move_str = 'Ph2h4'
      result = class_instance.translate_notation_to_square_index(cleaned_move_str)
      expect(result).to eq([3, 7])
    end
  end

  describe '#opposing_color' do
    it 'returns \'white\' when color is \'black\'' do
      color = 'black'
      result = class_instance.opposing_color(color)
      expect(result).to eq('white')
    end

    it 'returns \'black\' when color is \'white\'' do
      color = 'white'
      result = class_instance.opposing_color(color)
      expect(result).to eq('black')
    end
  end

  describe '#validate_turn_input' do
    let(:display) { class_double('Display').as_stubbed_const }
    let(:board) { instance_double('Board') }

    context 'when user enters \'e5c3\' (good input) on the first try' do
      it 'sends #turn_messsage once to Display' do
        color = 'black'
        good_input = 'e5c3'
        allow(class_instance).to receive_message_chain(:current_player, :color).and_return(color)
        allow(class_instance).to receive(:board).and_return(board)
        allow(class_instance).to receive(:gets).and_return(good_input)
        allow(class_instance).to receive(:verify_input).with(good_input).and_return([[4, 4], [2, 2]])

        expect(display).to receive(:turn_message).once
        class_instance.validate_turn_input
      end

      it 'returns an Array containing [[4, 4], [2, 2]]' do
        color = 'black'
        good_input = 'e5c3'
        allow(display).to receive(:turn_message)
        allow(class_instance).to receive_message_chain(:current_player, :color).and_return(color)
        allow(class_instance).to receive(:board).and_return(board)
        allow(class_instance).to receive(:gets).and_return(good_input)
        allow(class_instance).to receive(:verify_input).with(good_input).and_return([[4, 4], [2, 2]])

        result = class_instance.validate_turn_input
        expect(result).to eq([[4, 4], [2, 2]])
      end
    end

    context 'when user enters bad input first, then good input second' do
      it 'sends #turn_messsage twice to Display' do
        color = 'black'
        bad_input = 'zebra'
        good_input = 'e5c3'
        allow(display).to receive(:turn_message)
        allow(class_instance).to receive_message_chain(:current_player, :color).and_return(color)
        allow(class_instance).to receive(:board).and_return(board)
        allow(class_instance).to receive(:gets).and_return(bad_input, good_input)
        allow(class_instance).to receive(:verify_input).and_return(nil, [[4, 4], [2, 2]])

        expect(display).to receive(:turn_message).twice
        class_instance.validate_turn_input
      end
    end
  end

  describe '#verify_input' do
    let(:display) { class_double('Display').as_stubbed_const }

    context 'when user input is \'menu\'' do
      it 'calls #midgame_menu' do
        user_input_menu = 'menu'

        expect(class_instance).to receive(:midgame_menu)
        class_instance.verify_input(user_input_menu)
      end
    end

    context 'when user input is \'zebra\' (bad input)' do
      it 'sends #invalid_input_message to Display' do
        bad_input = 'zebra'

        expect(display).to receive(:invalid_input_message)
        class_instance.verify_input(bad_input)
      end
    end

    context 'when user input is \'i7j2\' (bad input)' do
      it 'sends #invalid_input_message to Display' do
        bad_input = 'i7j2'

        expect(display).to receive(:invalid_input_message)
        class_instance.verify_input(bad_input)
      end
    end

    context 'when user input is \'b8c6\' (good input)' do
      it 'calls #convert_to_squares' do
        good_input = 'b8c6'

        expect(class_instance).to receive(:convert_to_squares)
        class_instance.verify_input(good_input)
      end
    end

    context 'when user input is \'h3a3\' (good input)' do
      it 'calls #convert_to_squares' do
        good_input = 'h3a3'

        expect(class_instance).to receive(:convert_to_squares)
        class_instance.verify_input(good_input)
      end
    end

    context 'when user input is \'h7a1\' (good input)' do
      it 'calls #convert_to_squares' do
        good_input = 'h7a1'

        expect(class_instance).to receive(:convert_to_squares)
        class_instance.verify_input(good_input)
      end
    end

    context 'when user input is blank (bad input)' do
      it 'sends #invalid_input_message to Display' do
        bad_input = ''

        expect(display).to receive(:invalid_input_message)
        class_instance.verify_input(bad_input)
      end
    end
  end

  describe '#convert_to_squares' do
    context 'change me' do
      user_input = 'f3f8'
      returned_start_sq = [2, 5]
      returned_end_sq = [7, 5]

      before(:each) do
        allow(class_instance).to receive(:translate_notation_to_square_index).and_return(returned_start_sq, returned_end_sq)
      end

      it 'returns an Array' do
        result = class_instance.convert_to_squares(user_input)
        expect(result).to be_instance_of(Array)
      end

      it 'returns [[2, 5], [7, 5]]' do
        result = class_instance.convert_to_squares(user_input)
        expect(result).to eq([[2, 5], [7, 5]])
      end
    end
  end

  describe '#pass_prelim_check?' do
    let(:board) { instance_double('Board') }
    current_player_color = 'black'

    before(:each) do
      allow(class_instance).to receive(:board).and_return(board)
      allow(class_instance).to receive_message_chain(:current_player, :color).and_return(current_player_color)
    end

    it 'returns false if out of bounds' do
      start_sq = [0, 0]
      end_sq = [-1, 2]
      allow(class_instance).to receive(:out_of_bound?).with(board, start_sq, end_sq).and_return(true)

      result = class_instance.pass_prelim_check?(start_sq, end_sq)
      expect(result).to be(false)
    end

    context 'when start square\'s piece\'s color is same as end square\'s piece\'s color' do
      it 'returns false' do
        start_sq = [7, 7]
        end_sq = [4, 7]
        allow(class_instance).to receive(:out_of_bound?).with(board, start_sq, end_sq).and_return(false)
        blk_rook = Rook.new(color: 'black') # real obj required in test
        allow(board).to receive(:object).and_return(blk_rook)

        result = class_instance.pass_prelim_check?(start_sq, end_sq)
        expect(result).to be(false)
      end
    end

    context 'when start square contains a piece and it\'s the same as player\'s color' do
      it 'returns true' do
        start_sq = [6, 1]
        end_sq = [5, 1]
        allow(class_instance).to receive(:out_of_bound?).with(board, start_sq, end_sq).and_return(false)
        allow(board).to receive(:object).with(end_sq).and_return('unoccupied')
        blk_pawn = Pawn.new(color: 'black')
        allow(board).to receive(:object).with(start_sq).and_return(blk_pawn)

        result = class_instance.pass_prelim_check?(start_sq, end_sq)
        expect(result).to be(true)
      end
    end
  end
end
