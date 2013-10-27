require "spec_helper"

describe "API" do
  let!(:user) do
    user = FactoryGirl.create(:user, password: "pw", password_confirmation: "pw")
    user.ensure_api_key!
    user
  end

  describe "POST 'api_key'" do
    it "returns an API key which can be used to authenticate the user" do
      user.api_key = nil
      user.save!
      credentials = { email: user.email, password: "pw" }
      post '/api/v1/users/api_key.json', user: credentials
      response.should be_success
      user.reload
      user.api_key.should_not be_nil
      json['user']['api_key'].should == user.api_key
    end

    it "returns an error if the password is wrong" do
      credentials = { user: user.email, password: "pw2" }
      post '/api/v1/users/api_key.json', user: credentials
      response.should_not be_success
    end
  end

  it "allows the user save text snippets, given an API key" do
    attrs = FactoryGirl.attributes_for(:card, front: "Via API POST")
    post '/api/v1/cards.json', card: attrs, api_key: user.api_key
    response.should be_success
    Card.where(front: "Via API POST").length.should == 1
  end
end
