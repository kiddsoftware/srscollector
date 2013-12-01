require "spec_helper"

feature "Admin dashboard", :js => true do
  scenario "Admin users should be able to see the dashboard" do
    user = FactoryGirl.create(:user, email: "a@example.com", password: "a",
                              password_confirmation: "a", admin: true)
    visit "/"
    sign_in("a@example.com", "a")
    visit "/admin"
    page.should have_text("Dashboard")
  end

  scenario "Regular users should not be able to see the dashboard" do
    user = FactoryGirl.create(:user, email: "a@example.com", password: "a",
                              password_confirmation: "a", admin: false)
    visit "/"
    sign_in("a@example.com", "a")
    visit "/admin"
    page.should have_text("Sign Out")
    page.should_not have_text("Dashboard")
  end
end
