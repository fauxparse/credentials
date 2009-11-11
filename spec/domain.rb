class Animal < Struct.new(:species, :hungry, :fast)
  credentials do |animal|
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
