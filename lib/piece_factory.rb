# This class creates game piece objects
class PieceFactory
  def self.create_set(color)
    set = Array.new(8, 'Pawn')
    set.map { |item| self.create(item, color) }
    # set << self.create('Pawn', color)
    # set
  end

  def self.create(piece, color)
    Object.const_get(piece).new(color)
  end
end

