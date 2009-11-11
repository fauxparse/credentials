require File.dirname(__FILE__) + '/spec_helper'

describe Credentials::Rulebook do
  it "should duplicate on inheritance" do
    Animal.credentials.should_not == Carnivore.credentials
    Animal.credentials.rules.should_not == Carnivore.credentials.rules
    Animal.credentials.should be_empty
    Carnivore.credentials.should_not be_empty
  end
end