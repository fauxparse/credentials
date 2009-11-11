require File.dirname(__FILE__) + '/spec_helper'

describe Credentials::AllowRule do
  it "should have the correct arity" do
    Credentials::AllowRule.new(Animal, :jump).arity.should == 2
  end
  
  it "should match the simple case" do
    antelope = Prey.new("antelope")
    Credentials::AllowRule.new(Animal, :jump).allow?(antelope, :jump).should == true
  end
  
  it "should match the subject, verb, object case" do
    antelope = Prey.new("antelope")
    lion = Carnivore.new("lion")
    Credentials::AllowRule.new(Carnivore, :eat, Prey).allow?(lion, :eat, antelope).should == true
  end
end

describe Credentials::AllowRule do
  it "should have the correct arity" do
    Credentials::AllowRule.new(Animal, :jump).arity.should == 2
  end
  
  it "should match the simple case" do
    elephant = Prey.new("elephant")
    Credentials::DenyRule.new(Animal, :jump).deny?(elephant, :jump).should == true
  end
  
  it "should match the subject, verb, object case" do
    antelope = Prey.new("antelope")
    lion = Carnivore.new("lion")
    Credentials::DenyRule.new(Carnivore, :eat, Prey).deny?(lion, :eat, antelope).should == true
  end
end
