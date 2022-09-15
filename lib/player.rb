# frozen_string_literal: true

# Chess has 2 players
class Player
  def initialize(**opts)
    @other = opts[:other] # dummy instance variable, in a hash this won't throw error
    @name = opts[:name]
  end
end
