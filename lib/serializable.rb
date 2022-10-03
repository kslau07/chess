# frozen_string_literal: true

# This module allows objects to be serialized in JSON format
module Serializable
  # Test for 'types' then implement their serialization

  def serialize
    if instance_of?(MoveList)
      jsonify_move_list
    elsif instance_of?(Board)
      jsonify_board
    elsif is_a?(Piece)
      jsonify_piece
    end
  end

  # def unserialize(string)
  #   # How do we implement?
  # end

  private

  def jsonify_move_list
    JSON.dump(self)
  end

  def jsonify_board
    obj = @grid.map do |row|
      row.map do |square|
        if square.is_a?(String)
          square
        else
          square.serialize
        end
      end
    end

    JSON.dump(obj)
  end

  def jsonify_piece
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    JSON.dump(obj)
  end
end
