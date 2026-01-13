class Staff < User
  enum department: {
    operations: 'operations',
    support: 'support',
    legal: 'legal',
    content: 'content',
    marketing: 'marketing',
    it: 'it',
    hr: 'hr',
    finance: 'finance'
  }

  enum access_level: {
    junior: 'junior',
    senior: 'senior',
    manager: 'manager',
    director: 'director'
  }

  # Scopes
  scope :by_department, ->(dept) { where(department: dept) if dept.present? }
  scope :by_access_level, ->(level) { where(access_level: level) if level.present? }
  scope :support_staff, -> { where(department: 'support') }
  scope :operations_staff, -> { where(department: 'operations') }

  # Validations
  validates :department, presence: true

  # Staff methods
  def staff?
    true
  end

  def department_name
    department.titleize
  end

  def access_level_name
    access_level.titleize
  end

  def can_manage_complaints?
    true
  end

  def can_view_all_complaints?
    true
  end

  def can_manage_users?
    access_level.in?(%w[manager director])
  end

  def can_access_financial?
    access_level.in?(%w[senior manager director])
  end
end
