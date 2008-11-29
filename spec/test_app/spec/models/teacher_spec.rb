require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Teacher do
  fixtures :users
  
  it "should be able to breathe" do
    users(:snape).should be_able_to(:breathe)
  end

  it "should be able to apparate into Hogsmeade" do
    users(:snape).should be_able_to(:apparate, "Hogsmeade")
  end

  it "should not be able to apparate within the grounds" do
    users(:snape).should_not be_able_to(:apparate, "Hogwarts")
  end
  
  it "should be able to teach" do
    users(:snape).should be_able_to(:teach)
  end
end
