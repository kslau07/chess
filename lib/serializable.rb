# frozen_string_literal: true

# This module allows class instances to be serialized
module Serializable
  # Test for 'types' then implement their serialization

  def serialize
    puts "\n\t#{self.class}##{__method__}\n "
    if instance_of?(MoveList)
      jsonify_move_list
    elsif instance_of?(Board)
      jsonify_board
    elsif is_a?(Piece)
      jsonify_piece
    end
  end
  
  def unserialize(string)
    # How do we implement?
  end

  private

  def jsonify_move_list
    puts "\n\t#{self.class}##{__method__}\n "
    puts 'code for serialize move list goes here'
  end

  def jsonify_board
    puts "\n\t#{self.class}##{__method__}\n "

    obj = @grid.map do |row|
      row.map do |square|
        if square.is_a?(String)
          square
        else
          serialize
        end
      end
    end

    JSON.dump(obj)
  end

  def jsonify_piece
    puts "\n\t#{self.class}##{__method__}\n "

    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    JSON.dump(obj)
  end
end

