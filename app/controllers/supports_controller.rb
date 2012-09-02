class SupportsController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :assign_user_id_and_project_id, only: [:create]
  actions :new, :create

  before_filter do
    @project = Project.find(params[:project_id])
  end

  def create
    create! do |format|
      payment = Payment.new resource.amount
      payment.setup!(
        success_callback_project_support_url(resource.project, resource),
        cancel_callback_project_support_url(resource.project, resource)
      )

      format.html { redirect_to payment.redirect_uri }
    end
  end

  def success_callback
    redirect_to root_url, notice: t(".successful_payment")
  end

  def cancel_callback
    redirect_to root_url, notice: t(".canceled_payment")
  end

  protected
  def assign_user_id_and_project_id
    params[:support][:user_id] = current_user.id if params[:support]
    params[:support][:project_id] = params[:project_id]
  end
end
