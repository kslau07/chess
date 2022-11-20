# frozen_string_literal: true

# This class is utilized when a pawn reaches the other side of the board
# and is promoted to a higher ranked game piece
class PawnPromotion
  # def promotion?(new_move)
  #   cond1 = new_move.end_sq[0] == 7 && new_move.start_piece.instance_of?(Pawn) # wht pawn
  #   cond2 = new_move.end_sq[0] == 0 && new_move.start_piece.instance_of?(Pawn) # blk pawn
  #   cond1 || cond2
  # end

  # def promote_pawn(new_move, input = '')
  #   puts Display.pawn_promotion(new_move.player)
  #   loop do
  #     input = gets.chomp
  #     break if input.match(/^[1-4]{1}$/)

  #     puts 'Not valid input!'
  #   end
  #   change_pawn(new_move, input)
  # end

  # def change_pawn(new_move, input)
  #   promotion = { 'Queen': '1', 'Rook': '2', 'Bishop': '3', 'Knight': '4' }.key(input)
  #   new_piece = PieceFactory.create(promotion, new_move.player.color)
  #   update_square(new_move.end_sq, new_piece)
  # end
end