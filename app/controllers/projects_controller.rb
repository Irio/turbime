class ProjectsController < InheritedResources::Base
  actions :all, except: [:destroy]
  load_and_authorize_resource only: [:edit, :update]

  before_filter :authenticate_user!, except: [:index]
  before_filter :assign_user_id, only: [:create]

  def update
    unless params[:project].nil?
      params[:project].reject! { |attr| @project.cannot_edit?(attr) }
    end
    update!
  end

  protected
  def assign_user_id
    params[:project][:user_id] = current_user.id if params[:project]
  end
end
