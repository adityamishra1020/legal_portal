# Service to assign a lawyer to a complaint
#
# Usage:
#   result = Complaints::AssignLawyerService.call(
#     complaint_id: 1,
#     lawyer_id: 5,
#     assigned_by: current_user
#   )
#
#   if result.success?
#     puts "Lawyer assigned successfully"
#   else
#     puts result.errors
#   end

class Complaints::AssignLawyerService < ApplicationService
  def initialize(complaint_id:, lawyer_id:, assigned_by:)
    @complaint_id = complaint_id
    @lawyer_id = lawyer_id
    @assigned_by = assigned_by
    super()
  end

  def call
    with_transaction do
      complaint = find_complaint
      return failure(['Complaint not found']) unless complaint

      lawyer = find_lawyer
      return failure(['Lawyer not found or unavailable']) unless lawyer&.available?

      # Verify permission
      return failure(['Not authorized to assign lawyer']) unless can_assign?

      # Assign lawyer
      complaint.update!(
        lawyer_id: @lawyer_id,
        status: 'lawyer_assigned',
        assigned_by: @assigned_by.id,
        assigned_at: Time.current
      )

      # Update lawyer status
      lawyer.update!(status: 'busy')

      success(complaint, 'Lawyer assigned successfully')
    end
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages)
  end

  private

  def find_complaint
    Complaint.find_by(id: @complaint_id)
  end

  def find_lawyer
    Lawyer.available.find_by(id: @lawyer_id)
  end

  def can_assign?
    @assigned_by&.admin? || @assigned_by&.staff?
  end
end
