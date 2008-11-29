require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Student do
  fixtures :schools, :users
  
  describe "(Harry Potter)" do
    it "should be able to breathe" do
      users(:harry).should be_able_to(:breathe)
    end

    it "should be able to apparate into Hogsmeade" do
      users(:harry).should be_able_to(:apparate, "Hogsmeade")
    end

    it "should not be able to apparate within the grounds" do
      users(:harry).should_not be_able_to(:apparate, schools(:hogwarts))
    end

    it "should not be able to teach" do
      users(:harry).should_not be_able_to(:teach)
    end

    it "should not be allowed to stay and fight if they are underage" do
      Student.new(:name => "Colin Creevey").should_not be_able_to(:stay_and_fight)
    end

    it "should not be able to teach at Hogwarts" do
      users(:harry).should_not be_able_to(:teach, schools(:hogwarts))
    end

    it "should be able to go crying to McGonagall" do
      users(:harry).should be_able_to(:go_crying_to, users(:mcgonagall))
    end

    it "should be able to go crying to Dumbledore" do
      users(:harry).should be_able_to(:go_crying_to, users(:dumbledore))
    end

    it "should not be able to go crying to Snape" do
      users(:harry).should_not be_able_to(:go_crying_to, users(:snape))
    end
  end
end
