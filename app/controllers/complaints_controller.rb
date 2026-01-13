# Controller for handling complaints
# Follows Rails 7 conventions with strong parameters and proper REST actions

class ComplaintsController < ApplicationController
  before_action :set_complaint, only: [:show, :edit, :update]

  # GET /complaints/new
  # Displays the complaint form with dynamic fields based on complaint type
  def new
    @complaint = Complaint.new
    @complaint_type = params[:category] || 'employment'
    
    # Initialize type-specific attributes if present
    @specific_class = specific_class_for(@complaint_type)
    @fields = ComplaintFormPresenter.fields_for(@complaint_type)
    @type_info = ComplaintFormPresenter.for_type(@complaint_type)
    
    # Build empty type-specific record
    @type_specific = @specific_class.new if @specific_class
  end

  # POST /complaints
  # Creates a new complaint with type-specific data
  def create
    @complaint_type = complaint_params[:complaint_type]
    @type_info = ComplaintFormPresenter.for_type(@complaint_type)
    @specific_class = specific_class_for(@complaint_type)
    @fields = ComplaintFormPresenter.fields_for(@complaint_type)
    
    @complaint = Complaint.new(complaint_params)

    if @complaint.save
      redirect_to @complaint, notice: 'Complaint submitted successfully! We will review your case shortly.'
    else
      @type_specific = @complaint.type_specific || @specific_class.new
      render :new, status: :unprocessable_entity
    end
  end

  # GET /complaints/:id
  # Shows complaint details and status
  def show
    @type_specific = @complaint.type_specific
    @type_info = ComplaintFormPresenter.for_type(@complaint.complaint_type)
  end

  # GET /complaints/my_complaints
  # Shows logged-in user's complaints
  def my_complaints
    @complaints = Complaint.where(user_email: current_user.email).order(created_at: :desc)
  end

  # GET /complaints/:id/edit
  # Edits complaint (only if editable)
  def edit
    unless @complaint.editable?
      redirect_to @complaint, alert: 'This complaint cannot be edited.'
      return
    end
    @complaint_type = @complaint.complaint_type
    @type_info = ComplaintFormPresenter.for_type(@complaint_type)
    @type_specific = @complaint.type_specific
  end

  # PATCH/PUT /complaints/:id
  # Updates complaint (only if editable)
  def update
    if @complaint.editable? && @complaint.update(complaint_params)
      redirect_to @complaint, notice: 'Complaint updated successfully.'
    else
      @complaint_type = @complaint.complaint_type
      @type_info = ComplaintFormPresenter.for_type(@complaint_type)
      @type_specific = @complaint.type_specific
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Set complaint from ID
  def set_complaint
    @complaint = Complaint.find(params[:id])
  end

  # Get specific class for complaint type
  def specific_class_for(type)
    "#{type}_complaint".classify.constantize rescue nil
  end

  # Strong parameters for base complaint with nested attributes
  def complaint_params
    params.require(:complaint).permit(
      :complaint_type,
      :user_name,
      :user_email,
      :user_phone,
      :subject,
      :description,
      :amount,
      employment_complaint_attributes: [:id, :employer_name, :employer_contact, :employer_address, :designation, :date_of_joining, :date_of_termination, :salary_amount, :pending_salary_months, :nature_of_dispute, :hr_contact],
      student_coaching_complaint_attributes: [:id, :institute_name, :institute_contact, :institute_address, :course_name, :enrollment_number, :enrollment_date, :batch_timing, :total_fees, :fees_paid, :fees_pending, :refund_amount, :nature_of_complaint, :admission_medium, :faculty_name],
      consumer_complaint_attributes: [:id, :product_name, :product_brand, :purchase_date, :purchase_place, :order_number, :product_price, :defect_description, :nature_of_defect, :warranty_period, :seller_name, :seller_contact, :brand_contact, :replacement_requested, :refund_requested, :repair_requested],
      property_complaint_attributes: [:id, :builder_name, :builder_contact, :project_name, :project_address, :property_number, :tower_block, :property_type, :booking_date, :possession_date, :possession_status, :amount_paid, :total_amount, :nature_of_complaint, :registration_number],
      student_college_complaint_attributes: [:id, :college_name, :college_contact, :college_address, :course_name, :enrollment_number, :admission_date, :student_name, :student_roll_number, :year_of_study, :total_fees, :fees_paid, :fees_pending, :nature_of_complaint, :admission_medium, :faculty_name, :has_receipts, :additional_details],
      financial_complaint_attributes: [:id, :institution_name, :institution_branch, :institution_contact, :institution_address, :account_number, :nature_of_complaint, :financial_institution_type, :amount_involved, :incident_date, :transaction_reference, :police_complaint_filed, :regulator_complaint_filed, :additional_details],
      matrimonial_complaint_attributes: [:id, :respondent_name, :respondent_contact, :respondent_address, :marriage_type, :marriage_date, :marriage_place, :nature_of_complaint, :petitioner_name, :children_count, :maintenance_claimed, :maintenance_amount, :custody_needed, :stridhan_claimed, :additional_details],
      rental_complaint_attributes: [:id, :landlord_name, :landlord_contact, :landlord_address, :tenant_name, :tenant_contact, :property_address, :property_type, :tenant_type, :monthly_rent, :security_deposit, :lease_start_date, :lease_end_date, :nature_of_complaint, :rent_receipt_available, :lease_agreement_available, :additional_details]
    )
  end
end
