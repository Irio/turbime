require 'spec_helper'

describe UsersController do

  describe "GET 'show'" do
    let(:user) { User.make! }
    it "returns http success" do
      get :show, id: user.id
      response.should be_success
    end
  end

end
