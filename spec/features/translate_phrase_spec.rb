# -*- coding: utf-8 -*-
require "spec_helper"
# Needed to prevent "Circular dependency detected while autoloading
# constant Card" when run under guard.
require_relative "../../app/controllers/api/v1/cards_controller"

feature "Translate a snippet of text", :js => true do
  before { default_card_model_for_spec }

  scenario "Regular user sees an upgrade message" do
    visit "/"
    sign_up
    fill_in_html "#front", with: "Je m'appelle Jean."
    select_all "#front"
    first(".rich-editor").click_link("Translate")
    page.should have_text("costs us money")

    # Goes away when we search for something.
    find("input[placeholder='Search']").set("est")
    find("button[title='Search']").click
    page.should_not have_text("costs us money")
  end

  scenario "Supporter can translate text" do
    visit "/"
    sign_up(supporter: true)
    VCR.use_cassette('translate-je-m-appelle') do
      fill_in_html "#front", with: "Je m'appelle Jean."
      select_all "#front"
      first(".rich-editor").click_link("Translate")
      expect_html_to_match("#back", /My name is/)
    end
  end
end
