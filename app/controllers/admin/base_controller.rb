module Admin
  class BaseController < ApplicationController
    before_action :require_login
    before_action :authorize_admin
    layout :admin_layout

    private

    def authorize_admin
      redirect_to root_path, alert: "Admin access required." unless current_user&.can_access_admin?
    end

    def admin_layout
      "admin"
    end
  end
end
