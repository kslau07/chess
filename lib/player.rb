# frozen_string_literal: true

# Chess has 2 players
class Player
  attr_reader :color
  
  def initialize(**opts)
    @other = opts[:other] # dummy instance variable, in a hash this won't throw error
    @color = opts[:color]
  end
end
