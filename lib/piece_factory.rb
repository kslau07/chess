# This class creates game piece objects
class PieceFactory
  def self.create(piece, color)
    Object.const_get(piece).new(color)

    # Object.const_get('Array').new
    # case piece
    # when 'king'
    # when 'queen'
    #   Queen.new(color)
    # when 'rook'
    #   Rook.new(color)
    # when 'knight'
    #   Knight.new(color)
    # when 'bishop'
    #   Bishop.new(color)
    # when 'pawn'
    #   Pawn.new(color)
    # end
  end
end

