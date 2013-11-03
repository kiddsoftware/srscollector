# -*- coding: utf-8 -*-
require "spec_helper"

feature "Add definitions to a snippet", :js => true do
  let!(:dict1) do
    FactoryGirl.create(:dictionary, name: "Dict1", from_lang: "fr",
                       to_lang: "fr", url_pattern: "http://example.com/d1/%s",
                       score: 1.0)
  end

  let!(:dict2) do
    FactoryGirl.create(:dictionary, name: "Dict2", from_lang: "fr",
                       to_lang: "en", url_pattern: "http://example.com/d2/%s",
                       score: 0.5)
  end

  before { visit "/"; sign_up }

  scenario "User pastes a phrase, looks up a word, exports" do
    fill_in_html "#front", with: "suis"
    select_all "#front"
    first(".rich-editor").click_link("Lookup")
    expect_nested_page('http://example.com/d1/suis')
    find("input[placeholder='Search']").value.should == "suis"
    select('Dict2', from: "Dictionary")
    expect_nested_page('http://example.com/d2/suis')
    find("input[placeholder='Search']").set("est")
    find("button[title='Search']").click
    expect_nested_page('http://example.com/d2/est')
    fill_in_html "#back", with: "am"
    click_button "Next"
    page.should have_content("Ready for export: 1")
    click_link "export"
    page.should have_text("Download cards as CSV")
    page.should have_text("Download media as ZIP")
    click_button "Mark All Cards as Exported"
    page.should_not have_content("Ready for export")
    wait_for_jquery
  end
end
