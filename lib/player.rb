# frozen_string_literal: true

# Chess has 2 players
class Player
  attr_reader :color, :type

  def initialize(**args)
    @type = args[:type] || 'human'
    @color = args[:color] || 'white'
  end
end
