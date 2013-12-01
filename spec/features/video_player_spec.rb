# -*- coding: utf-8 -*-
require "spec_helper"

feature "Play a video and make cards", :js => true do
  let!(:fr) { FactoryGirl.create(:french) }
  before { default_card_model_for_spec; visit "/"; sign_up(supporter: true) }

  scenario "Provide a URL for a video and an SRT file, watch" do
    ROLLOUT.activate_user(:playable_media, current_user)

    video_url = stub_file_url("blank.mp4")
    subtitles_url = stub_file_url("subtitles.srt")

    pending

    click_link "Media"
    click_link "Add"
    fill_in "Video URL", with: video_url
    fill_in "Subtitle URL", with: subtitles_url
    click_button "Play It"

    page.should have_text("blank.mp4")
    page.should have_text("A la même seconde")
  end
end
