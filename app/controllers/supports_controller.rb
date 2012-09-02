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
        success_callback_project_support_url(resource.project.id, resource.id),
        cancel_callback_project_support_url(resource.project.id, resource.id)
      )
      @support.update_attributes(payment_token: payment.token)

      format.html { redirect_to payment.redirect_uri }
    end
  end

  def success_callback
    support = Support.find_by_payment_token(params[:token])
    if support
      payment = Payment.new
      payment.token = params[:token]
      payment.payer_id = params[:PayerID]
      payment.amount = support.amount
      payment.complete!

      support.confirm!
      support.update_attributes(transaction_id: payment.identifier)
      redirect_to root_url, notice: t(".successful_payment")
    else
      render nothing: true, status: :unprocessable_entity
    end
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
