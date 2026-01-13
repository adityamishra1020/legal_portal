class Administrator < User
  self.inheritance_column = nil

  # Admin-specific scopes
  scope :super_admins, -> { where(admin_type: 'super_admin') }
  scope :content_admins, -> { where(admin_type: 'content') }

  # Admin methods
  def admin?
    true
  end

  def super_admin?
    admin_type == 'super_admin'
  end

  def can_manage_all?
    super_admin?
  end

  def can_manage_users?
    true
  end

  def can_manage_content?
    true
  end
end
