# -*- coding: utf-8 -*-
require 'spec_helper'

describe API::V1::LanguagesController do
  describe "POST 'detect'" do
    it "returns the users preferred languages" do
      # Of course, we don't have any preferred languages when testing.
      xhr :post, 'detect', format: 'json'
      response.should be_success
      json['preferred'].should == []
    end

    it "returns the language for a text snippet" do
      xhr :post, 'detect', format: 'json', text: "Je suis développeur"
      response.should be_success
      json['text'].should == 'fr'
      json['preferred'].should == []
    end
  end

  describe "POST 'translate'" do
    let(:user) { FactoryGirl.create(:user) }
    let(:supporter) { FactoryGirl.create(:user, supporter: true) }
    
    it "returns an error if the user is not a supporter" do
      sign_in(user)
      xhr :post, 'translate', format: 'json', text: "Je m'appelle Jean"
      response.should_not be_success
    end

    it "translates to the specified language" do
      sign_in(supporter)
      VCR.use_cassette('translate-je-m-appelle') do
        xhr :post, 'translate', format: 'json', text: "Je m'appelle Jean"
      end
      response.should be_success
      json['translation'].should == "My name is Jean"
    end
  end
end
