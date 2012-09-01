require "spec_helper"

feature "When creating an account" do

  scenario "Login with Facebook" do
    attrs = { name: "Juquinha da Rocha", email: "juquinha@turbi.me" }
    sign_in_via(:provider, attrs)

    page.should have_css("input#user_name", value: attrs[:name])
    page.should have_css("input#user_email", value: attrs[:email])
  end

  scenario "Login with Twitter" do
    attrs = { name: "Juquinha da Rocha", email: "juquinha@turbi.me" }
    sign_in_via(:provider, attrs)

    page.should have_css("input#user_name", value: attrs[:name])
    page.should have_css("input#user_email", value: attrs[:email])
  end


end
