# -*- coding: utf-8 -*-
require "spec_helper"

feature "Detect language of entered text", :js => true do
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
                       url_pattern: 'http://fr.wiktionary.org/wiki/%s')
  end

  before { default_card_model_for_spec; visit "/"; sign_up }

  scenario "User enters text, and the language is detected" do
    page.should have_select("Studying:", selected: "(auto-detect language)")
    fill_in_html "#front", with: <<EOD
Pour que le caractère d'un être humain dévoile des qualités vraiment exceptionnelles, il faut avoir la bonne fortune de pouvoir observer son action pendant de longues années.
EOD
    page.should have_select("Studying:", selected: "Français")
    page.should have_select("Dictionary:", selected: "Wiktionnaire")

    click_button("Next")

    page.should have_select("Studying:", selected: "(auto-detect language)")
    fill_in_html "#front", with: <<EOD
Call me Ishmael. Some years ago- never mind how long precisely- having little or no money in my purse, and nothing particular to interest me on shore, I thought I would sail about a little and see the watery part of the world.
EOD
    page.should have_select("Studying:", selected: "English")
    page.should have_select("Dictionary:", selected: "Wiktionary")
  end
end
