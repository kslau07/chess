# This class creates game piece objects
class PieceFactory
  def self.create_set(color)
    # set = Array.new(1, 'Pawn')
    
    # set << 'Rook'
    set = Array.new(8, 'Pawn')
    set += ['Rook', 'Knight', 'Bishop', 'Queen', 'King', 'Bishop', 'Knight', 'Rook']

    set.map { |item| create(item, color) }

    # set << create('Rook', color)
    # p set
    # set << self.create('Pawn', color)
    # set
  end

  def self.create(piece, color)
    Object.const_get(piece).new(color: color)
  end
end

