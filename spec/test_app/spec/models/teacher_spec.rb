require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Teacher do
  fixtures :schools, :houses, :users
  
  describe "(Severus Snape)" do
    it "should be the head of Slytherin" do
      houses(:gryffindor).head.should == users(:mcgonagall)
    end
    
    it "should be able to breathe" do
      users(:snape).should be_able_to(:breathe)
    end

    it "should be able to apparate into Hogsmeade" do
      users(:snape).should be_able_to(:apparate, "Hogsmeade")
    end

    it "should not be able to apparate within the grounds" do
      users(:snape).should_not be_able_to(:apparate, schools(:hogwarts))
    end

    it "should be able to teach" do
      users(:snape).should be_able_to(:teach)
    end

    it "should be able to teach at Hogwarts" do
      schools(:hogwarts).teachers.should include(users(:snape))
      users(:snape).should be_able_to(:teach, schools(:hogwarts))
    end

    it "should not be able to teach at Durmstrang" do
      users(:snape).should_not be_able_to(:teach, schools(:durmstrang))
    end

    it "should not be able to punish Harry Potter" do
      users(:snape).should_not be_able_to(:punish, users(:harry))
    end
  end
  
  describe "(Minerva McGonagall)" do
    it "should be the head of Gryffindor" do
      houses(:gryffindor).head.should == users(:mcgonagall)
    end
    
    it "should be able to punish Harry Potter" do
      users(:mcgonagall).should be_able_to(:punish, users(:harry))
    end
  end
end
