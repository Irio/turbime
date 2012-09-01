class ProjectsController < InheritedResources::Base
  actions :all, except: [:destroy]
  before_filter :authenticate_user!, except: [:index]
  load_and_authorize_resource only: [:edit, :update]
end
