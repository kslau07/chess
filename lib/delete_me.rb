# frozen_string_literal: true

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