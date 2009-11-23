require File.dirname(__FILE__) + '/../spec_helper'

if defined?(ActionController)
  class TestController < ActionController::Base
    self.current_user_method = :logged_in_user
    requires_permission_to :view, :stuff, :except => [ :public ]
    requires_permission_to :break, :stuff, :only => [ :dangerous ]
  
    def index; end
    def public; end
    def dangerous; end
  
    def rescue_action(e)
      raise e
    end
  end

  class TestUser
    credentials do |user|
      user.can :view, :stuff
      user.can :break, :stuff, :if => :special?
    end
  end

  describe TestController do
    it "should know how to specify access credentials" do
      controller.class.should respond_to(:requires_permission_to)
    end
  
    it "should use the right method to look up the current user" do
      controller.class.current_user_method.should == :logged_in_user
    end
  
    it "should check credentials on each request" do
      controller.should_receive(:check_credentials)
      get :index
    end
  
    describe "when logged in" do
      before :each do
        @user = TestUser.new
        controller.should_receive(:logged_in_user).and_return(@user)
      end
    
      it "should display stuff" do
        lambda {
          get :index
          response.should be_success
        }.should_not raise_error(Credentials::Errors::NotLoggedInError)
      end
    
      describe "as someone with permission to break stuff" do
        before(:each) do
          @user.stub!(:special?).and_return(true)
          @user.should be_able_to(:view, :stuff)
          @user.should be_able_to(:break, :stuff)
        end
      
        it "should have access to dangerous actions" do
          lambda {
            get :dangerous
            response.should be_success
          }.should_not raise_error(Credentials::Errors::AccessDeniedError)
        end
      end
    
      describe "as someone without permission to break stuff" do
        before(:each) do
          @user.stub!(:special?).and_return(false)
          @user.should_not be_able_to(:break, :stuff)
        end
      
        it "should not have access to dangerous actions" do
          lambda {
            get :dangerous
            response.should_not be_success
          }.should raise_error(Credentials::Errors::AccessDeniedError)
        end
      end
    end
  
    describe "when not logged in" do
      before :each do
        controller.should_receive(:logged_in_user).and_return(nil)
      end
    
      it "should not have access to stuff" do
        lambda {
          get :index
        }.should raise_error(Credentials::Errors::NotLoggedInError)
      end
    
      it "should have access to public stuff" do
        lambda {
          get :public
          response.should be_success
        }.should_not raise_error(Credentials::Errors::AccessDeniedError)
      end
    end
  end
end