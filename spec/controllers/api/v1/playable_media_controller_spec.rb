# -*- coding: utf-8 -*-
require 'spec_helper'

describe API::V1::PlayableMediaController do
  let(:user) { FactoryGirl.create(:supporter) }
  before { sign_in(user) }

  describe "GET 'index'" do
    it "fails unless logged in as a supporter" do
      sign_out(user)
      get 'index', format: 'json'
      response.should_not be_success
      response.response_code.should == 401

      sign_in(FactoryGirl.create(:user))
      get 'index', format: 'json'
      response.should_not be_success
      response.response_code.should == 403
    end

    it "returns the current user's media" do
      media = FactoryGirl.create(:playable_media, user: user)
      not_ours = FactoryGirl.create(:playable_media)
      
      get 'index', format: 'json'
      response.should be_success
      json['playable_media'].length.should == 1
      json['playable_media'][0]['id'].should == media.id
      json['playable_media'][0]['url'].should == media.url
      json['playable_media'][0]['subtitles'].should be_nil
    end
  end  
end
