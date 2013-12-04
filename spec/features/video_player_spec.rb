# -*- coding: utf-8 -*-
require "spec_helper"

feature "Play a video and make cards", :js => true do
  before { ROLLOUT.activate(:playable_media) }
  let!(:fr) { FactoryGirl.create(:french) }
  before { default_card_model_for_spec; visit "/"; sign_up(supporter: true) }

  scenario "Provide a URL for a video and an SRT file, watch" do
    video_url = stub_file_url("blank.mp4")
    subtitles_url = stub_file_url("subtitles.srt")

    click_link "Media"
    click_link "Add"

    fill_in "Video Title", with: "Blank"
    fill_in "Video URL", with: video_url
    fill_in "Subtitles URL", with: subtitles_url
    click_button "Play It"

    page.should have_text("Blank")
    page.should have_xpath("//video[@src='#{video_url}']")
    page.should have_text("A la même seconde")

    # Click on subtitles, rewind, etc.
  end

  context "with a pre-existing video" do
    let(:video_url) { video_url = stub_file_url("blank.mp4") }
    let!(:playable_media) do
      FactoryGirl.create(:playable_media, title: "Blank",
                         url: video_url, user: current_user)
    end

    scenario "look for an existing video" do
      click_link "Media"
      click_link "Blank"
      page.should have_text("Blank")
    end
  end
end
