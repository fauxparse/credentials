require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  it "should respond to requires_permission_to" do
    UsersController.should respond_to(:requires_permission_to)
  end
end