# frozen_string_literal: true

require_relative '../lib/chess'
require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/display'
require_relative '../lib/piece_factory'
require_relative '../lib/piece'
require_relative '../lib/pawn'

describe Chess do
  it '' do
    allow(subject).to receive(:gets).and_return '10', '20'
    subject.play
  end
end