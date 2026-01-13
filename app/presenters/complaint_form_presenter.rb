# View object for complaint forms
# Provides form data and helpers for different complaint types

class ComplaintFormPresenter
  # Get all available complaint types with metadata
  def self.complaint_types
    {
      employment: {
        name: 'Employment Dispute',
        icon: 'fa-briefcase',
        description: 'Salary issues, wrongful termination, workplace harassment',
        model: EmploymentComplaint,
        fields: employment_fields,
        requires_amount: true
      },
      student_coaching: {
        name: 'Student - Coaching',
        icon: 'fa-graduation-cap',
        description: 'Fee refunds, fake promises, quality issues',
        model: StudentCoachingComplaint,
        fields: student_coaching_fields,
        requires_amount: true
      },
      student_college: {
        name: 'Student - College',
        icon: 'fa-university',
        description: 'Admission issues, mark sheet problems',
        model: StudentCollegeComplaint,
        fields: student_college_fields,
        requires_amount: true
      },
      consumer: {
        name: 'Consumer Goods',
        icon: 'fa-shopping-cart',
        description: 'Defective products, warranty claims',
        model: ConsumerComplaint,
        fields: consumer_fields,
        requires_amount: true
      },
      property: {
        name: 'Property Dispute',
        icon: 'fa-home',
        description: 'Builder fraud, possession delay',
        model: PropertyComplaint,
        fields: property_fields,
        requires_amount: true
      },
      financial: {
        name: 'Banking & Finance',
        icon: 'fa-coins',
        description: 'Loan issues, insurance claims',
        model: FinancialComplaint,
        fields: financial_fields,
        requires_amount: true
      },
      matrimonial: {
        name: 'Matrimonial',
        icon: 'fa-rings-wedding',
        description: 'Divorce, maintenance, domestic violence',
        model: MatrimonialComplaint,
        fields: matrimonial_fields,
        requires_amount: false
      },
      rental: {
        name: 'Rental & Tenant',
        icon: 'fa-building',
        description: 'Security deposit, eviction, rent dispute',
        model: RentalComplaint,
        fields: rental_fields,
        requires_amount: true
      }
    }
  end

  # Get specific type metadata
  def self.for_type(type)
    complaint_types[type.to_sym]
  end

  # Employment form fields configuration
  def self.employment_fields
    [
      { name: :employer_name, label: 'Employer/Company Name', type: :text, required: true },
      { name: :employer_contact, label: 'Employer Contact', type: :tel, required: false },
      { name: :employer_address, label: 'Employer Address', type: :textarea, required: false },
      { name: :designation, label: 'Your Designation', type: :text, required: false },
      { name: :date_of_joining, label: 'Date of Joining', type: :date, required: false },
      { name: :date_of_termination, label: 'Date of Termination/Resignation', type: :date, required: false },
      { name: :salary_amount, label: 'Monthly Salary (₹)', type: :number, required: false },
      { name: :pending_salary_months, label: 'Pending Salary (Months)', type: :number, required: false },
      { name: :nature_of_dispute, label: 'Nature of Dispute', type: :select, required: true, options: EmploymentComplaint.nature_of_disputes.keys.map { |k| [k.titleize, k] } },
      { name: :hr_contact, label: 'HR Contact', type: :tel, required: false }
    ]
  end

  # Student coaching form fields configuration
  def self.student_coaching_fields
    [
      { name: :institute_name, label: 'Institute/Coaching Name', type: :text, required: true },
      { name: :institute_contact, label: 'Institute Contact', type: :tel, required: false },
      { name: :institute_address, label: 'Institute Address', type: :textarea, required: false },
      { name: :course_name, label: 'Course Name', type: :text, required: true },
      { name: :enrollment_number, label: 'Enrollment Number', type: :text, required: false },
      { name: :enrollment_date, label: 'Enrollment Date', type: :date, required: false },
      { name: :batch_timing, label: 'Batch Timing', type: :text, required: false },
      { name: :total_fees, label: 'Total Fees (₹)', type: :number, required: true },
      { name: :fees_paid, label: 'Fees Paid (₹)', type: :number, required: false },
      { name: :fees_pending, label: 'Fees Pending (₹)', type: :number, required: false },
      { name: :refund_amount, label: 'Refund Amount Claimed (₹)', type: :number, required: false },
      { name: :nature_of_complaint, label: 'Nature of Complaint', type: :select, required: true, options: StudentCoachingComplaint.nature_of_complaints.keys.map { |k| [k.titleize, k] } },
      { name: :admission_medium, label: 'Mode of Admission', type: :select, required: false, options: StudentCoachingComplaint.admission_media.keys.map { |k| [k.titleize, k] } },
      { name: :faculty_name, label: 'Faculty Name (if applicable)', type: :text, required: false }
    ]
  end

  # Consumer form fields configuration
  def self.consumer_fields
    [
      { name: :product_name, label: 'Product Name', type: :text, required: true },
      { name: :product_brand, label: 'Brand/Manufacturer', type: :text, required: false },
      { name: :purchase_date, label: 'Purchase Date', type: :date, required: true },
      { name: :purchase_place, label: 'Place of Purchase', type: :text, required: false },
      { name: :order_number, label: 'Order/Invoice Number', type: :text, required: false },
      { name: :product_price, label: 'Product Price (₹)', type: :number, required: true },
      { name: :defect_description, label: 'Describe the Defect/Issue', type: :textarea, required: true },
      { name: :nature_of_defect, label: 'Nature of Defect', type: :select, required: true, options: ConsumerComplaint.nature_of_defects.keys.map { |k| [k.titleize, k] } },
      { name: :warranty_period, label: 'Warranty Period (if any)', type: :text, required: false },
      { name: :seller_name, label: 'Seller Name', type: :text, required: false },
      { name: :seller_contact, label: 'Seller Contact', type: :tel, required: false },
      { name: :brand_contact, label: 'Brand Customer Care', type: :tel, required: false },
      { name: :replacement_requested, label: 'Requesting Replacement', type: :checkbox, required: false },
      { name: :refund_requested, label: 'Requesting Refund', type: :checkbox, required: false },
      { name: :repair_requested, label: 'Requesting Repair', type: :checkbox, required: false }
    ]
  end

  # Property form fields configuration
  def self.property_fields
    [
      { name: :builder_name, label: 'Builder/Developer Name', type: :text, required: true },
      { name: :builder_contact, label: 'Builder Contact', type: :tel, required: false },
      { name: :project_name, label: 'Project Name', type: :text, required: true },
      { name: :project_address, label: 'Project Address', type: :textarea, required: false },
      { name: :property_number, label: 'Property/Unit Number', type: :text, required: false },
      { name: :tower_block, label: 'Tower/Block Name', type: :text, required: false },
      { name: :property_type, label: 'Property Type', type: :select, required: false, options: PropertyComplaint.property_types.keys.map { |k| [k.titleize, k] } },
      { name: :booking_date, label: 'Booking Date', type: :date, required: false },
      { name: :possession_date, label: 'Promised Possession Date', type: :date, required: false },
      { name: :possession_status, label: 'Current Possession Status', type: :select, required: false, options: PropertyComplaint.possession_statuses.keys.map { |k| [k.titleize, k] } },
      { name: :amount_paid, label: 'Amount Paid (₹)', type: :number, required: true },
      { name: :total_amount, label: 'Total Property Value (₹)', type: :number, required: true },
      { name: :nature_of_complaint, label: 'Nature of Complaint', type: :select, required: true, options: PropertyComplaint.nature_of_complaints.keys.map { |k| [k.titleize, k] } },
      { name: :registration_number, label: 'Registration Number (if registered)', type: :text, required: false }
    ]
  end

  # Student college form fields configuration
  def self.student_college_fields
    [
      { name: :college_name, label: 'College/University Name', type: :text, required: true },
      { name: :college_contact, label: 'College Contact', type: :tel, required: false },
      { name: :course_name, label: 'Course Name', type: :text, required: false },
      { name: :student_name, label: 'Student Name', type: :text, required: false },
      { name: :enrollment_number, label: 'Enrollment Number', type: :text, required: false },
      { name: :year_of_study, label: 'Year of Study', type: :select, required: false, options: ['1st Year', '2nd Year', '3rd Year', '4th Year', 'Final Year'].map { |k| [k, k] } },
      { name: :admission_date, label: 'Date of Admission', type: :date, required: false },
      { name: :total_fees, label: 'Total Fees (₹)', type: :number, required: false },
      { name: :fees_paid, label: 'Fees Paid (₹)', type: :number, required: false },
      { name: :fees_pending, label: 'Fees Pending (₹)', type: :number, required: false },
      { name: :nature_of_complaint, label: 'Nature of Complaint', type: :select, required: true, options: StudentCollegeComplaint.nature_of_complaints.keys.map { |k| [k.titleize, k] } },
      { name: :admission_medium, label: 'Admission Medium', type: :select, required: false, options: StudentCollegeComplaint.admission_media.keys.map { |k| [k.titleize, k] } },
      { name: :additional_details, label: 'Additional Details', type: :textarea, required: false }
    ]
  end

  # Financial form fields configuration
  def self.financial_fields
    [
      { name: :institution_name, label: 'Bank/Financial Institution Name', type: :text, required: true },
      { name: :institution_type, label: 'Institution Type', type: :select, required: false, options: FinancialComplaint.financial_institution_types.keys.map { |k| [k.titleize, k] } },
      { name: :institution_branch, label: 'Branch Name', type: :text, required: false },
      { name: :account_number, label: 'Account Number', type: :text, required: false },
      { name: :amount_involved, label: 'Amount Involved (₹)', type: :number, required: false },
      { name: :incident_date, label: 'Date of Incident', type: :date, required: false },
      { name: :nature_of_complaint, label: 'Nature of Complaint', type: :select, required: true, options: FinancialComplaint.nature_of_complaints.keys.map { |k| [k.titleize, k] } },
      { name: :transaction_reference, label: 'Transaction Reference/ID', type: :text, required: false },
      { name: :police_complaint_filed, label: 'Police Complaint Filed?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :regulator_complaint_filed, label: 'Regulator Complaint Filed?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :additional_details, label: 'Additional Details', type: :textarea, required: false }
    ]
  end

  # Matrimonial form fields configuration
  def self.matrimonial_fields
    [
      { name: :respondent_name, label: 'Respondent Name (Spouse)', type: :text, required: true },
      { name: :marriage_type, label: 'Type of Marriage', type: :select, required: false, options: MatrimonialComplaint.marriage_types.keys.map { |k| [k.titleize, k] } },
      { name: :marriage_date, label: 'Date of Marriage', type: :date, required: true },
      { name: :marriage_place, label: 'Place of Marriage', type: :text, required: false },
      { name: :petitioner_name, label: 'Your Name', type: :text, required: false },
      { name: :nature_of_complaint, label: 'Nature of Complaint', type: :select, required: true, options: MatrimonialComplaint.nature_of_complaints.keys.map { |k| [k.titleize, k] } },
      { name: :children_count, label: 'Number of Children', type: :number, required: false },
      { name: :maintenance_claimed, label: 'Maintenance Claimed?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :maintenance_amount, label: 'Maintenance Amount Claimed (₹)', type: :number, required: false },
      { name: :custody_needed, label: 'Child Custody Needed?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :stridhan_claimed, label: 'Stridhan Recoverable?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :additional_details, label: 'Additional Details', type: :textarea, required: false }
    ]
  end

  # Rental form fields configuration
  def self.rental_fields
    [
      { name: :landlord_name, label: 'Landlord Name', type: :text, required: true },
      { name: :landlord_contact, label: 'Landlord Contact', type: :tel, required: false },
      { name: :tenant_name, label: 'Tenant Name', type: :text, required: false },
      { name: :property_type, label: 'Property Type', type: :select, required: false, options: RentalComplaint.property_types.keys.map { |k| [k.titleize, k] } },
      { name: :property_address, label: 'Property Address', type: :textarea, required: true },
      { name: :monthly_rent, label: 'Monthly Rent (₹)', type: :number, required: false },
      { name: :security_deposit, label: 'Security Deposit (₹)', type: :number, required: false },
      { name: :lease_start_date, label: 'Lease Start Date', type: :date, required: false },
      { name: :lease_end_date, label: 'Lease End Date', type: :date, required: false },
      { name: :nature_of_complaint, label: 'Nature of Complaint', type: :select, required: true, options: RentalComplaint.nature_of_complaints.keys.map { |k| [k.titleize, k] } },
      { name: :rent_receipt_available, label: 'Rent Receipt Available?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :lease_agreement_available, label: 'Lease Agreement Available?', type: :select, required: false, options: [['No', false], ['Yes', true]] },
      { name: :additional_details, label: 'Additional Details', type: :textarea, required: false }
    ]
  end

  # Get fields for specific complaint type
  def self.fields_for(type)
    send("#{type}_fields")
  rescue NoMethodError
    []
  end

  # Check if type is valid
  def self.valid_type?(type)
    complaint_types.key?(type.to_sym)
  end
end
