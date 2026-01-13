class RentalComplaint < ApplicationRecord
  self.table_name = 'rental_complaints'

  belongs_to :complaint, inverse_of: :rental_complaint, optional: true

  enum nature_of_complaint: {
    deposit_not_returned: 'deposit_not_returned',
    rent_increase: 'rent_increase',
    maintenance_issues: 'maintenance_issues',
    eviction_unlawful: 'eviction_unlawful',
    harassment: 'harassment',
    illegal_terms: 'illegal_terms',
    property_damage: 'property_damage',
    neighbor_dispute: 'neighbor_dispute',
    water_electricity: 'water_electricity',
    other: 'other'
  }

  enum property_type: {
    apartment: 'apartment',
    house: 'house',
    flat: 'flat',
    pg: 'pg',
    commercial: 'commercial'
  }

  enum tenant_type: {
    residential: 'residential',
    commercial_tenant: 'commercial'
  }

  validates :property_address, presence: true
  validates :landlord_name, presence: true, length: { minimum: 2, max_length: 100 }
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
