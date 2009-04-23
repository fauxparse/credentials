$: << File.dirname(__FILE__) + "/../lib"
require "credentials"
require "spec"

class Animal
  credentials do |animal|
  end
end

class Carnivore < Animal
  credentials do |carnivore|
    carnivore.can :eat, Animal
  end
end

describe "Animal" do
  it "should not be able to eat other animals" do
    sheep = Animal.new
    cow = Animal.new
    sheep.should_not be_able_to :eat, cow
  end
end

describe "Carnivore" do
  it "should be able to eat another animal" do
    lion = Carnivore.new
    monkey = Animal.new
    lion.should be_able_to :eat, monkey
  end
end
