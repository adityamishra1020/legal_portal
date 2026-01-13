# Base policy class for Authorization
# Usage:
#   policy = ComplaintPolicy.new(current_user, complaint)
#   policy.show?
#   policy.update?
#
# In controllers:
#   authorize @complaint  # Raises exception if not authorized
#   policy = policy_scope(@complaint)  # Get scoped collection

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  # Default permissions - override in subclasses
  def index?; false; end
  def show?; false; end
  def create?; false; end
  def new?; create?; end
  def update?; false; end
  def edit?; update?; end
  def destroy?; false; end
  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private

  def admin?
    user&.admin?
  end

  def lawyer?
    user&.lawyer?
  end

  def staff?
    user&.staff?
  end

  def regular_user?
    user&.regular_user?
  end

  def authenticated?
    user.present?
  end

  def owner?
    return false unless user && record
    if record.is_a?(User)
      record.id == user.id
    else
      record.respond_to?(:user_id) && record.user_id == user.id
    end
  end

  def assigned_lawyer?
    record.respond_to?(:lawyer_id) && record.lawyer_id == user.id
  end
end
