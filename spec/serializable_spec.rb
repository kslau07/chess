# frozen_string_literal: true

require 'json'
require_relative '../lib/serializable'
# require_relative '../lib/display'
# require_relative '../lib/piece'
# require_relative '../lib/pieces/rook'
# require_relative '../lib/pieces/pawn'

describe Serializable do
  subject(:class_instance) { Class.new.include(described_class).new }

  describe '#serialize' do
    # Only calls self, no testing required
  end

  describe '#jsonify_move_list' do
    it 'sends #dump to JSON' do
      expect(JSON).to receive(:dump)
      class_instance.jsonify_move_list
    end
  end

  describe '#jsonify_board' do
    let(:wht_king) { instance_double('King', color: 'white') }
    let(:blk_king) { instance_double('King', color: 'black') }

    context 'when given simplified grid object' do
      it 'sends #serialize to white King' do
        simplified_grid_obj = [['unoccupied'], [wht_king], [blk_king]]
        allow(blk_king).to receive(:serialize)

        expect(wht_king).to receive(:serialize)
        class_instance.jsonify_board(simplified_grid_obj)
      end

      it 'sends #serialize to black King' do
        simplified_grid_obj = [['unoccupied'], [wht_king], [blk_king]]
        allow(blk_king).to receive(:serialize)

        expect(wht_king).to receive(:serialize)
        class_instance.jsonify_board(simplified_grid_obj)
      end

      it 'sends #dump to JSON' do
        simplified_grid_obj = [['unoccupied'], [wht_king], [blk_king]]
        allow(wht_king).to receive(:serialize)
        allow(blk_king).to receive(:serialize)

        expect(JSON).to receive(:dump)
        class_instance.jsonify_board(simplified_grid_obj)
      end
    end
  end

  describe '#jsonify_piece' do
  
  end
end