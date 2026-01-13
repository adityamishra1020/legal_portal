class FinancialComplaint < ApplicationRecord
  self.table_name = 'financial_complaints'

  belongs_to :complaint, inverse_of: :financial_complaint, optional: true

  enum nature_of_complaint: {
    bank_charges: 'bank_charges',
    loan_issues: 'loan_issues',
    insurance_claim: 'insurance_claim',
    credit_card: 'credit_card',
    investment_fraud: 'investment_fraud',
    ponzi_scheme: 'ponzi_scheme',
    unauthorized_transaction: 'unauthorized_transaction',
    account_freeze: 'account_freeze',
    poor_service: 'poor_service',
    other: 'other'
  }

  enum financial_institution_type: {
    bank: 'bank',
    nbfc: 'nbfc',
    insurance: 'insurance',
    mutual_fund: 'mutual_fund',
    stock_broker: 'stock_broker',
    crypto: 'crypto',
    other_institution: 'other'
  }

  validates :institution_name, presence: true, length: { minimum: 2, max_length: 150 }
  validates :nature_of_complaint, presence: true, inclusion: { in: nature_of_complaints.keys }
  validates :amount_involved, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

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
