# Policy for Lawyer model
# Public browsing and management

class LawyerPolicy < ApplicationPolicy
  # Anyone can view public lawyer profiles
  def show?
    true # Public profiles
  end

  # Anyone can list lawyers
  def index?
    true # Public listing
  end

  # Lawyers can update their own profile
  def update?
    authenticated? && owner?
  end

  # Only admin can create lawyers
  def create?
    false # Use admin or registration
  end

  # Only admin can destroy
  def destroy?
    admin?
  end

  # Public scope - only available lawyers
  def scope
    Lawyer.available
  end

  # Admin can view all
  def all_lawyers_scope
    Lawyer.all if admin? || staff?
  end

  # Available for assignment
  def available_for_assignment?
    record.available? && record.active?
  end

  # Can be contacted
  def can_be_contacted?
    record.available? && record.active?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user&.admin? || user&.staff?
        Lawyer.all
      else
        Lawyer.available
      end
    end
  end
end
