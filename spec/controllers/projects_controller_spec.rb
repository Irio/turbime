require 'spec_helper'

describe ProjectsController do
  let(:user) { User.make! }
  let(:project) { Project.make! user: user }
  describe "GET 'index'" do
    it "should returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    describe "without sign in" do
      it "shoult returns redirect to users sign in url" do
        get :new
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "with sign in" do
      before do
        sign_in user
      end

      it "should returns http success" do
        get :new
        response.should be_success
      end
    end
  end
  describe "GET 'edit'" do
    describe "without sign in" do
      it "shoult returns redirect to users sign in url" do
        get :edit, id: project.id
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "with sign in" do
      before do
        sign_in user
      end

      it "should returns http success" do
        get :edit, id: project.id
        response.should be_success
      end
    end
  end
end
