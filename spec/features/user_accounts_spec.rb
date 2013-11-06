require "spec_helper"
# Needed to prevent "Circular dependency detected while autoloading
# constant Card" when run under guard.
require_relative "../../app/controllers/api/v1/cards_controller"

feature "User accounts", :js => true do
  scenario "Test drive, then sign up" do
    # Start working on something.
    visit '/'
    page.should have_content("Sign Up")
    fill_in_html "#front", with: "suis"
    fill_in_html "#back", with: "suis = am"

    # Go make an account.
    sign_up

    # Our content should still be there.
    page.should have_content("Front:")
    expect_html_to_match('#front', /suis/)
  end

  scenario "Sign up, out and in" do
    visit '/'

    first(:link, "Sign Up").click
    find("input[placeholder='Email']").set("user@example.com")
    find("input[placeholder='Password']").set("password")
    find("input[placeholder='Password confirmation']").set("password")
    click_button "Sign Up"
    page.should have_content("Front:")
    page.should have_content("Your account has been created")

    click_link "Sign Out"
    page.should have_content("Sign In")

    first(:link, "Sign In").click
    find("input[placeholder='Email']").set("user@example.com")
    find("input[placeholder='Password']").set("password")
    click_button "Sign In"
    page.should have_content("Sign Out")
    page.should_not have_content("Sign Up")

    wait_for_jquery
  end

  scenario "Sign in persists across page reload" do
    visit '/'
    sign_up
    # This will force a reload.
    visit '/'
    page.should have_content("Sign Out")
  end

  scenario "'Remember me' during sign in should cause sessions to persist" do
    user = FactoryGirl.create(:user, password: "pw", password_confirmation: "pw")

    # Sign in.
    visit '/'
    first(:link, "Sign In").click
    find("input[placeholder='Email']").set(user.email)
    find("input[placeholder='Password']").set("pw")
    check "Remember me"
    click_button "Sign In"
    page.should have_content("Sign Out")

    # Expire our session cookie and try again.
    expire_cookies
    visit '/'
    page.should have_content("Sign Out")
  end

  scenario "Sign up with an existing account fails" do
    user = FactoryGirl.create(:user)
    visit '/'

    first(:link, "Sign Up").click
    find("input[placeholder='Email']").set(user.email)
    find("input[placeholder='Password']").set("password2")
    find("input[placeholder='Password confirmation']").set("password2")
    click_button "Sign Up"

    page.should have_content("Could not create an account")
  end

  scenario "Sign in to non-existant account fails" do
    visit '/'
    first(:link, "Sign In").click
    find("input[placeholder='Email']").set("user@example.com")
    find("input[placeholder='Password']").set("password")
    click_button "Sign In"
    page.should have_content("Please double-check your username and password.")
  end

  scenario "Try to sign up with invalid information" do
    visit '/'
    first(:link, "Sign Up").click

    # No data.
    page.find_button("Sign Up", disabled: true).should be_disabled

    # Email only.
    find("input[placeholder='Email']").set("user@example.com")
    page.find_button("Sign Up", disabled: true).should be_disabled

    # Unconfirmed password.
    find("input[placeholder='Password']").set("password")
    page.find_button("Sign Up", disabled: true).should be_disabled

    # Confirm password (can sign in).
    find("input[placeholder='Password confirmation']").set("password")
    page.find_button("Sign Up").should_not be_disabled

    # Invalid email.
    find("input[placeholder='Email']").set("user")
    page.find_button("Sign Up", disabled: true).should be_disabled

    # Email missing.
    find("input[placeholder='Email']").set("")
    page.find_button("Sign Up", disabled: true).should be_disabled
  end

  scenario "Try to sign in with invalid information" do
    visit '/'
    first(:link, "Sign In").click

    # No password.
    find("input[placeholder='Email']").set("user@example.com")
    page.find_button("Sign In", disabled: true).should be_disabled

    # Invalid email.
    find("input[placeholder='Email']").set("user")
    fill_in "Password", with: "password"
    page.find_button("Sign In", disabled: true).should be_disabled

    # No email.
    find("input[placeholder='Email']").set("")
    page.find_button("Sign In", disabled: true).should be_disabled
  end
end
