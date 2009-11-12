require File.dirname(__FILE__) + '/spec_helper'

describe Credentials::Rulebook do
  it "should be empty when created" do
    Credentials::Rulebook.new(Animal).should be_empty
  end
  
  it "should duplicate on inheritance" do
    Animal.credentials.should_not == Carnivore.credentials
    Animal.credentials.rules.should_not == Carnivore.credentials.rules
  end
end