require File.dirname(__FILE__) + '/../spec_helper'

class TestController < ActionController::Base
  
end

describe TestController do
  it "should be a test controller" do
    controller.should be_an_instance_of TestController
  end
  
  it "should know how to specify access credentials" do
    controller.class.should respond_to :requires_permission_to
  end
end