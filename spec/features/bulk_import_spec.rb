require "spec_helper"

# Watch out for this!
# http://stackoverflow.com/questions/8964537/rails-3-1-capybara-webkit-how-to-execute-javascript-inside-link
feature "Import sentences in bulk", :js => true do
  scenario "Import sentences and add defintions" do
    visit "/"
    click_link "Bulk Import"
    fill_in "Text", with: <<EOD
Sentence 1.

Sentence 2.
EOD
    click_button "Replace Blank Lines"
    click_button "Import"
    expect_html_to_match('#front', /Sentence 1/)
    click_button "Next"
    expect_html_to_match('#front', /Sentence 2/)
  end
end
