require "spec_helper"

module AuthenticationHelpers
  def auth_user
    user = User.make!(email: "user_#{DateTime.current}@turbi.me", password: "123123", password_confirmation: "123123")
    visit "/"
    click_on "LOGIN"

    fill_in "Email", with: user.email
    fill_in "Password", with: "123123"

    click_on "Sign in"
    user
  end
end
