class ProjectsController < InheritedResources::Base
  actions :all, except: [:destroy]
  before_filter :authenticate_user!, except: [:index]
end
