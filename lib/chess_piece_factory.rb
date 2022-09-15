# This class creates game piece objects
class ChessPieceFactory
  def self.create(piece, color)
    case piece
    when 'king'
      King.new(color)
    when 'queen'
      Queen.new(color)
    when 'rook'
      Rook.new(color)
    when 'knight'
      Knight.new(color)
    when 'bishop'
      Bishop.new(color)
    when 'pawn'
      Pawn.new(color)
    end
  end
end
