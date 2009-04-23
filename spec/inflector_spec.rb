$: << File.dirname(__FILE__) + "/../lib"
require "credentials"
require "spec"

describe "Inflector" do
  test_cases = [
    %w(act actor),
    %w(view viewer),
    %w(produce producer),
    %w(direct director),
    %w(switch switcher),
    %w(own owner),
    %w(teach teacher),
    %w(swim swimmer),
    %w(fix fixer),
    %w(bake baker),
    %w(improvise improvisor),
    %w(perform performer),
    %w(choose chooser),
    %w(manufacture manufacturer),
    %w(authorise authority),
    %w(create creator)
  ]
  
  test_cases.each do |verb, noun|
    it "should actorize '#{verb}' to '#{noun}'" do
      verb.actorize.should == noun
    end
  end
end