# frozen_string_literal: true

require_relative '../lib/board'

describe Board do
  subject(:board) { described_class.new }

  attr_reader :wht_pawn, :wht_bishop, :wht_rook, :wht_knight, :wht_queen,
              :wht_king, :blk_pawn, :blk_bishop, :blk_rook, :blk_knight,
              :blk_queen, :blk_king

  describe '#squares' do
    it 'returns an array containing 64 elements' do
      result = board.squares
      expect(result).to be_instance_of Array
      expect(result.size).to eq 64
    end
  end

  describe '#create_new_grid' do
    it 'sets @grid to an array of 8 elements' do
      board.create_new_grid
      expect(board.grid).to be_instance_of(Array)
      expect(board.grid.size).to eq 8
    end

    it 'sets @grid to contain 64 identical strings with \'unoccupied\'' do
      board.create_new_grid
      flattened_grid = board.grid.flatten
      expect(flattened_grid).to include('unoccupied').exactly(64).times
    end
  end

  describe '#update_square' do
    it 'sets a grid coordinate to a new value' do
      coord = [3, 5]
      new_value = 'Black Rook Object'
      board.update_square(coord, new_value)
      expect(board.grid[3][5]).to eq 'Black Rook Object'
    end
  end

  describe '#path_obstructed' do
    context 'when white rook\'s path is obstructed by friendly piece' do
      it 'returns true' do
        board.create_new_grid
        board.grid[0][0] = board.wht_rook
        board.grid[3][0] = board.wht_knight
        rooks_path = [[0, 0], [1, 0], [2, 0], [3, 0], [4, 0]]
        result = board.path_obstructed?(rooks_path)
        expect(result).to be true
      end
    end

    context 'when white bishop\'s path is obstructed by enemy queen' do
      it 'returns true' do
        board.create_new_grid
        board.grid[0][7] = board.wht_bishop
        board.grid[2][5] = board.blk_queen
        bishops_path = [[0, 7], [1, 6], [2, 5], [3, 4], [4, 3]]
        result = board.path_obstructed?(bishops_path)
        expect(result).to be true
      end
    end

    context 'when new game and white pawn moves 1 step forward' do
      it 'returns false' do
        wht_pawns_path = [[1, 2], [2, 2]]
        result = board.path_obstructed?(wht_pawns_path)
        expect(result).to be false
      end
    end

    context 'when new game and black pawn moves 2 steps forward' do
      it 'returns false' do
        blk_pawns_path = [[6, 2], [4, 2]]
        result = board.path_obstructed?(blk_pawns_path)
        expect(result).to be false
      end
    end

    context 'when knight moves' do
      it 'returns false (because knight cannot be blocked)' do
        wht_knights_path = [[0, 6], [2, 5]]
        result = board.path_obstructed?(wht_knights_path)
        expect(result).to be false
      end
    end

    context 'when friendly game piece occupies the end square' do
      it 'returns true (capturing friendly not allowed)' do
        board.create_new_grid
        board.grid[3][4] = board.wht_queen
        board.grid[0][4] = board.wht_king
        queens_path = [[3, 4], [2, 4], [1, 4], [0, 4]]
        result = board.path_obstructed?(queens_path)
        expect(result).to be true
      end
    end
  end

  describe '#friendly' do
    context 'when target piece\'s color is same as player\'s' do
      it 'returns true' do
        end_sq = [7, 4]
        result = board.friendly?('black', end_sq)
        expect(result).to be true
      end
    end

    context 'when target piece\'s color is different than player\'s' do
      it 'returns false' do
        end_sq = [7, 2]
        result = board.friendly?('white', end_sq)
        expect(result).to be false
      end
    end
  end

  describe '#pawn_path_obstructed?' do
    context 'when pawn moves 1 step and a game piece is on end square' do
      it 'returns true' do
        board.create_new_grid
        board.grid[1][7] = board.wht_pawn
        board.grid[2][7] = board.blk_knight
        pawns_path = [[1, 7], [2, 7]]
        result = board.pawn_path_obstructed?(pawns_path)
        expect(result).to be true
      end
    end

    context 'when pawn moves 2 steps and a game piece is on end square' do
      it 'returns true' do
        board.create_new_grid
        board.grid[1][7] = board.wht_pawn
        board.grid[3][7] = board.blk_bishop
        pawns_path = [[1, 7], [2, 7], [3, 7]]
        result = board.pawn_path_obstructed?(pawns_path)
        expect(result).to be true
      end
    end

    context 'when pawn moves 2 steps and there\'s a game piece 1 square in front' do
      it 'returns true' do
        board.create_new_grid
        board.grid[1][7] = board.wht_pawn
        board.grid[2][7] = board.blk_bishop
        pawns_path = [[1, 7], [2, 7], [3, 7]]
        result = board.pawn_path_obstructed?(pawns_path)
        expect(result).to be true
      end
    end

    context 'when pawn moves 2 steps and no pieces are in its path' do
      it 'returns false' do
        board.create_new_grid
        board.grid[1][7] = board.wht_pawn
        pawns_path = [[1, 7], [2, 7], [3, 7]]
        result = board.pawn_path_obstructed?(pawns_path)
        expect(result).to be false
      end
    end
  end

  describe '#load_grid' do
    it 'sets a new grid object' do
      grid_obj = %w[new grid object]
      board.load_grid(grid_obj)
      expect(board.grid).to eq %w[new grid object]
    end
  end

  describe '#promotion?' do
    context 'when white pawn moves onto last row' do
      let(:new_move) { instance_double('Move', end_sq: [7, 1], start_piece: board.wht_pawn) }

      it 'returns true' do
        result = board.promotion?(new_move)
        expect(result).to be true
      end
    end

    context 'when white pawn moves onto the second to last row' do
      let(:new_move) { instance_double('Move', end_sq: [6, 6], start_piece: board.wht_pawn) }

      it 'returns false' do
        result = board.promotion?(new_move)
        expect(result).to be false
      end
    end

    context 'when black pawn moves onto last row' do
      let(:new_move) { instance_double('Move', end_sq: [0, 0], start_piece: board.blk_pawn) }

      it 'returns true' do
        result = board.promotion?(new_move)
        expect(result).to be true
      end
    end

    context 'when black queen moves onto last row' do
      let(:new_move) { instance_double('Move', end_sq: [0, 0], start_piece: board.blk_queen) }

      it 'returns false' do
        result = board.promotion?(new_move)
        expect(result).to be false
      end
    end
  end

  describe '#promote_pawn' do
    context 'when user input is invalid, then valid' do
      let(:new_move) { instance_double('Move', end_sq: [0, 0], start_piece: board.blk_queen, player: 'player object') }
      invalid_input = 'ZEBRA'
      valid_input = '1'

      before do
        allow(Display).to receive(:pawn_promotion).with(new_move.player) # arg must be same as in class
        allow(board).to receive(:gets).and_return(invalid_input, valid_input)
        allow(board).to receive(:change_pawn)
      end

      it 'receives error message' do
        invalid_msg = "\nNot valid input!\n"
        expect { board.promote_pawn(new_move) }.to output(invalid_msg).to_stdout
      end
    end
  end

  describe '#change_pawn' do
    context 'when user inputs 1' do
      let(:piece_factory) { double('PieceFactory') }
      let(:player) { instance_double('Player', color: 'white') }
      let(:new_move) { instance_double('Move', end_sq: [0, 0], start_piece: board.blk_queen, player: player) }

      it 'sends #create to PieceFactory' do
        input = '1'
        expect(piece_factory).to receive(:create)
        board.change_pawn(new_move, input, piece_factory)
      end
    end
  end

  describe '#enemy_piece?' do
    context 'when target square contains string \'unoccupied\'' do
      it 'returns false' do
        player_color = 'white'
        board_obj = 'unoccupied'
        result = board.enemy_piece?(player_color, board_obj)
        expect(result).to be false
      end
    end

    context 'when player is black and target square contains white pawn' do
      it 'returns true' do
        player_color = 'black'
        board_obj = board.wht_queen
        result = board.enemy_piece?(player_color, board_obj)
        expect(result).to be true
      end
    end

    context 'when player is black and target square contains black rook' do
      it 'returns false' do
        player_color = 'black'
        board_obj = board.blk_rook
        result = board.enemy_piece?(player_color, board_obj)
        expect(result).to be false
      end
    end
  end

  describe '#object' do
    context 'when board layout is normal (for white pieces)' do
      it 'returns true for location of 1st white pawn' do
        wht_p_location = [1, 0]
        wht_p = board.object(wht_p_location)  # one method call per example
        expect(wht_p).to be_instance_of(Pawn) # 1 or more assertations
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 2nd white pawn' do
        wht_p_location = [1, 1]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 3rd white pawn' do
        wht_p_location = [1, 2]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 4th white pawn' do
        wht_p_location = [1, 3]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 5th white pawn' do
        wht_p_location = [1, 4]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 6th white pawn' do
        wht_p_location = [1, 5]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 7th white pawn' do
        wht_p_location = [1, 6]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of 8th white pawn' do
        wht_p_location = [1, 7]
        wht_p = board.object(wht_p_location)
        expect(wht_p).to be_instance_of(Pawn)
        expect(wht_p.color).to eq 'white'
      end

      it 'returns true for location of kingside white rook' do
        wht_r_location = [0, 0]
        wht_r = board.object(wht_r_location)
        expect(wht_r).to be_instance_of(Rook)
        expect(wht_r.color).to eq 'white'
      end

      it 'returns true for location of kingside white knight' do
        wht_n_location = [0, 1]
        wht_n = board.object(wht_n_location)
        expect(wht_n).to be_instance_of(Knight)
        expect(wht_n.color).to eq 'white'
      end

      it 'returns true for location of kingside white bishop' do
        wht_b_location = [0, 2]
        wht_b = board.object(wht_b_location)
        expect(wht_b).to be_instance_of(Bishop)
        expect(wht_b.color).to eq 'white'
      end

      it 'returns true for location of white queen' do
        wht_q_location = [0, 3]
        wht_q = board.object(wht_q_location)
        expect(wht_q).to be_instance_of(Queen)
        expect(wht_q.color).to eq 'white'
      end

      it 'returns true for location of white king' do
        wht_k_location = [0, 4]
        wht_k = board.object(wht_k_location)
        expect(wht_k).to be_instance_of(King)
        expect(wht_k.color).to eq 'white'
      end

      it 'returns true for location of queenside white bishop' do
        wht_b_location = [0, 5]
        wht_b = board.object(wht_b_location)
        expect(wht_b).to be_instance_of(Bishop)
        expect(wht_b.color).to eq 'white'
      end

      it 'returns true for location of queenside white knight' do
        wht_n_location = [0, 6]
        wht_n = board.object(wht_n_location)
        expect(wht_n).to be_instance_of(Knight)
        expect(wht_n.color).to eq 'white'
      end

      it 'returns true for location of queenside white rook' do
        wht_r_location = [0, 7]
        wht_r = board.object(wht_r_location)
        expect(wht_r).to be_instance_of(Rook)
        expect(wht_r.color).to eq 'white'
      end
    end

    context 'when board layout is normal (for black pieces)' do
      it 'returns true for location of 1st black pawn' do
        blk_p_location = [6, 0]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 2nd black pawn' do
        blk_p_location = [6, 1]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 3rd black pawn' do
        blk_p_location = [6, 2]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 4th black pawn' do
        blk_p_location = [6, 3]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 5th black pawn' do
        blk_p_location = [6, 4]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 6th black pawn' do
        blk_p_location = [6, 5]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 7th black pawn' do
        blk_p_location = [6, 6]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of 8th black pawn' do
        blk_p_location = [6, 7]
        blk_p = board.object(blk_p_location)
        expect(blk_p).to be_instance_of(Pawn)
        expect(blk_p.color).to eq 'black'
      end

      it 'returns true for location of kingside black rook' do
        blk_r_location = [7, 0]
        blk_r = board.object(blk_r_location)
        expect(blk_r).to be_instance_of(Rook)
        expect(blk_r.color).to eq 'black'
      end

      it 'returns true for location of kingside black knight' do
        blk_n_location = [7, 1]
        blk_n = board.object(blk_n_location)
        expect(blk_n).to be_instance_of(Knight)
        expect(blk_n.color).to eq 'black'
      end

      it 'returns true for location of kingside black bishop' do
        blk_b_location = [7, 2]
        blk_b = board.object(blk_b_location)
        expect(blk_b).to be_instance_of(Bishop)
        expect(blk_b.color).to eq 'black'
      end

      it 'returns true for location of black queen' do
        blk_q_location = [7, 3]
        blk_q = board.object(blk_q_location)
        expect(blk_q).to be_instance_of(Queen)
        expect(blk_q.color).to eq 'black'
      end

      it 'returns true for location of black king' do
        blk_k_location = [7, 4]
        blk_k = board.object(blk_k_location)
        expect(blk_k).to be_instance_of(King)
        expect(blk_k.color).to eq 'black'
      end

      it 'returns true for location of queenside black bishop' do
        blk_b_location = [7, 5]
        blk_b = board.object(blk_b_location)
        expect(blk_b).to be_instance_of(Bishop)
        expect(blk_b.color).to eq 'black'
      end

      it 'returns true for location of queenside black knight' do
        blk_n_location = [7, 6]
        blk_n = board.object(blk_n_location)
        expect(blk_n).to be_instance_of(Knight)
        expect(blk_n.color).to eq 'black'
      end

      it 'returns true for location of queenside black rook' do
        blk_r_location = [7, 7]
        blk_r = board.object(blk_r_location)
        expect(blk_r).to be_instance_of(Rook)
        expect(blk_r.color).to eq 'black'
      end
    end
  end
end
