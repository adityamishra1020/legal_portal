class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_login
  after_action :verify_authorized, except: [:index]

  def index
    authorize_admin
    @users = User.all.order(created_at: :desc)
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_role
    authorize_admin
    @user = User.find(params[:id])
    if @user.update(role_params)
      redirect_to users_path, notice: "Role updated to #{@user.role}."
    else
      redirect_to users_path, alert: "Failed to update role."
    end
  end

  def toggle_status
    authorize_admin
    @user = User.find(params[:id])
    if @user.update(is_active: !@user.is_active)
      status = @user.is_active? ? "activated" : "deactivated"
      redirect_to users_path, notice: "User #{status} successfully."
    else
      redirect_to users_path, alert: "Failed to update status."
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone, :address)
  end

  def role_params
    params.require(:user).permit(:role)
  end

  def authorize_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.can_access_admin?
  end
end
