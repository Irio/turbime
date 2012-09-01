require "spec_helper"

feature "Manage user" do

  scenario "Create a profile using manual sign up" do
    visit "/"
    click_on "SIGN_UP"
    fill_in "Name", with: "Juquinha"
    fill_in "Email", with: "juquinha@turbi.me"
    fill_in "Password", with: "123123"
    fill_in "Password confirmation", with: "123123"
    click_on "Sign Up"

    page.should_not have_content("LOGIN")
  end

  scenario "Edit profile without fill github, twitter, facebook and site url" do
    auth_user
    visit "/"
    click_on "Edit profile"

    fill_in "Name", with: "Juquinha da Rocha"
    fill_in "Email", with: "juquinha@turbi.me"
    fill_in "Password", with: "123123123"
    fill_in "Password confirmation", with: "123123123"
    fill_in "Current password", with: "123123"

    page.should have_content("You updated your account successfully.")
  end

end
