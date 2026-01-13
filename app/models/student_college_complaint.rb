class StudentCollegeComplaint < ApplicationRecord
  self.table_name = 'student_college_complaints'

  belongs_to :complaint, inverse_of: :student_college_complaint, optional: true

  enum nature_of_complaint: {
    admission_issues: 'admission_issues',
    fee_dispute: 'fee_dispute',
    marks_issues: 'marks_issues',
    certificate_issues: 'certificate_issues',
    ragging: 'ragging',
    harassment: 'harassment',
    infrastructure_issues: 'infrastructure_issues',
    faculty_issues: 'faculty_issues',
    placement_issues: 'placement_issues',
    other: 'other'
  }

  enum admission_medium: {
    merit: 'merit',
    management: 'management',
    nri: 'nri',
    sports: 'sports',
    quota: 'quota'
  }

  validates :college_name, presence: true, length: { minimum: 2, maximum: 150 }
  validates :nature_of_complaint, presence: true, inclusion: { in: nature_of_complaints.keys }

  accepts_nested_attributes_for :complaint

  def build_complaint(attributes = {})
    complaint || build_complaint(attributes)
  end

  def self.create_with_complaint(complaint_attrs, specific_attrs)
    transaction do
      complaint = Complaint.create!(complaint_attrs)
      specific = create!(specific_attrs.merge(complaint_id: complaint.id))
      [complaint, specific]
    end
  end
end
