require "spec_helper"

feature "When creating an account" do

  scenario "Login with Facebook" do
    attrs = { name: "Juquinha da Rocha", email: "juquinha@turbi.me" }
    auth_omniauth(:facebook, name: attrs[:name], email: attrs[:email])

    visit "/"
    click_on "LOGIN"
    click_on "Sign in with Facebook"
    page.should have_css("input#user_name", value: attrs[:name])
    page.should have_css("input#user_email", value: attrs[:email])
  end

end
