require File.dirname(__FILE__) + '/../spec_helper'

if defined?(ActionController)
  class TestController < ActionController::Base
    self.current_user_method = :logged_in_user
    requires_permission_to :view, :stuff, :except => [ :public ]
    requires_permission_to :break, :stuff, :only => [ :dangerous ]
    requires_permission_to :create, Object, :for => :account, :only => [ :create ]
  
    def index; end
    def public; end
    def dangerous; end
    def create; end
  
    def rescue_action(e)
      raise e
    end
  end

  class TestUser
    credentials do |user|
      user.can :view, :stuff
      user.can :break, :stuff, :if => :special?
      user.can :create, Object, :for => :account
      
      attr_accessor :test_account_id
    end
  end
  
  class TestAccount
    attr_accessor :id
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

      it "should be able to do stuff on its own account" do
        @my_account = TestAccount.new
        @my_account.id = 5
        @user.stub!(:test_account_id).and_return(@my_account.id)
        controller.stub!(:account).and_return(@my_account)
        lambda {
          get :create
          response.should be_success
        }.should_not raise_error(Credentials::Errors::AccessDeniedError)
      end

      it "should not be able to do stuff on someone else's account" do
        @my_account = TestAccount.new
        @your_account = TestAccount.new
        @my_account.id = 5
        @your_account.id = 6
        @user.stub!(:test_account_id).and_return(@my_account.id)
        controller.stub!(:account).and_return(@your_account)
        lambda {
          get :create
          response.should_not be_success
        }.should raise_error(Credentials::Errors::AccessDeniedError)
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