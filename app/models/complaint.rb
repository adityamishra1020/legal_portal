# == Schema Information
#
# Table name: complaints
#
#  id              :integer          not null, primary key
#  complaint_type  :string           not null
#  user_name       :string           not null
#  user_email      :string           not null
#  user_phone      :string           not null
#  subject         :string           not null
#  description     :text             not null
#  amount          :decimal(10, 2)   default: 0.0
#  status          :string           default: "submitted"
#  documents       :json
#  metadata        :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Complaint < ApplicationRecord
  # Enums for complaint types
  enum complaint_type: {
    employment: 'employment',
    student_coaching: 'student_coaching',
    student_college: 'student_college',
    consumer: 'consumer',
    property: 'property',
    financial: 'financial',
    matrimonial: 'matrimonial',
    rental: 'rental'
  }

  # Enums for status
  enum status: {
    submitted: 'submitted',
    under_review: 'under_review',
    lawyer_assigned: 'lawyer_assigned',
    in_progress: 'in_progress',
    resolved: 'resolved',
    closed: 'closed'
  }

  # Associations
  has_one :employment_complaint, dependent: :destroy
  has_one :student_coaching_complaint, dependent: :destroy
  has_one :consumer_complaint, dependent: :destroy
  has_one :property_complaint, dependent: :destroy
  has_one :student_college_complaint, dependent: :destroy
  has_one :financial_complaint, dependent: :destroy
  has_one :matrimonial_complaint, dependent: :destroy
  has_one :rental_complaint, dependent: :destroy

  # Nested attributes
  accepts_nested_attributes_for :employment_complaint
  accepts_nested_attributes_for :student_coaching_complaint
  accepts_nested_attributes_for :consumer_complaint
  accepts_nested_attributes_for :property_complaint
  accepts_nested_attributes_for :student_college_complaint
  accepts_nested_attributes_for :financial_complaint
  accepts_nested_attributes_for :matrimonial_complaint
  accepts_nested_attributes_for :rental_complaint

  # Validations
  validates :user_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :user_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :user_phone, presence: true, format: { with: /\A\+?[0-9]{10,15}\z/ }
  validates :subject, presence: true, length: { minimum: 5, maximum: 200 }
  validates :description, presence: true, length: { minimum: 20 }
  validates :complaint_type, presence: true, inclusion: { in: complaint_types.keys }

  # Callbacks
  before_validation :set_default_status, on: :create

  # Scope for recent complaints
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(complaint_type: type) }
  scope :by_status, ->(status) { where(status: status) }

  # Custom finder for complaint type class
  def self.type_class
    "#{complaint_type}_complaint".classify.constantize
  end

  # Check if this complaint can be updated
  def editable?
    submitted? || under_review?
  end

  # Get the specific type instance if exists
  def type_specific
    return nil unless persisted?
    send("#{complaint_type}_complaint")
  end

  private

  def set_default_status
    self.status ||= :submitted
  end
end
