# Property Complaint specific fields and validations
#
# Table name: property_complaints
#
#  id                  :integer          not null, primary key
#  complaint_id        :integer          not null, foreign key
#  builder_name        :string
#  builder_contact     :string
#  project_name        :string
#  project_address     :text
#  property_number     :string
#  tower_block         :string
#  property_type       :string
#  booking_date        :date
#  possession_date     :date
#  possession_status   :string
#  amount_paid         :decimal(10, 2)
#  total_amount        :decimal(10, 2)
#  nature_of_complaint :string
#  registration_number :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class PropertyComplaint < ApplicationRecord
  self.table_name = 'property_complaints'

  # Associations
  belongs_to :complaint, inverse_of: :property_complaint, optional: true

  # Enums for nature of complaint
  enum nature_of_complaint: {
    delay_in_possession: 'delay_in_possession',
    builder_fraud: 'builder_fraud',
    quality_issues: 'quality_issues',
    registration_issues: 'registration_issues',
    hidden_charges: 'hidden_charges',
    false_promises: 'false_promises',
    possession_not_given: 'possession_not_given',
    legal_issues: 'legal_issues',
    maintenance_issues: 'maintenance_issues',
    other: 'other'
  }

  # Enums for property type
  enum property_type: {
    apartment: 'apartment',
    villa: 'villa',
    plot: 'plot',
    commercial: 'commercial',
    penthouse: 'penthouse',
    studio: 'studio'
  }

  # Enums for possession status
  enum possession_status: {
    not_delivered: 'not_delivered',
    delayed: 'delayed',
    delivered_with_issues: 'delivered_with_issues',
    delivered_clean: 'delivered_clean'
  }

  # Validations
  validates :builder_name, presence: true, length: { minimum: 2, maximum: 150 }
  validates :project_name, presence: true
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, numericality: { greater_than_or_equal_to: 0 }

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
