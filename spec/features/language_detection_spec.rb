# -*- coding: utf-8 -*-
require "spec_helper"
# Needed to prevent "Circular dependency detected while autoloading
# constant Card" when run under guard.
require_relative "../../app/controllers/api/v1/cards_controller"

feature "Detect language of entered text", :js => true do

  let(:text_en) do
    <<EOD
Call me Ishmael. Some years ago- never mind how long precisely- having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world.
EOD
  end

  let(:text_fr) do
    <<EOD
Pour que le caractère d'un être humain dévoile des qualités vraiment exceptionnelles, il faut avoir la bonne fortune de pouvoir observer son action pendant de longues années.
EOD
  end

  let!(:en) { FactoryGirl.create(:language, iso_639_1: "en", name: "English") }
  let!(:fr) { FactoryGirl.create(:language, iso_639_1: "fr", name: "Français") }

  let!(:wiktionary) do
    FactoryGirl.create(:dictionary,
                       name: "Wiktionary",
                       from_language: en,
                       to_language: en,
                       url_pattern: 'http://en.wiktionary.org/wiki/%s')
  end

  let!(:wiktionnaire) do
    FactoryGirl.create(:dictionary,
                       name: "Wiktionnaire",
                       from_language: fr,
                       to_language: fr,
                       url_pattern: 'http://fr.wiktionary.org/wiki/%s',
                       score: 1)
  end

  let!(:images) do
    FactoryGirl.create(:dictionary,
                       name: "Image Search",
                       from_language: fr,
                       to_language: nil,
                       url_pattern: 'http://www.example.com?q=%s',
                       score: 0.80)
  end

  before { default_card_model_for_spec; visit "/"; sign_up }

  scenario "User enters text, and the language is detected" do
    page.should have_select("Studying:", selected: "(auto-detect language)")
    fill_in_html "#front", with: text_fr
    page.should have_select("Studying:", selected: "Français")
    page.should have_select("Dictionary:", selected: "Wiktionnaire")

    click_button("Next")

    page.should have_select("Studying:", selected: "(auto-detect language)")
    fill_in_html "#front", with: text_en
    page.should have_select("Studying:", selected: "English")
    page.should have_select("Dictionary:", selected: "Wiktionary")
  end

  scenario "Dictionary remains stable even when not available" do
    fill_in_html "#front", with: text_fr
    select("Image Search")
    page.should have_select("Dictionary:", selected: "Image Search")

    fill_in_html "#front", with: ""
    page.should_not have_select("Dictionary:", selected: "Image Search")

    fill_in_html "#front", with: text_fr
    page.should have_select("Dictionary:", selected: "Image Search")
  end
end
