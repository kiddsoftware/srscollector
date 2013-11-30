require 'spec_helper'

describe API::V1::SubtitlesController do
  let(:subtitle) { FactoryGirl.create(:subtitle) }
  let(:user) { subtitle.playable_media.user }
  before { sign_in(user) }

  describe "GET 'index'" do
    it "fails unless logged in as a supporter" do
      sign_out(user)
      sign_in(FactoryGirl.create(:user))
      get('index', playable_media_id: subtitle.playable_media.to_param,
          format: 'json')
      response.should_not be_success
      response.response_code.should == 403
    end

    it "returns the subtitles associated with a PlayableMedia" do
      get('index', playable_media_id: subtitle.playable_media.to_param,
          format: 'json')
      response.should be_success
      json["subtitles"].length.should == 1
      json["subtitles"][0]["id"].should == subtitle.id
    end
  end
end
