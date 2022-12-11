# frozen_string_literal: true

require_relative '../lib/save_load'
require 'json'

describe SaveLoad do
  subject(:class_instance) { Class.new.include(described_class).new }

  describe '#save_game_file' do
    # Only calls self, no testing required
  end

  describe '#load_game_file' do
    let(:board) { double('Board') }
    let(:move_list) { double('MoveList') }

    context 'when there are no saved game files found' do
      it 'returns nil' do
        allow(class_instance).to receive(:show_saved_games).and_return(nil)
        allow(class_instance).to receive(:choose_file).and_return(nil)

        result = class_instance.load_game_file(board, move_list)
        expect(result).to be_nil
      end
    end

    context 'when there are saved game files in the directory' do
      it 'returns an Array' do
        file_list = ['saved game object', 'saved game object']
        fname = 'name of file'
        json_obj = 'json string'
        mv_list = ''
        allow(class_instance).to receive(:show_saved_games).and_return(file_list)
        allow(class_instance).to receive(:choose_file).and_return(fname)
        allow(class_instance).to receive(:read_file).and_return(json_obj)
        allow(class_instance).to receive(:load_move_list).and_return(mv_list)
        allow(class_instance).to receive(:load_board)
        allow(class_instance).to receive(:puts)

        result = class_instance.load_game_file(board, move_list)
        expect(result).to eq([board, move_list])
      end
    end
  end

  describe '#show_saved_games' do
    class String; def magenta; end; end # override frozen obj

    it 'sends :glob to Dir' do
      allow(class_instance).to receive(:puts)

      expect(Dir).to receive_message_chain(:glob, :map, :with_index)
      class_instance.show_saved_games
    end
  end

  describe '#choose_file' do
    context 'when file list is empty' do
      it 'returns nil when file list is empty' do
        allow(class_instance).to receive(:puts)
        allow(class_instance).to receive(:validate_choose_file_input)
        f_list = []
        result = class_instance.choose_file(f_list)
        expect(result).to be_nil
      end
    end

    context 'when file list is not empty' do
      context 'when 2nd file is selected from given list' do
        it 'returns \'2022oct03_0730pm\'' do
          allow(class_instance).to receive(:puts)
          allow(class_instance).to receive(:validate_choose_file_input).and_return(2)
          f_list = ["2022nov14_0624pm", "2022oct03_0730pm", "2022oct03_1049pm",
                    "2022oct03_1203pm", "2022oct10_0329pm"]

          result = class_instance.choose_file(f_list)
          expect(result).to eq('2022oct03_0730pm')
        end
      end
    end
  end

  describe '#validate_choose_file_input' do
    context 'when user enters bad input twice, then good input on 3rd try' do
      it 'receives invalid input string twice' do
        bad_input = 'z'
        bad_input2 = ''
        good_input = '3'
        allow(class_instance).to receive(:gets).and_return(bad_input, bad_input2, good_input)
        f_list = ["2022nov14_0624pm", "2022oct03_0730pm", "2022oct03_1049pm",
                  "2022oct03_1203pm", "2022oct10_0329pm"]

        invalid_input_string = 'Invalid input! Choose a file to load.'
        expect(class_instance).to receive(:puts).with(invalid_input_string).twice
        class_instance.validate_choose_file_input(f_list)
      end
    end

    context 'when user enters good input on 1st try' do
      it 'does not receive invalid input string' do
        good_input = '3'
        allow(class_instance).to receive(:gets).and_return(good_input)
        f_list = ["2022nov14_0624pm", "2022oct03_0730pm", "2022oct03_1049pm",
                  "2022oct03_1203pm", "2022oct10_0329pm"]

        invalid_input_string = 'Invalid input! Choose a file to load.'
        expect(class_instance).not_to receive(:puts).with(invalid_input_string)
        class_instance.validate_choose_file_input(f_list)
      end
    end
  end

  describe '#serialize_game_objects' do
    let(:board) { double('Board') }
    let(:move_list) { double('MoveList') }

    before do
      allow(class_instance).to receive(:board).and_return(board)
      allow(class_instance).to receive(:move_list).and_return(move_list)
    end

    it 'returns an array containing a MoveList json and a Board json' do
      move_list_json = 'mv list str'
      board_json = 'board str'
      allow(move_list).to receive(:serialize).and_return(move_list_json)
      allow(board).to receive(:serialize).and_return(board_json)

      result = class_instance.serialize_game_objects
      expect(result).to eq([move_list_json, board_json])
    end
  end

  describe '#save_to_file' do
    move_list_json = 'json str'
    board_json = 'json str'
    json_obj_ary = [move_list_json, board_json]

    it 'sends #open to File' do
      allow(File).to receive(:exist?).and_return(true)

      expect(File).to receive(:open)
      class_instance.save_to_file(json_obj_ary)
    end

    context 'when directory does not exist' do
      it 'sends #mkdir to Dir' do
        allow(File).to receive(:exist?).and_return(false)
        allow(File).to receive(:open)

        expect(Dir).to receive(:mkdir).once
        class_instance.save_to_file(json_obj_ary)
      end
    end

    context 'when directory already exists' do
      it 'does not send #mkdir to Dir' do
        allow(File).to receive(:exist?).and_return(true)
        allow(File).to receive(:open)

        expect(Dir).not_to receive(:mkdir)
        class_instance.save_to_file(json_obj_ary)
      end
    end

    # Delete this test, but remember that you cannot take control of a variable
    # by trying to fake it directly if it is set inside the method. You cannot
    # control 'time' directly, but you can control what it is set to.
    # context 'change me' do
    #   let(:time) { double('Time') }

    #   before do
    #     allow(Time).to receive(:new).and_return(time)
    #     allow(time).to receive_message_chain(:strftime, :downcase).and_return('2022dec11_0249pm')
    #   end

    #   xit 'delete me' do
    #     move_list_json = 'json str'
    #     board_json = 'json str'
    #     json_obj_ary = [move_list_json, board_json]

    #     expect(class_instance.time_str).to be('2022dec11_0249pm')
    #     class_instance.save_to_file(json_obj_ary)
    #   end
    # end
  end

  describe '#load_move_list' do
    let(:move_list_object) { instance_double('MoveList') }

    it 'sends #parse twice to JSON' do
      mv_list_json_str = 'json string'
      move_list = move_list_object
      allow(move_list).to receive(:set).once

      expect(JSON).to receive(:parse).twice
      class_instance.load_move_list(mv_list_json_str, move_list)
    end

    it 'sends #set to move_list' do
      mv_list_json_str = 'json string'
      move_list = move_list_object
      allow(JSON).to receive(:parse).twice

      expect(move_list).to receive(:set).once
      class_instance.load_move_list(mv_list_json_str, move_list)
    end
  end

  describe '#load_board' do
    
  end

  describe '#instantiate_board_piece' do

  end

  describe '#read_file' do

  end
end
