class CreateComplaintsAndTypes < ActiveRecord::Migration[7.0]
  def change
    # Main complaints table
    create_table :complaints do |t|
      t.string :complaint_type, null: false
      t.string :user_name, null: false
      t.string :user_email, null: false
      t.string :user_phone, null: false
      t.string :subject, null: false
      t.text :description, null: false
      t.decimal :amount, precision: 10, scale: 2, default: 0.0
      t.string :status, default: 'submitted'
      t.json :documents
      t.json :metadata
      t.timestamps
    end

    add_index :complaints, :complaint_type
    add_index :complaints, :status
    add_index :complaints, :user_email
    add_index :complaints, :created_at

    # Employment complaints table
    create_table :employment_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :employer_name
      t.string :employer_contact
      t.text :employer_address
      t.string :designation
      t.date :date_of_joining
      t.date :date_of_termination
      t.decimal :salary_amount, precision: 10, scale: 2
      t.integer :pending_salary_months
      t.string :nature_of_dispute
      t.string :hr_contact
      t.timestamps
    end

    # Student coaching complaints table
    create_table :student_coaching_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :institute_name
      t.string :institute_contact
      t.text :institute_address
      t.string :course_name
      t.string :enrollment_number
      t.date :enrollment_date
      t.string :batch_timing
      t.decimal :total_fees, precision: 10, scale: 2
      t.decimal :fees_paid, precision: 10, scale: 2
      t.decimal :fees_pending, precision: 10, scale: 2
      t.decimal :refund_amount, precision: 10, scale: 2
      t.string :nature_of_complaint
      t.string :admission_medium
      t.string :faculty_name
      t.timestamps
    end

    # Consumer complaints table
    create_table :consumer_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :product_name
      t.string :product_brand
      t.date :purchase_date
      t.string :purchase_place
      t.string :order_number
      t.decimal :product_price, precision: 10, scale: 2
      t.text :defect_description
      t.string :nature_of_defect
      t.string :warranty_period
      t.string :seller_name
      t.string :seller_contact
      t.string :brand_contact
      t.boolean :replacement_requested
      t.boolean :refund_requested
      t.boolean :repair_requested
      t.timestamps
    end

    # Property complaints table
    create_table :property_complaints do |t|
      t.references :complaint, null: false, foreign_key: true
      t.string :builder_name
      t.string :builder_contact
      t.string :project_name
      t.text :project_address
      t.string :property_number
      t.string :tower_block
      t.string :property_type
      t.date :booking_date
      t.date :possession_date
      t.string :possession_status
      t.decimal :amount_paid, precision: 10, scale: 2
      t.decimal :total_amount, precision: 10, scale: 2
      t.string :nature_of_complaint
      t.string :registration_number
      t.timestamps
    end

    # Add more tables as needed (student_college, financial, matrimonial, rental)
  end
end
