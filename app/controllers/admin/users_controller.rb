module Admin
  class UsersController < BaseController
    def index
      @users = User.all.order(created_at: :desc)
      @users = @users.by_role(params[:role]) if params[:role].present?
      @users = @users.where(is_active: params[:active]) if params[:active].present?
      @users = @users.limit(100)
    end

    def update_role
      @user = User.find(params[:id])
      if @user.update(role: params[:role])
        redirect_to admin_users_path, notice: "Role updated to #{@user.role}."
      else
        redirect_to admin_users_path, alert: "Failed to update role."
      end
    end

    def toggle_status
      @user = User.find(params[:id])
      if @user.update(is_active: !@user.is_active)
        status = @user.is_active? ? "activated" : "deactivated"
        redirect_to admin_users_path, notice: "User #{status} successfully."
      else
        redirect_to admin_users_path, alert: "Failed to update status."
      end
    end
  end
end
