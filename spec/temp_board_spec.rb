# Put this code back into board_spec when you finish those tests

describe '#object' do
  context 'when board layout is normal (for white pieces)' do
    it 'returns true for location of 1st white pawn' do
      wht_p_location = [1, 0]
      wht_p = board.object(wht_p_location)  # one method call per example
      expect(wht_p).to be_instance_of(Pawn) # and 1 or more assertations
      expect(wht_p.color).to eq('white') #
    end

    it 'returns true for location of 2nd white pawn' do
      wht_p_location = [1, 1]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of 3rd white pawn' do
      wht_p_location = [1, 2]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of 4th white pawn' do
      wht_p_location = [1, 3]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of 5th white pawn' do
      wht_p_location = [1, 4]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of 6th white pawn' do
      wht_p_location = [1, 5]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of 7th white pawn' do
      wht_p_location = [1, 6]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of 8th white pawn' do
      wht_p_location = [1, 7]
      wht_p = board.object(wht_p_location)
      expect(wht_p).to be_instance_of(Pawn)
      expect(wht_p.color).to eq('white')
    end

    it 'returns true for location of kingside white rook' do
      wht_r_location = [0, 0]
      wht_r = board.object(wht_r_location)
      expect(wht_r).to be_instance_of(Rook)
      expect(wht_r.color).to eq('white')
    end

    it 'returns true for location of kingside white knight' do
      wht_n_location = [0, 1]
      wht_n = board.object(wht_n_location)
      expect(wht_n).to be_instance_of(Knight)
      expect(wht_n.color).to eq('white')
    end

    it 'returns true for location of kingside white bishop' do
      wht_b_location = [0, 2]
      wht_b = board.object(wht_b_location)
      expect(wht_b).to be_instance_of(Bishop)
      expect(wht_b.color).to eq('white')
    end

    it 'returns true for location of white queen' do
      wht_q_location = [0, 3]
      wht_q = board.object(wht_q_location)
      expect(wht_q).to be_instance_of(Queen)
      expect(wht_q.color).to eq('white')
    end

    it 'returns true for location of white king' do
      wht_k_location = [0, 4]
      wht_k = board.object(wht_k_location)
      expect(wht_k).to be_instance_of(King)
      expect(wht_k.color).to eq('white')
    end

    it 'returns true for location of queenside white bishop' do
      wht_b_location = [0, 5]
      wht_b = board.object(wht_b_location)
      expect(wht_b).to be_instance_of(Bishop)
      expect(wht_b.color).to eq('white')
    end

    it 'returns true for location of queenside white knight' do
      wht_n_location = [0, 6]
      wht_n = board.object(wht_n_location)
      expect(wht_n).to be_instance_of(Knight)
      expect(wht_n.color).to eq('white')
    end

    it 'returns true for location of queenside white rook' do
      wht_r_location = [0, 7]
      wht_r = board.object(wht_r_location)
      expect(wht_r).to be_instance_of(Rook)
      expect(wht_r.color).to eq('white')
    end
  end

  context 'when board layout is normal (for black pieces)' do
    it 'returns true for location of 1st black pawn' do
      blk_p_location = [6, 0]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 2nd black pawn' do
      blk_p_location = [6, 1]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 3rd black pawn' do
      blk_p_location = [6, 2]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 4th black pawn' do
      blk_p_location = [6, 3]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 5th black pawn' do
      blk_p_location = [6, 4]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 6th black pawn' do
      blk_p_location = [6, 5]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 7th black pawn' do
      blk_p_location = [6, 6]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of 8th black pawn' do
      blk_p_location = [6, 7]
      blk_p = board.object(blk_p_location)
      expect(blk_p).to be_instance_of(Pawn)
      expect(blk_p.color).to eq('black')
    end

    it 'returns true for location of kingside black rook' do
      blk_r_location = [7, 0]
      blk_r = board.object(blk_r_location)
      expect(blk_r).to be_instance_of(Rook)
      expect(blk_r.color).to eq('black')
    end

    it 'returns true for location of kingside black knight' do
      blk_n_location = [7, 1]
      blk_n = board.object(blk_n_location)
      expect(blk_n).to be_instance_of(Knight)
      expect(blk_n.color).to eq('black')
    end

    it 'returns true for location of kingside black bishop' do
      blk_b_location = [7, 2]
      blk_b = board.object(blk_b_location)
      expect(blk_b).to be_instance_of(Bishop)
      expect(blk_b.color).to eq('black')
    end

    it 'returns true for location of black queen' do
      blk_q_location = [7, 3]
      blk_q = board.object(blk_q_location)
      expect(blk_q).to be_instance_of(Queen)
      expect(blk_q.color).to eq('black')
    end

    it 'returns true for location of black king' do
      blk_k_location = [7, 4]
      blk_k = board.object(blk_k_location)
      expect(blk_k).to be_instance_of(King)
      expect(blk_k.color).to eq('black')
    end

    it 'returns true for location of queenside black bishop' do
      blk_b_location = [7, 5]
      blk_b = board.object(blk_b_location)
      expect(blk_b).to be_instance_of(Bishop)
      expect(blk_b.color).to eq('black')
    end

    it 'returns true for location of queenside black knight' do
      blk_n_location = [7, 6]
      blk_n = board.object(blk_n_location)
      expect(blk_n).to be_instance_of(Knight)
      expect(blk_n.color).to eq('black')
    end

    it 'returns true for location of queenside black rook' do
      blk_r_location = [7, 7]
      blk_r = board.object(blk_r_location)
      expect(blk_r).to be_instance_of(Rook)
      expect(blk_r.color).to eq('black')
    end
  end
end