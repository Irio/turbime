class SupportsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :assign_user_id_and_project_id, only: [:create]
  actions :new, :create

  def create
    create! { project_url(resource.project.id) }
  end

  protected
  def assign_user_id_and_project_id
    params[:support][:user_id] = current_user.id if params[:support]
    params[:support][:project_id] = params[:project_id]
  end
end
