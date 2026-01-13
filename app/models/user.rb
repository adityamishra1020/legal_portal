# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  role            :string           default: "user"
#  type            :string           (STI - Admin, Lawyer, Staff, User)
#  phone           :string
#  address         :text
#  is_active       :boolean          default: true
#  last_login_at   :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Lawyer specific fields:
#  specialization  :string
#  experience      :integer
#  bar_council_no  :string
#  bio             :text
#  education       :string
#  languages       :string
#  rating          :decimal(3, 2)
#  consultation_fee:decimal(10, 2)
#  status          :string
#  location        :string
#
# Admin specific fields:
#  admin_type      :string
#
# Staff specific fields:
#  department      :string
#  access_level    :string
#

class User < ApplicationRecord
  has_secure_password

  # STI: type column determines the class
  # Admin < User, Lawyer < User, Staff < User, User < User

  # Enums for base user
  enum role: {
    admin: 'admin',
    lawyer: 'lawyer',
    staff: 'staff',
    user: 'user'
  }

  # Global scopes
  scope :active, -> { where(is_active: true) }
  scope :by_role, ->(role) { where(role: role) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(type: type) if type.present? }
  scope :lawyers, -> { where(type: 'Lawyer') }
  scope :admins, -> { where(type: 'Administrator') }
  scope :staffs, -> { where(type: 'Staff') }
  scope :regular_users, -> { where(type: 'User') }

  # Base validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :role, presence: true, inclusion: { in: roles.keys }

  # Instance methods - override in subclasses
  def admin?; false; end
  def lawyer?; false; end
  def staff?; false; end
  def regular_user?; false; end

  def can_access_admin?
    admin? || lawyer? || staff?
  end

  def can_manage_complaints?
    admin? || lawyer? || staff?
  end

  def can_view_all_complaints?
    admin? || staff?
  end

  def display_name
    name.titleize
  end

  def role_name
    self.class.name
  end

  def active?
    is_active?
  end

  def suspended?
    status == 'suspended'
  end

  def pending?
    status == 'pending'
  end

  def last_login_formatted
    last_login_at&.strftime("%d %b %Y, %I:%M %p") || 'Never'
  end

  def joined_date
    created_at.strftime("%B %Y")
  end

  def avatar_url
    "https://ui-avatars.com/api/?name=#{name}&background=random"
  end

  def update_last_login
    update(last_login_at: Time.current)
  end

  # Class methods for STI queries
  def self.sti_classes
    [User, Administrator, Lawyer, Staff]
  end

  def self.find_by_role(role)
    case role.to_s
    when 'admin' then Administrator.all
    when 'lawyer' then Lawyer.all
    when 'staff' then Staff.all
    else User.all
    end
  end
end
