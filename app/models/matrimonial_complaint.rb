class MatrimonialComplaint < ApplicationRecord
  self.table_name = 'matrimonial_complaints'

  belongs_to :complaint, inverse_of: :matrimonial_complaint, optional: true

  enum nature_of_complaint: {
    dowry: 'dowry',
    domestic_violence: 'domestic_violence',
    desertion: 'desertion',
    adultery: 'adultery',
    cruelty: 'cruelty',
    mental_torture: 'mental_torture',
    property_dispute: 'property_dispute',
    maintenance_issues: 'maintenance_issues',
    child_custody: 'child_custody',
    other: 'other'
  }

  enum marriage_type: {
    hindu: 'hindu',
    muslim: 'muslim',
    christian: 'christian',
    special_marriage: 'special_marriage',
    court: 'court'
  }

  validates :respondent_name, presence: true, length: { minimum: 2, max_length: 100 }
  validates :nature_of_complaint, presence: true, inclusion: { in: nature_of_complaints.keys }
  validates :marriage_date, presence: true

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
