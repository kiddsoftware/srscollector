require 'spec_helper'

describe API::V1::DictionariesController do
  let!(:dictionary) { FactoryGirl.create(:dictionary, name: "MyDict") }

  describe "GET 'index'" do
    it "returns all dictionaries" do
      xhr :get, 'index', format: 'json'
      response.should be_success
      json['dictionaries'].length.should == 1
      json['dictionaries'][0]['name'].should == "MyDict"
    end
  end
end
