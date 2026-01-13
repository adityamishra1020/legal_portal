class CreateAdditionalComplaintTypes < ActiveRecord::Migration[7.0]
  def change
    # Student college complaints table
    create_table :student_college_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :college_name
      t.string :college_contact
      t.text :college_address
      t.string :course_name
      t.string :enrollment_number
      t.date :admission_date
      t.string :student_name
      t.string :student_roll_number
      t.string :year_of_study
      t.decimal :total_fees, precision: 10, scale: 2
      t.decimal :fees_paid, precision: 10, scale: 2
      t.decimal :fees_pending, precision: 10, scale: 2
      t.string :nature_of_complaint
      t.string :admission_medium
      t.string :faculty_name
      t.boolean :has_receipts
      t.text :additional_details
      t.timestamps
    end

    # Financial complaints table
    create_table :financial_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :institution_name
      t.string :institution_branch
      t.string :institution_contact
      t.text :institution_address
      t.string :account_number
      t.string :nature_of_complaint
      t.string :financial_institution_type
      t.decimal :amount_involved, precision: 12, scale: 2
      t.date :incident_date
      t.string :transaction_reference
      t.boolean :police_complaint_filed
      t.boolean :regulator_complaint_filed
      t.text :additional_details
      t.timestamps
    end

    # Matrimonial complaints table
    create_table :matrimonial_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :respondent_name
      t.string :respondent_contact
      t.text :respondent_address
      t.string :marriage_type
      t.date :marriage_date
      t.string :marriage_place
      t.string :nature_of_complaint
      t.string :petitioner_name
      t.integer :children_count
      t.boolean :maintenance_claimed
      t.decimal :maintenance_amount, precision: 10, scale: 2
      t.boolean :custody_needed
      t.boolean :stridhan_claimed
      t.text :additional_details
      t.timestamps
    end

    # Rental complaints table
    create_table :rental_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :landlord_name
      t.string :landlord_contact
      t.text :landlord_address
      t.string :tenant_name
      t.string :tenant_contact
      t.text :property_address
      t.string :property_type
      t.string :tenant_type
      t.decimal :monthly_rent, precision: 8, scale: 2
      t.decimal :security_deposit, precision: 10, scale: 2
      t.date :lease_start_date
      t.date :lease_end_date
      t.string :nature_of_complaint
      t.boolean :rent_receipt_available
      t.boolean :lease_agreement_available
      t.text :additional_details
      t.timestamps
    end

    add_index :student_college_complaints, :college_name
    add_index :student_college_complaints, :nature_of_complaint
    add_index :financial_complaints, :institution_name
    add_index :financial_complaints, :nature_of_complaint
    add_index :financial_complaints, :amount_involved
    add_index :matrimonial_complaints, :respondent_name
    add_index :matrimonial_complaints, :nature_of_complaint
    add_index :rental_complaints, :landlord_name
    add_index :rental_complaints, :nature_of_complaint
    add_index :rental_complaints, :property_address
  end
end
