class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?, :require_login

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to login_path, alert: "Please login to access this page." unless logged_in?
  end

  def check_authorization
    return unless current_user
    unless current_user.is_active?
      logout
      redirect_to login_path, alert: "Your account is #{current_user.status}. Please contact support."
    end
  end

  def logout
    session[:user_id] = nil
  end
end
