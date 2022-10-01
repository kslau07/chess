# frozen_string_literal: true

# This module allows class instances to be serialized
module Serializable
  def serialize
    obj = {}
    instance_variables.map do |var|
      obj[var] = instance_variable_get(var)
    end

    JSON.dump(obj)
  end
  
  def unserialize(string)
    # How do we implement?
  end
end

