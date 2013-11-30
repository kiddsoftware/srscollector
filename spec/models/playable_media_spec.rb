# -*- coding: utf-8 -*-
require 'spec_helper'
require 'encoding_detector'

describe PlayableMedia do
  it { should belong_to(:user) }
  it { should validate_presence_of(:user) }

  it { should belong_to(:language) }
  it { should validate_presence_of(:language) }

  it { should have_many(:subtitles).dependent(:delete_all) }

  it { should validate_presence_of(:kind) }  
  it { should ensure_inclusion_of(:kind).in_array(['audio', 'video']) }

  it { should validate_presence_of(:url) }

  describe ".new" do
    let!(:fr) { FactoryGirl.create(:french) }
    let!(:en) { FactoryGirl.create(:english) }

    it "defaults the media kind based on the file extension" do
      PlayableMedia.new(url: "http://example.com/f.mp4").kind.should == "video"
      PlayableMedia.new(url: "http://example.com/f.mp3").kind.should == "audio"
    end

    it "imports subtitle URLs and defaults to the first language" do
      urls = [stub_file_url("subtitles.srt"), stub_file_url("subtitles_en.srt")]
      media = PlayableMedia.new(url: "http://example.com/f.mp4",
                                subtitles_urls: urls)
      media.language.should == fr
      media.subtitles.length.should == 20
      media.subtitles.select {|s| s.language == fr }.length.should == 10
      media.subtitles.select {|s| s.language == en }.length.should == 10
    end
  end

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
