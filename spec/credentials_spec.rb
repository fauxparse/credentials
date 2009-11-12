require File.dirname(__FILE__) + '/spec_helper'
require "time"

describe Animal do
  before :each do
    @sheep = Animal.new("Sheep")
    @cow = Animal.new("Cow")
  end

  it "should not be able to eat other animals" do
    @sheep.should_not be_able_to :eat, @cow
  end
  
  it "shouldn't be able to do anything without explicit permission" do
    @cow.should_not be_able_to :jump, "Moon"
  end
  
  it "should be able to clean itself" do
    @sheep.should be_able_to :clean, @sheep
  end
  
  it "should not be able to clean another animal" do
    @sheep.should_not be_able_to :clean, @cow
  end
  
  it "should have magic methods for permissions" do
    lambda {
      @sheep.can_eat?(@cow).should == false
    }.should_not raise_error
  end
  
  it "should still do normal method_missing stuff" do
    lambda {
      @sheep.foo
    }.should raise_error
  end
end

describe Carnivore do
  before :each do
    @antelope = Prey.new("Antelope")
    @toucan = Bird.new("Toucan")
  end
  
  describe "(lazy)" do
    before :each do
      @lion = Carnivore.new("Lion")
    end

    it "should not be able to eat another animal" do
      @lion.should_not be_able_to :eat, @antelope
    end
  end
  
  describe "(hungry)" do
    before :each do
      @lion = Carnivore.new("Lion", true)
    end

    it "should be able to eat another animal" do
      @lion.should be_able_to :eat, @antelope
    end
    
    it "should not be able to eat a bird" do
      @lion.should_not be_able_to :eat, @toucan
    end
  end
  
  describe "(fast)" do
    before :each do
      @lion = Carnivore.new("Lion", false, true)
    end

    it "should not be able to eat another animal" do
      @lion.should_not be_able_to :eat, @antelope
    end
    
    it "should not be able to eat a bird" do
      @lion.should_not be_able_to :eat, @toucan
    end
  end
  
  describe "(hungry AND fast)" do
    before :each do
      @lion = Carnivore.new("Lion", true, true)
    end

    it "should be able to eat another animal" do
      @lion.should be_able_to :eat, @antelope
    end
    
    it "should be able to eat a bird" do
      @lion.should be_able_to :eat, @toucan
    end
  end
end

describe Bird do
  before :each do
    @toucan = Bird.new("Toucan")
    @crocodile = Carnivore.new("Crocodile")
  end
  
  it "should be able to clean another animal" do
    @toucan.should be_able_to :clean, @crocodile
  end
end

describe Man do
  before :each do
    @man = Man.new
  end
  
  it "should be able to do anything it wants" do
    @man.should be_able_to :do_a_cartwheel
    @man.should be_able_to :eat, "ice cream"
    @man.should be_able_to :stay, :up, :past, Time.parse("10:00")
  end
end

describe WhiteMan do
  before :each do
    @white_man = WhiteMan.new
  end
  
  it "can't jump (sorry)" do
    @white_man.should_not be_able_to :jump
  end
end

