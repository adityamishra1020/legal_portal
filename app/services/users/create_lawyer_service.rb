# Service to create a new lawyer account
#
# Usage:
#   result = Users::CreateLawyerService.call(
#     email: 'lawyer@example.com',
#     name: 'Adv. John Doe',
#     password: 'secure123',
#     specialization: 'criminal',
#     experience: 10,
#     bar_council_no: 'ABC123'
#   )
#
#   if result.success?
#     lawyer = result.data
#   end

class Users::CreateLawyerService < ApplicationService
  def initialize(params:)
    @params = params
    super()
  end

  def call
    with_transaction do
      # Validate required fields
      return failure(['Email is required']) unless @params[:email].present?
      return failure(['Name is required']) unless @params[:name].present?
      return failure(['Password is required']) unless @params[:password].present?
      return failure(['Specialization is required']) unless @params[:specialization].present?
      return failure(['Bar Council No. is required']) unless @params[:bar_council_no].present?

      # Check if email exists
      return failure(['Email already exists']) if User.exists?(email: @params[:email])

      # Check if bar council number exists
      return failure(['Bar Council No. already registered']) if Lawyer.exists?(bar_council_no: @params[:bar_council_no])

      # Create lawyer
      lawyer = Lawyer.new(
        email: @params[:email],
        name: @params[:name],
        password: @params[:password],
        role: 'lawyer',
        type: 'Lawyer',
        specialization: @params[:specialization],
        experience: @params[:experience] || 0,
        bar_council_no: @params[:bar_council_no],
        bio: @params[:bio],
        education: @params[:education],
        languages: @params[:languages],
        consultation_fee: @params[:consultation_fee],
        location: @params[:location],
        phone: @params[:phone],
        address: @params[:address],
        status: 'available',
        is_active: true
      )

      return failure(lawyer.errors.full_messages) unless lawyer.save

      success(lawyer, 'Lawyer account created successfully')
    end
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages)
  end
end
