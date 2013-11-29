# -*- coding: utf-8 -*-
require 'spec_helper'
require 'encoding_detector'

describe PlayableMedia do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  it { should belong_to(:language) }
  it { should validate_presence_of(:language) }

  it { should have_many(:subtitles) }

  it { should validate_presence_of(:type) }  
  it { should ensure_inclusion_of(:type).in_array(['audio', 'video']) }

  it { should validate_presence_of(:url) }

  describe "#add_srt_data" do
    let!(:fr) { FactoryGirl.create(:french) }

    it "extracts subtitles and guesses language" do
      path = File.join(Rails.root, 'spec', 'fixtures', 'files', 'subtitles.srt')
      srt = EncodingDetector.ensure_utf8(File.read(path))
      media = FactoryGirl.create(:playable_media)
      media.add_srt_data(srt)
      media.subtitles.length.should == 10
      sub = media.subtitles.first
      sub.language.should == fr
      sub.start_time.should == 51.095 
      sub.end_time.should == 55.057
      sub.text.should == "- Le 3 septembre 1973\nà 18 h 28 min et 32 s,"
    end
  end
end
