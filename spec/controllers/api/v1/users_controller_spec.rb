require 'spec_helper'

describe API::V1::UsersController do

  describe "POST 'create'" do
    it "creates a new user account and logs in" do
      user = {
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }
      xhr :post, 'create', format: 'json', user: user
      response.should be_success
      user = User.where(email: user[:email]).first
      user.should_not be_nil
      user.authenticate("password").should == user
      session[:user_id].should == user.id
      json['user']['email'].should == user.email
      json['csrf_token'].should_not be_nil
    end

    it "fails if password is not confirmed" do
      user = {
        email: "test@example.com",
        password: "password",
        password_confirmation: "oops"
      }
      xhr :post, 'create', format: 'json', user: user
      response.should_not be_success
      User.where(email: user[:email]).should be_empty
      session[:user_id].should be_nil
    end
  end

end
