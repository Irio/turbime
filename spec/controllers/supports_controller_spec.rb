require 'spec_helper'

describe SupportsController do
  let(:user) { User.make! }
  let(:project) { Project.make! user: user }

  describe "GET 'new'" do
    describe "without sign in" do
      it "should returns redirect to users sign in url" do
        get :new, project_id: project.id
        response.should redirect_to(new_user_session_url)
      end
    end

    describe "with sign in" do
      before do
        sign_in user
      end

      it "should returns http success" do
        get :new, project_id: project.id
        response.should be_success
      end

      it "should has an error without project_id" do
        lambda { get :new }.should  raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "#assign_user_id_and_project_id" do
    before do
      sign_in user
    end

    it "should assign current user id and project id on create a new support" do
      post :create, project_id: project.id, support: { amount: 20 }
      new_support = Support.last
      response.should redirect_to(project_url(project.id))
      new_support.user.should == user
      new_support.project.should == project
    end
  end
end
