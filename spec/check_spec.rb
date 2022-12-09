# frozen_string_literal: true

require_relative '../lib/check'
# require_relative '../lib/save_load'

describe Check do
  # let(:testing_class) { Class.new { include MyMath } }
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
        expect(result).to be(true)
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
        expect(result).to be(false)
      end
    end
  end

  describe '#find_check_paths' do
    # squares is a Board method that contains all y, x coords for the Board
    # We use square with Board#object in order to target specific board squares
    # and whatever game piece might be at that coord.
    # The iterator checks each and every square to locate paths that connect
    # an enemy piece with the player's king.

    # Determine what to fake. This method is a bit complex.
  end
end
