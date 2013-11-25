# -*- coding: utf-8 -*-
require 'spec_helper'

describe API::V1::LanguagesController do
  describe "GET 'index'" do
    let!(:fr) { FactoryGirl.create(:language, iso_639_1: 'fr') }

    # See https://github.com/iain/http_accept_language to implement.
    # Available: Language.select("iso_639_1").map(&:iso_639_1)
    #describe "with type=preferred" do
    #  it "returns the user's preferred languages" do
    #    # Of course, we don't have any preferred languages when testing.
    #    xhr :get, 'index', format: 'json', type: 'preferred'
    #    response.should be_success
    #    json['languages'].should == []
    #  end
    #end

    describe "with for_text=..." do
      it "returns the language for a text snippet" do
        xhr :get, 'index', format: 'json', for_text: "Je suis développeur"
        response.should be_success
        json['languages'].length.should == 1
        json['languages'][0]['id'].should == fr.id
      end

      it "returns no matches if the language is unsupported" do
        xhr :get, 'index', format: 'json', for_text: "sdhakxxzzzxlfasdkjhgwwq"
        response.should be_success
        json['languages'].length.should == 0
      end

      it "returns no matches if the string is blank" do
        xhr :get, 'index', format: 'json', for_text: "      "
        response.should be_success
        json['languages'].length.should == 0
      end
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
      supporter.reload
      supporter.characters_translated.should == "Je m'appelle Jean".length
    end

    it "returns text, not HTML" do
      sign_in(supporter)
      text = "Aujourd'hui, je suis avec ma femme."
      VCR.use_cassette('translate-je-suis-avec-ma-femme') do
        xhr :post, 'translate', format: 'json', text: text
      end
      response.should be_success
      json['translation'].should == "Today I'm with my wife."
    end
  end
end
