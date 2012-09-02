class ProjectsController < InheritedResources::Base
  actions :all, except: [:destroy]
  load_and_authorize_resource only: [:edit, :update]

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :assign_user_id, only: [:create]

  def index
    @projects = Project.active
    index!
  end

  def create
    create! do |success, failure|
      success.html do
        redirect_to root_path, notice: t("projects.create.needs_approval")
      end
    end
  end

  def show
    @project = Project.find(params[:id])
    if @project.visible?
      show!
    else
      redirect_to root_path, notice: t("projects.show.needs_approval")
    end
  end

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
