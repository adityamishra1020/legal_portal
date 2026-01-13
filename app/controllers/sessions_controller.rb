class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  skip_before_action :require_login, only: [:new, :create]

  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      if user.is_active?
        session[:user_id] = user.id
        user.update(last_login_at: Time.current)
        redirect_to root_path, notice: "Welcome back, #{user.name}!"
      else
        flash.now[:alert] = "Your account is #{user.status}. Please contact support."
        render :new
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "You have been logged out."
  end
end
