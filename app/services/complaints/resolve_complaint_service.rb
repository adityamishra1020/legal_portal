# Service to resolve a complaint
#
# Usage:
#   result = Complaints::ResolveComplaintService.call(
#     complaint_id: 1,
#     resolution: 'resolved',
#     notes: 'Case resolved amicably'
#   )
#
#   if result.success?
#     puts "Complaint resolved"
#   end

class Complaints::ResolveComplaintService < ApplicationService
  def initialize(complaint_id:, resolution:, resolved_by:, notes: nil)
    @complaint_id = complaint_id
    @resolution = resolution
    @resolved_by = resolved_by
    @notes = notes
    super()
  end

  def call
    with_transaction do
      complaint = find_complaint
      return failure(['Complaint not found']) unless complaint

      return failure(['Complaint cannot be resolved in current status']) unless can_resolve?

      # Update complaint
      complaint.update!(
        status: @resolution,
        resolved_by: @resolved_by.id,
        resolved_at: Time.current,
        resolution_notes: @notes
      )

      # Free up the lawyer
      if complaint.lawyer
        complaint.lawyer.update!(status: 'available')
      end

      success(complaint, 'Complaint resolved successfully')
    end
  rescue ActiveRecord::RecordInvalid => e
    failure(e.record.errors.full_messages)
  end

  private

  def find_complaint
    Complaint.find_by(id: @complaint_id)
  end

  def can_resolve?
    return true if @resolved_by.admin? || @resolved_by.staff?
    return true if @resolved_by.lawyer? && complaint.lawyer_id == @resolved_by.id
    false
  end
end
