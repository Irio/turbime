require 'spec_helper'

describe ProjectsController do
  let(:user) { User.make! }
  let(:project) { Project.make! user: user }
  let(:user_whitout_project) { User.make! email: "email@xample.com" }
  describe "GET 'index'" do
    it "should returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    describe "without sign in" do
      it "should returns redirect to users sign in url" do
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
    describe "when signed in" do
      before do
        sign_in user
      end

      it "should returns http success" do
        get :edit, id: project.id
        response.should be_success
      end
    end
  end

  describe "auhorizations" do
    describe "edit" do
      it "signed in with project owner" do
        sign_in user
        get :edit, id: project.id
        response.should be_success
      end

      it "signed in without project owner" do
        sign_in user_whitout_project
        lambda { get :edit, id: project.id }.should raise_error(CanCan::AccessDenied)
      end
    end
    describe "update" do
      it "signed in with project owner" do
        sign_in user
        put :update, id: project.id
        response.should redirect_to(project_url(project))
      end

      it "signed in without project owner" do
        sign_in user_whitout_project
        lambda { put :update, id: project.id }.should raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe "#assign_user_id" do
    before do
      sign_in user
    end

    it "should assign current user id on create a new project" do
      post :create, project: {name: project.name,
                              description: project.description,
                              headline: project.headline,
                              goal: project.goal,
                              video: project.video}
      new_porject = Project.last
      response.should redirect_to(project_url(new_porject))
      new_porject.user.should == user
    end
  end
end
