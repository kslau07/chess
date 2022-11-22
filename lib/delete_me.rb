# frozen_string_literal: true

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