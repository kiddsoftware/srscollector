require "spec_helper"

# Watch out for this!
# http://stackoverflow.com/questions/8964537/rails-3-1-capybara-webkit-how-to-execute-javascript-inside-link
feature "Import sentences in bulk", :js => true do
  before { default_card_model_for_spec; visit "/"; sign_up }

  scenario "Import sentences and add defintions" do
    click_link "Bulk Import"
    fill_in "Text", with: <<EOD
Sentence 1.

Sentence 2.
EOD
    click_button "Replace Blank Lines"
    fill_in "Source Title", with: "Example.com"
    fill_in "Source URL", with: "http://www.example.com/"
    click_button "Import Text"
    page.should have_content("Cards to review: 2")
    expect_html_to_match('#front', /Sentence 1/)
    find("a[href='http://www.example.com/']").should have_content("Example.com")
    click_button "Next"
    page.should have_content("Cards to review: 1")
    page.should have_content("Ready for export: 1")
    expect_html_to_match('#front', /Sentence 2/)

    wait_for_jquery
  end
end
