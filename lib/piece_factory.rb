# frozen_string_literal: true

# This class creates game piece objects
class PieceFactory
  def self.create_set(color)
    set = Array.new(8, 'Pawn')
    set += ['Rook', 'Knight', 'Bishop', 'Queen', 'King', 'Bishop', 'Knight', 'Rook']
    set.map { |pc_name| create(pc_name, color) }
  end

  def self.create(piece, color)
    Object.const_get(piece).new(color: color)
  end
end
