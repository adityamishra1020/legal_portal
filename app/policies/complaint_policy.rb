# Policy for Complaint model
# Defines who can do what with complaints

class ComplaintPolicy < ApplicationPolicy
  # Anyone can view public complaints
  def show?
    authenticated? && (owner? || assigned_lawyer? || admin? || staff?)
  end

  # Only authenticated users can create
  def create?
    authenticated?
  end

  # Owner can update if editable, admin/staff can update, assigned lawyer can update
  def update?
    return false unless authenticated?

    if owner? || admin? || staff?
      record.editable?
    elsif lawyer? && assigned_lawyer?
      record.in_progress? || record.lawyer_assigned?
    else
      false
    end
  end

  # Only admin or staff can destroy
  def destroy?
    admin? || staff?
  end

  # Admin/staff can list all, lawyers see assigned, owners see own
  def scope
    if admin? || staff?
      Complaint.all
    elsif lawyer?
      Complaint.where(lawyer_id: user.id)
    else
      Complaint.where(user_email: user.email)
    end
  end

  # Additional permissions
  def assign_lawyer?
    admin? || staff?
  end

  def resolve?
    return false unless authenticated?
    admin? || (lawyer? && assigned_lawyer?)
  end

  def change_status?
    admin? || staff? || (lawyer? && assigned_lawyer?)
  end

  def view_documents?
    show?
  end

  def upload_documents?
    authenticated? && (owner? || admin? || staff?)
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.admin? || user.staff?
        scope.all
      elsif user.lawyer?
        scope.where(lawyer_id: user.id)
      else
        scope.where(user_email: user.email)
      end
    end
  end
end
