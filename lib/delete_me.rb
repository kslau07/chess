# frozen_string_literal: true

move_list = %w[Rc3d3 Rf6g6 Rd3c3 Rg6f6 Rc3d3 Rf6g6 Rd3c3 Rg6f6 Rc3d3 Rf6g6 Rd3c3 Rg6f6]

subary1 = move_list[-4..]
subary2 = move_list[-8..-5]
subary3 = move_list[-12..-9]
diff1 = subary1 - subary2
diff2 = subary2 - subary3
diff1 + diff2 == []
return

def base_move(begin_sq, finish_sq, color)
  # factor = color == 'white' ? 1 : -1
  # p [finish_sq[0] - begin_sq[0] * factor, finish_sq[1] - begin_sq[1] * factor]
  p [begin_sq[0] - finish_sq[0], begin_sq[1] - finish_sq[1]]

end

start_sq = [3, 3]
end_sq = [2, 4]
color = 'black'

base_move(start_sq, end_sq, color)
# should be [1, -1]
# now [5, 7]

return

def capturable_sqs(start_sq)
  color = 'white'
  if color == 'white'
    # capturable square will be y+1 and (x-1 and x+1)
    capture_sq1 = [start_sq[0] + 1,  start_sq[1] + 1]
    capture_sq2 = [start_sq[0] + 1,  start_sq[1] - 1]
  else
    capture_sq1 = [start_sq[0] - 1,  start_sq[1] + 1]
    capture_sq2 = [start_sq[0] - 1,  start_sq[1] - 1]
    #[capture_sq1, capture_sq2]
  end
  [capture_sq1, capture_sq2]
end

p capturable_sqs([0, 0])

return 
puts "\e[5AHello"
puts "\e[3A" # up - moves 3 lines up
puts "\e[6B" # down - moves 6 lines down
puts "\e[2C" # forward - moves 2 characters forward
puts "\e[1D" # backward - moves 1 character backward


str = <<X
This is
a sample
text
2
X

def sample_text
  <<~X
  This is
  a sample
  text
  2
  X
end

def game_mode_choices
  <<~HEREDOC

    \e[36mWelcome to Chess!\e[0m

  HEREDOC
end

# puts sample_text