# -*- coding: utf-8 -*-
require "spec_helper"

feature "Detect language of entered text", :js => true do
  let!(:fr) { FactoryGirl.create(:language, iso_639_1: "fr", name: "Français") }

  before { default_card_model_for_spec; visit "/"; sign_up }

  scenario "User enters text, and the language is detected" do
    page.should have_select("Studying:", selected: "(auto-detect language)")
    fill_in_html "#front", with: <<EOD
Pour que le caractère d'un être humain dévoile des qualités vraiment exceptionnelles, il faut avoir la bonne fortune de pouvoir observer son action pendant de longues années.
EOD
    page.should have_select("Studying:", selected: "Français")
  end
end
