# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_01_13_212537) do
  create_table "complaints", force: :cascade do |t|
    t.string "complaint_type", null: false
    t.string "user_name", null: false
    t.string "user_email", null: false
    t.string "user_phone", null: false
    t.string "subject", null: false
    t.text "description", null: false
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.string "status", default: "submitted"
    t.json "documents"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_type"], name: "index_complaints_on_complaint_type"
    t.index ["created_at"], name: "index_complaints_on_created_at"
    t.index ["status"], name: "index_complaints_on_status"
    t.index ["user_email"], name: "index_complaints_on_user_email"
  end

  create_table "consumer_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "product_name"
    t.string "product_brand"
    t.date "purchase_date"
    t.string "purchase_place"
    t.string "order_number"
    t.decimal "product_price", precision: 10, scale: 2
    t.text "defect_description"
    t.string "nature_of_defect"
    t.string "warranty_period"
    t.string "seller_name"
    t.string "seller_contact"
    t.string "brand_contact"
    t.boolean "replacement_requested"
    t.boolean "refund_requested"
    t.boolean "repair_requested"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_consumer_complaints_on_complaint_id"
  end

  create_table "employment_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "employer_name"
    t.string "employer_contact"
    t.text "employer_address"
    t.string "designation"
    t.date "date_of_joining"
    t.date "date_of_termination"
    t.decimal "salary_amount", precision: 10, scale: 2
    t.integer "pending_salary_months"
    t.string "nature_of_dispute"
    t.string "hr_contact"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_employment_complaints_on_complaint_id"
  end

  create_table "financial_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "institution_name"
    t.string "institution_branch"
    t.string "institution_contact"
    t.text "institution_address"
    t.string "account_number"
    t.string "nature_of_complaint"
    t.string "financial_institution_type"
    t.decimal "amount_involved", precision: 12, scale: 2
    t.date "incident_date"
    t.string "transaction_reference"
    t.boolean "police_complaint_filed"
    t.boolean "regulator_complaint_filed"
    t.text "additional_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amount_involved"], name: "index_financial_complaints_on_amount_involved"
    t.index ["complaint_id"], name: "index_financial_complaints_on_complaint_id"
    t.index ["institution_name"], name: "index_financial_complaints_on_institution_name"
    t.index ["nature_of_complaint"], name: "index_financial_complaints_on_nature_of_complaint"
  end

  create_table "matrimonial_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "respondent_name"
    t.string "respondent_contact"
    t.text "respondent_address"
    t.string "marriage_type"
    t.date "marriage_date"
    t.string "marriage_place"
    t.string "nature_of_complaint"
    t.string "petitioner_name"
    t.integer "children_count"
    t.boolean "maintenance_claimed"
    t.decimal "maintenance_amount", precision: 10, scale: 2
    t.boolean "custody_needed"
    t.boolean "stridhan_claimed"
    t.text "additional_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_matrimonial_complaints_on_complaint_id"
    t.index ["nature_of_complaint"], name: "index_matrimonial_complaints_on_nature_of_complaint"
    t.index ["respondent_name"], name: "index_matrimonial_complaints_on_respondent_name"
  end

  create_table "property_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "builder_name"
    t.string "builder_contact"
    t.string "project_name"
    t.text "project_address"
    t.string "property_number"
    t.string "tower_block"
    t.string "property_type"
    t.date "booking_date"
    t.date "possession_date"
    t.string "possession_status"
    t.decimal "amount_paid", precision: 10, scale: 2
    t.decimal "total_amount", precision: 10, scale: 2
    t.string "nature_of_complaint"
    t.string "registration_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_property_complaints_on_complaint_id"
  end

  create_table "rental_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "landlord_name"
    t.string "landlord_contact"
    t.text "landlord_address"
    t.string "tenant_name"
    t.string "tenant_contact"
    t.text "property_address"
    t.string "property_type"
    t.string "tenant_type"
    t.decimal "monthly_rent", precision: 8, scale: 2
    t.decimal "security_deposit", precision: 10, scale: 2
    t.date "lease_start_date"
    t.date "lease_end_date"
    t.string "nature_of_complaint"
    t.boolean "rent_receipt_available"
    t.boolean "lease_agreement_available"
    t.text "additional_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_rental_complaints_on_complaint_id"
    t.index ["landlord_name"], name: "index_rental_complaints_on_landlord_name"
    t.index ["nature_of_complaint"], name: "index_rental_complaints_on_nature_of_complaint"
    t.index ["property_address"], name: "index_rental_complaints_on_property_address"
  end

  create_table "student_coaching_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "institute_name"
    t.string "institute_contact"
    t.text "institute_address"
    t.string "course_name"
    t.string "enrollment_number"
    t.date "enrollment_date"
    t.string "batch_timing"
    t.decimal "total_fees", precision: 10, scale: 2
    t.decimal "fees_paid", precision: 10, scale: 2
    t.decimal "fees_pending", precision: 10, scale: 2
    t.decimal "refund_amount", precision: 10, scale: 2
    t.string "nature_of_complaint"
    t.string "admission_medium"
    t.string "faculty_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["complaint_id"], name: "index_student_coaching_complaints_on_complaint_id"
  end

  create_table "student_college_complaints", force: :cascade do |t|
    t.integer "complaint_id", null: false
    t.string "college_name"
    t.string "college_contact"
    t.text "college_address"
    t.string "course_name"
    t.string "enrollment_number"
    t.date "admission_date"
    t.string "student_name"
    t.string "student_roll_number"
    t.string "year_of_study"
    t.decimal "total_fees", precision: 10, scale: 2
    t.decimal "fees_paid", precision: 10, scale: 2
    t.decimal "fees_pending", precision: 10, scale: 2
    t.string "nature_of_complaint"
    t.string "admission_medium"
    t.string "faculty_name"
    t.boolean "has_receipts"
    t.text "additional_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["college_name"], name: "index_student_college_complaints_on_college_name"
    t.index ["complaint_id"], name: "index_student_college_complaints_on_complaint_id"
    t.index ["nature_of_complaint"], name: "index_student_college_complaints_on_nature_of_complaint"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.string "role", default: "user"
    t.string "phone"
    t.text "address"
    t.boolean "is_active", default: true
    t.string "status", default: "active"
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "specialization"
    t.integer "experience"
    t.string "bar_council_no"
    t.text "bio"
    t.string "education"
    t.string "languages"
    t.decimal "rating", precision: 3, scale: 2
    t.decimal "consultation_fee", precision: 10, scale: 2
    t.string "location"
    t.string "admin_type"
    t.string "department"
    t.string "access_level"
    t.index ["bar_council_no"], name: "index_users_on_bar_council_no", unique: true
    t.index ["department"], name: "index_users_on_department"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["is_active"], name: "index_users_on_is_active"
    t.index ["location"], name: "index_users_on_location"
    t.index ["role"], name: "index_users_on_role"
    t.index ["specialization"], name: "index_users_on_specialization"
    t.index ["type"], name: "index_users_on_type"
  end

  add_foreign_key "consumer_complaints", "complaints"
  add_foreign_key "employment_complaints", "complaints"
  add_foreign_key "financial_complaints", "complaints"
  add_foreign_key "matrimonial_complaints", "complaints"
  add_foreign_key "property_complaints", "complaints"
  add_foreign_key "rental_complaints", "complaints"
  add_foreign_key "student_coaching_complaints", "complaints"
  add_foreign_key "student_college_complaints", "complaints"
end
