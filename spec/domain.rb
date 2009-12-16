class Animal
  credentials do |animal|
    animal.can :clean, :self
    animal.can :laugh, :at => :friend
  end
  
  attr_accessor :species, :hungry, :fast
  attr_accessor :friends
  def friends; @friends ||= []; end
  
  def initialize(species = nil, hungry = false, fast = false)
    @species = species
    @hungry = hungry
    @fast = fast
  end
  
  def edible?
    false
  end
  
  def hungry?
    !!hungry
  end
  
  def fast?
    !!fast
  end
  
  alias :to_s :species
end

class Prey < Animal
  def edible?; true; end
end

class Bird < Prey
  credentials do |bird|
    bird.can :clean, Animal # they are good like that
  end
end

class Carnivore < Animal
  credentials do |carnivore|
    carnivore.can :eat, Animal, :if => lambda { |predator, prey| prey.edible? }
    carnivore.cannot :eat, Animal, :unless => :hungry?
    carnivore.cannot :eat, Bird, :unless => [ :hungry?, :fast? ]
  end
end

class Man < Animal
  credentials :default => :allow do |man|
  end
end

class WhiteMan < Man
  credentials :default => :allow do |white_man|
    white_man.cannot :jump
  end
end
