require "spec_helper"

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
    #find_field("Front").value.should match(/Sentence 1/)
    #find_field("Front").value.should_not match(/Sentence 2/)
    #click_button "Next"
    #find_field("Front").value.should match(/Sentence 2/)

    # Watch out for this!
    # http://stackoverflow.com/questions/8964537/rails-3-1-capybara-webkit-how-to-execute-javascript-inside-link
    page.should have_text("Front:")
  end
end
