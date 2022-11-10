# frozen_string_literal: true

# Chess has 2 players
class Player
  attr_reader :color

  def initialize(**args)
    @color = args[:color] || 'white'
  end
end
