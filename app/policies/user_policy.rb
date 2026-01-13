# Policy for User model
# Defines who can manage users

class UserPolicy < ApplicationPolicy
  # Users can view their own profile
  def show?
    authenticated? && (owner? || admin? || staff?)
  end

  # Only admin can create users (registration handles own creation)
  def create?
    false # Use RegistrationsController for user creation
  end

  # Users can update their own profile
  def update?
    authenticated? && (owner? || admin? || staff?)
  end

  # Only admin can destroy users
  def destroy?
    admin?
  end

  # Admin can view all users, staff can view, users see only self
  def scope
    if admin?
      User.all
    elsif staff?
      User.all
    else
      User.where(id: user.id)
    end
  end

  # Admin/Staff can update roles
  def update_role?
    admin? || (staff? && user.manager?)
  end

  # Admin can activate/deactivate users
  def toggle_status?
    admin?
  end

  # Admin can view sensitive data
  def view_sensitive?
    admin? || staff?
  end

  # Admin can view login history
  def view_login_history?
    admin?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin? || user.staff?
        scope.all
      else
        scope.where(id: user.id)
      end
    end
  end
end
