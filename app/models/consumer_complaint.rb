# Consumer Complaint specific fields and validations
#
# Table name: consumer_complaints
#
#  id                  :integer          not null, primary key
#  complaint_id        :integer          not null, foreign key
#  product_name        :string
#  product_brand       :string
#  purchase_date       :date
#  purchase_place      :string
#  order_number        :string
#  product_price       :decimal(10, 2)
#  defect_description  :text
#  nature_of_defect    :string
#  warranty_period     :string
#  seller_name         :string
#  seller_contact      :string
#  brand_contact       :string
#  replacement_requested :boolean
#  refund_requested    :boolean
#  repair_requested    :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ConsumerComplaint < ApplicationRecord
  self.table_name = 'consumer_complaints'

  # Associations
  belongs_to :complaint, inverse_of: :consumer_complaint, optional: true

  # Enums for nature of defect
  enum nature_of_defect: {
    not_working: 'not_working',
    damaged: 'damaged',
    fake_product: 'fake_product',
    missing_parts: 'missing_parts',
    different_product: 'different_product',
    expired_product: 'expired_product',
    safety_issue: 'safety_issue',
    quality_issue: 'quality_issue',
    warranty_denied: 'warranty_denied',
    other: 'other'
  }

  # Validations
  validates :product_name, presence: true
  validates :product_price, numericality: { greater_than_or_equal_to: 0 }
  validates :purchase_date, presence: true

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
