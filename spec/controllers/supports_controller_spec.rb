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
      post :create, project_id: project.id, support: { amount: 20, terms: "1" }
      new_support = Support.last
      new_support.user.should == user
      new_support.project.should == project
    end
  end

  describe "payment" do
    before { sign_in user }

=begin
    it "initializes a new payment" do
      Payment.should_receive(:new).with(20).and_return(double.as_null_object)
      Payment.any_instance.stub(:redirect_uri).and_return("http://turbi.me/")
      post :create, project_id: project.id, support: { amount: 20 }
    end
=end

    it "makes a call to setup! method" do
      SupportsController.any_instance.stub(:success_callback_project_support_url).and_return("http://success")
      SupportsController.any_instance.stub(:cancel_callback_project_support_url).and_return("http://cancel")
      Payment.any_instance.stub(:redirect_uri).and_return("http://turbi.me/")

      Payment.any_instance.should_receive(:setup!).with("http://success", "http://cancel").and_return(true)
      post :create, project_id: project.id, support: { amount: 20 }
    end
  end
end
