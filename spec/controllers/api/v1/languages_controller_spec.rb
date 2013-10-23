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
end
