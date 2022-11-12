# frozen_string_literal: true

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

puts sample_text