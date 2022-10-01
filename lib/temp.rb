
# seq0 = ["Pe5+"]
# seq1 = ["Pd4", "Pa6", "Pd5", "Pe5"] # valid, black's pawn took a double step
# seq2 = ["Pd4", "Pe6", "Pd5", "Pe5"] # invalid, black's pawn took 2 single steps

# def convert_move_list(move_list)
#   move_list.map do |move|
#     translate_notation_to_index(move)
#   end
# end

# def translate_notation_to_index(str_move)
#   split = str_move.split('')
#   [split[0], split[2].to_i - 1, split[1].ord - 97].join
# end

# We actually have to do TWO things.
# We have to see that opp's pawn parked beside us (you must translate notation for this)
# We have to see that opp's pawn did not move earlier in the list (translation not needed for this)

# We now have P44, we can extract target_sq from 44, which is str[-2..]

# last move is Pe5
# it will show: P 5=4 ,e=4
# solution: P44

# p convert_move_list(seq1)


# class Parent
#   def initialize(color)
#     @color = color
#   end
# end

# class Child < Parent
#   def initialize(color)
#     super
#     @foo = 'bar'
#   end
# end

# john = Child.new('white')
# p john.instance_variable_get(:@color)
# p john.instance_variable_get(:@foo)

# Old code

#
# def display_board
#   0.upto(5) do |i|
#     print "|"
#     0.upto(6) do |n|
#       print @board[n][i].nil? ? "   |" : " #{@board[n][i]} |"
#     end
#     puts
#   end
# end




# board = [[0, 1, 2], [3, 4, 5], [6, 7, 8]]

# board.reverse_each do |n|
#   p n
# end

# board.grid[end_point[0]][end_point[1]] = board.grid[start_point[0]][start_point[1]]
# board.grid[start_point[0]][start_point[1]] = nil

# # Restrict input to chess notation, i.e. H3
# # Re-implement after we work out game logic. This slows us down.
# def input_move(user_input = '')
#   loop do
#     user_input = gets.chomp.upcase
#     break if user_input[0].match(/[A-H]/) && user_input[1].match(/[1-8]/) # uses chess notation

#     Display.invalid_input_message
#   end
#   user_input
# end

# # Convert from chess notation to array index
# def convert_from_notation(chess_notation)
#   converted_nums = []
#   converted_nums << chess_notation[1].to_i - 1
#   converted_nums << chess_notation[0].ord - 65
#   # board.grid[converted_nums[0]][converted_nums[1]].nil? ? false : true
# end

  # # delete layouts later
  # def layout_en_passant
  #   # white, black right side
  #   # seq = ["Pd3+", "Pa5+", "Pd4+", "Pe4+"]
  #   # board.grid[4][3] = PieceFactory.create('Pawn', 'white')
  #   # board.grid[4][4] = PieceFactory.create('Pawn', 'black')
    
  #   # white, black left side
  #   # seq = ["Pd3+", "Pa5+", "Pd4+", "Pc4+"]
  #   # board.grid[4][3] = PieceFactory.create('Pawn', 'white')
  #   # board.grid[4][2] = PieceFactory.create('Pawn', 'black')
    
  #   # black, white right side
  #   seq = ["Na2+", "Pd4+", "Nh2+", "Pd3+"]
  #   board.grid[1][4] = PieceFactory.create('Pawn', 'white')
  #   board.grid[3][3] = PieceFactory.create('Pawn', 'black')

  #   # black, white right side
  #   # seq = ["Na2+", "Pd4+", "Nh2+", "Pd3+"]
  #   # board.grid[1][2] = PieceFactory.create('Pawn', 'white')
  #   # board.grid[3][3] = PieceFactory.create('Pawn', 'black')

  #   move_list.instance_variable_set(:@all_moves, seq)
  # end