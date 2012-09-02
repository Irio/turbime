class UsersController < InheritedResources::Base
  actions :show

  def show
    show! do
      @projects = resource.projects.visible
    end
  end
end
