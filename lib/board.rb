# frozen_string_literal: true

# This is the chess board
class Board
  attr_reader :squares

  def initialize
    generate_board
  end

  def generate_board
    @squares = []

    8.times do
      @squares.push Array.new(8, nil)
    end
  end
end

# p Board.new.squares
