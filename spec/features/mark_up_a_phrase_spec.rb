# -*- coding: utf-8 -*-
require "spec_helper"

feature "Add definitions to a snippet", :js => true do
  scenario "User pastes a phrase and selects a word" do
    visit "/"
    fill_in "Front", :with => "Je demande pardon aux enfants d'avoir dédié"

    # Select "dédié".
    # Button?
    # Follow link to "dédier".
    # Select "Consacrer au culte divin."
    # Button?

    #expect("Back").to have_text("dédier = Consacrer au culte divin.")
  end
end
