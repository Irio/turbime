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

  def auth_omniauth(provider, user_info = {})
    user_info = { name: "Juquinha da Rocha", email: "juquinha@turbi.me" }.merge(user_info)

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
       :provider => provider,
       :uid => '123123',
       :info => user_info
     )
  end

  def sign_up_via(provider, attrs)
    auth_omniauth(provider, attrs)

    visit "/"
    click_on "SIGN UP"
    click_on "Sign in with Facebook"
  end

  def sign_in_via(provider, attrs)
    auth_omniauth(provider, attrs)

    visit "/"
    click_on "LOGIN"
    click_on "Sign in with Facebook"
  end
end
