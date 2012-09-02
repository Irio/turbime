class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    render file: File.join(Rails.root, %w(public 401.html)), layout: false
  end

  protected
  def render_404
    raise ActionController::RoutingError.new('Not Found')
  end
end
