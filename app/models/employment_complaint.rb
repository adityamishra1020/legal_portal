# Employment Complaint specific fields and validations
#
# Table name: employment_complaints
#
#  id                  :integer          not null, primary key
#  complaint_id        :integer          not null, foreign key
#  employer_name       :string
#  employer_contact    :string
#  employer_address    :text
#  designation         :string
#  date_of_joining     :date
#  date_of_termination :date
#  salary_amount       :decimal(10, 2)
#  pending_salary_months :integer
#  nature_of_dispute   :string
#  hr_contact          :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class EmploymentComplaint < ApplicationRecord
  self.table_name = 'employment_complaints'

  # Associations
  belongs_to :complaint, inverse_of: :employment_complaint, optional: true

  # Enums for nature of dispute
  enum nature_of_dispute: {
    salary_not_paid: 'salary_not_paid',
    wrong_termination: 'wrong_termination',
    harassment: 'harassment',
    discrimination: 'discrimination',
    contract_violation: 'contract_violation',
    pf_esi_issues: 'pf_esi_issues',
    bonus_not_paid: 'bonus_not_paid',
    overtime_not_paid: 'overtime_not_paid',
    resignation_not_accepted: 'resignation_not_accepted',
    other: 'other'
  }

  # Validations
  validates :employer_name, presence: true, length: { minimum: 2, maximum: 150 }
  validates :nature_of_dispute, presence: true, inclusion: { in: nature_of_disputes.keys }

  # Nested attributes for complaint
  accepts_nested_attributes_for :complaint

  # Instance method to build associated complaint
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
