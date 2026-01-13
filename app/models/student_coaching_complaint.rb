# Student Coaching Complaint specific fields and validations
#
# Table name: student_coaching_complaints
#
#  id                  :integer          not null, primary key
#  complaint_id        :integer          not null, foreign key
#  institute_name      :string
#  institute_contact   :string
#  institute_address   :text
#  course_name         :string
#  enrollment_number   :string
#  enrollment_date     :date
#  batch_timing        :string
#  total_fees          :decimal(10, 2)
#  fees_paid           :decimal(10, 2)
#  fees_pending        :decimal(10, 2)
#  refund_amount       :decimal(10, 2)
#  nature_of_complaint :string
#  admission_medium    :string
#  faculty_name        :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class StudentCoachingComplaint < ApplicationRecord
  self.table_name = 'student_coaching_complaints'

  # Associations
  belongs_to :complaint, inverse_of: :student_coaching_complaint, optional: true

  # Enums for nature of complaint
  enum nature_of_complaint: {
    fake_promises: 'fake_promises',
    fees_not_refunded: 'fees_not_refunded',
    quality_issues: 'quality_issues',
    faculty_issues: 'faculty_issues',
    infrastructure_issues: 'infrastructure_issues',
    admission_cancellation: 'admission_cancellation',
    fake_certificates: 'fake_certificates',
    guarantee_not_met: 'guarantee_not_met',
    refund_not_processed: 'refund_not_processed',
    other: 'other'
  }

  # Enums for admission medium
  enum admission_medium: {
    online: 'online',
    offline: 'offline',
    hybrid: 'hybrid'
  }

  # Validations
  validates :institute_name, presence: true, length: { minimum: 2, maximum: 150 }
  validates :course_name, presence: true
  validates :total_fees, numericality: { greater_than_or_equal_to: 0 }

  # Nested attributes
  accepts_nested_attributes_for :complaint

  # Instance method
  def build_complaint(attributes = {})
    complaint || build_complaint(attributes)
  end

  # Class method to create with complaint
  def self.create_with_complaint(complaint_attrs, specific_attrs)
    transaction do
      complaint = Complaint.create!(complaint_attrs)
      specific = create!(specific_attrs.merge(complaint_id: complaint.id))
      [complaint, specific]
    end
  end
end
