require 'spec_helper'

describe ProjectsController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "DELETE 'destroy'" do
    it "denies project's owner to delete it" do
      project = Project.make!
      sign_in project.user
      delete 'destroy', id: project.id

      project.should_not be_destroyed
      response.should redirect_to(new_user_session_path)
    end

    it "denies users to delete projects" do
      project = Project.make!
      sign_in User.make!
      delete 'destroy', id: project.id

      project.should_not be_destroyed
      response.should redirect_to(new_user_session_path)
    end
  end

end
