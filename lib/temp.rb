class Parent
  def initialize(color)
    @color = color
  end
end

class Child < Parent
  def initialize(color)
    super
    @foo = 'bar'
  end
end

john = Child.new('white')
p john.instance_variable_get(:@color)
p john.instance_variable_get(:@foo)

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
