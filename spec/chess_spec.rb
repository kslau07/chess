# frozen_string_literal: true

require_relative '../lib/chess'

describe Chess do
  describe '#initialize' do
    it 'initializes' do
      described_class.new
    end
  end
end
