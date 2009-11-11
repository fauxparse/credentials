require File.dirname(__FILE__) + '/spec_helper'

describe "Animal" do
  it "should not be able to eat other animals" do
    sheep = Animal.new("Sheep")
    cow = Animal.new("Cow")
    sheep.should_not be_able_to :eat, cow
  end
end

describe "Carnivore" do
  it "should be able to eat another animal" do
    lion = Carnivore.new("Lion")
    antelope = Prey.new("Antelope")
    lion.should be_able_to :eat, antelope
  end
end
