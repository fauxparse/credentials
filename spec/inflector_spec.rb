require File.dirname(__FILE__) + '/spec_helper'

describe "Infector" do
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
    %w(authorise authority)
  ]
  
  test_cases.each do |verb, noun|
    it "should actorize '#{verb}' to '#{noun}'" do
      verb.actorize.should == noun
    end
  end
end