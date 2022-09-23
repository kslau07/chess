# First we implement self-choose
# Then we implement self-choose WITH self.inherited

class Entity
  def elect(number)
    Person.for(number)
  end
end

class Person
  def initialize(number)
    @number = number
  end

  def self.for(number)
    found_object = registry.find { |candidate| candidate.handles?(number) }.new(number)
    pp 'found_object', found_object
  end

  def self.registry
    @registry ||= [Person]
  end

  def self.register(candidate)
    registry.prepend(candidate)
  end

  def self.inherited(candidate)
    puts 'self.inherited'
    register(candidate)
  end

  def self.handles?(number)
    true
  end

  pp 'end Person'
  pp 'Person.registry : ', Person.registry
end

class Warrior < Person
  puts 'top of Warrior'

  def self.handles?(number)
    puts 'warrior'
    number == 0
  end

  pp 'end Warrior'
  pp 'Person.registry : ', Person.registry
end

class Healer < Person
  puts 'top of Healer'
  
  def self.handles?(number)
    puts 'healer'
    number == 1
  end

  pp 'end Healer'
  pp 'Person.registry : ', Person.registry
end

"
When Ruby parses each class, it also adds it to the Superclass's self.inherited method
When we instantiate our unrelated Entity class nothing happens.
Later, we call Entity#elect(1).
This method calls Person.for(number). The factory that Metz uses is a
class method, not an instance method. #elect calls Person.for, which then
goes through @registry (a class variable because it was created by a class method).
Pay attention to the single @, here it is a class variable.
#for is the factory method. It is a class method. It finds the appropriate
class to instantiate by sending self.handles? to each variant. The default
variant is Person, and it will return true and be instantiated if no other
variant steps up (if their self.handles? conditions aren't met.)
Once a variant (Warrior or Healer) matches, or if it defaults to Person,
that class is instantiated and the factory's work is done.

How do we implement this in chess?
First, we need to figure out where we get user input. Either we use
Move class methods, or we use a separate class to do it.
We need to create #handles? methods in EnPassant, Castle, and Move.
Inside each variant will be a conditional to match the user move input.
If no variant is matched (if not en passant, castle, or other special move)
then regular Move will be instantiated (which will handle 90% of moves).

Game instance will be responsible for calling this input object, then input
object will be responsible for calling factory class method, factory class
method will be responsible for calling #handles on each variant, then
instantiating the appropriate variant.
"

# e = Entity.new

# e.elect(1)