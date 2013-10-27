require "spec_helper"

describe "API" do
  it "allows the user save text snippets, given an API key" do
    user = FactoryGirl.create(:user)
    user.ensure_api_key!
    attrs = FactoryGirl.attributes_for(:card, front: "Via API POST")
    post '/api/v1/cards.json', card: attrs, api_key: user.api_key
    response.should be_success
    Card.where(front: "Via API POST").length.should == 1
  end
end
