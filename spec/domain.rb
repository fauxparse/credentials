class Animal < Struct.new(:species)
  credentials do |animal|
  end
  
  def edible?
    false
  end
  
  alias :to_s :species
end

class Prey < Animal
  def edible?; true; end
end

class Carnivore < Animal
  credentials do |carnivore|
    carnivore.can :eat, Animal, :if => lambda { |predator, prey| prey.edible? }
  end
end
