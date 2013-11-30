# -*- coding: utf-8 -*-
require 'spec_helper'

describe Language do
  it { should have_many(:cards) }
  it { should have_many(:dictionaries_from).class_name("Dictionary") }
  it { should have_many(:dictionaries_to).class_name("Dictionary") }

  it { should validate_presence_of(:iso_639_1) }
  it { should validate_presence_of(:name) }

  describe ".detect" do
    let!(:fr) { FactoryGirl.create(:french) }
    let!(:en) { FactoryGirl.create(:english) }

    it "returns the appropriate language object for some text" do
      Language.detect("Je suis développeur").should == fr
      Language.detect("é kz ñ").should be_nil
      path =
        File.join(Rails.root, 'spec', 'fixtures', 'files', 'subtitles_en.srt')
      Language.detect(File.read(path)).should == en
    end
  end
end
