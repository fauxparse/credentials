require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Headmaster do
  fixtures :schools, :houses, :users
  
  describe "(Albus Dumbledore)" do
    it "should be able to expel Harry Potter" do
      users(:dumbledore).should be_able_to(:expel, users(:harry))
    end
  end
  
  describe "(Igor Karkaroff)" do
    it "should not be able to expel Harry Potter" do
      users(:karkaroff).should_not be_able_to(:expel, users(:harry))
    end
  end
end
