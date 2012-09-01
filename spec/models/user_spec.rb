require 'spec_helper'

describe User do
  before do
    @user = User.make!
  end

  it "should valid" do
    @user.should be_valid
  end

  describe "password required?" do
    context "news users" do
      before do
        @user = User.new
      end

      it "requires a password" do
        @user.should be_password_required
      end

      it "should require password & match confirmation" do
        @user.password = nil
        @user.password_confirmation = nil
        @user.should_not be_valid

        @user.password = "Josemar"
        @user.password_confirmation = nil
        @user.should_not be_valid

        @user.password = "Josemar"
        @user.password_confirmation = "Luedke"
        @user.should_not be_valid
      end
    end

    context "existing user" do
      before do
        @user.save!
        @user = User.find @user.id
        end

      it "requires a password when password is present" do
        @user.password = 'josemar'
        @user.should be_password_required
      end

      it "requires a correct password when password_comfirmation is present" do
        @user.password_confirmation = 'xx'
        @user.should be_password_required
      end

      it "should not require password no password or confirmation is present" do
        @user.reload.should_not be_password_required
      end

      it "shoult not be required password" do
        @user.password = nil
        @user.password_confirmation = nil
        @user.should be_valid
      end
    end
  end

  describe "validations" do
    subject { @user }

    it{ should validate_presence_of :name }
    it{ should validate_presence_of :email }
    it{ should validate_presence_of :password }
  end

  describe "urls" do
    subject { User.make!(email: "url@turbi.me") }
    let(:url_with_http) { "http://www.turbi.me/" }
    let(:url_without_http) { "www.turbi.me" }

    it "accepts urls with http" do
      subject.github = url_with_http
      subject.twitter = url_with_http
      subject.facebook = url_with_http
      subject.site = url_with_http
      should have(0).error_on(:github)
      should have(0).error_on(:twitter)
      should have(0).error_on(:facebook)
      should have(0).error_on(:site)
    end

    it "dont accepts urls without http" do
      subject.github = url_without_http
      subject.twitter = url_without_http
      subject.facebook = url_without_http
      subject.site = url_without_http
      should have_at_least(1).error_on(:github)
      should have_at_least(1).error_on(:twitter)
      should have_at_least(1).error_on(:facebook)
      should have_at_least(1).error_on(:site)
    end
  end
end
