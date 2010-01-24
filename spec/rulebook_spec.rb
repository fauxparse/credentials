require File.dirname(__FILE__) + '/spec_helper'

describe Credentials::Rulebook do
  it "should be empty when created" do
    Credentials::Rulebook.new(Animal).should be_empty
  end
  
  it "should duplicate on inheritance" do
    Animal.credentials.should_not == Carnivore.credentials
    Animal.credentials.rules.should_not == Carnivore.credentials.rules
  end
  
  describe "created for an instance" do
    before :all do
      @penguin = Bird.new("Penguin")
      @penguin.metaclass.credentials do |penguin|
        penguin.can :swim
      end
      @emu = Bird.new("Emu")
    end
    
    it "should grant permissions only for that instance" do
      @penguin.should be_able_to(:swim)
      @emu.should_not be_able_to(:swim)
    end
  end
end