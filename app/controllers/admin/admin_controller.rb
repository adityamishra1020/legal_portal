module Admin
  class AdminController < BaseController
    def index
      @stats = {
        total_complaints: Complaint.count,
        pending_complaints: Complaint.where(status: [:submitted, :under_review]).count,
        resolved_complaints: Complaint.where(status: [:resolved, :closed]).count,
        total_users: User.count,
        total_lawyers: User.lawyers.count,
        active_users: User.active.count
      }
      @recent_complaints = Complaint.recent.limit(10)
      @complaints_by_type = Complaint.group(:complaint_type).count
      @complaints_by_status = Complaint.group(:status).count
    end

    def analytics
      @start_date = params[:start_date] ? Date.parse(params[:start_date]) : 30.days.ago
      @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.current

      daily_complaints = Complaint.where(created_at: @start_date..@end_date)
                                  .group("date(created_at)")
                                  .count
      @complaints_over_time = daily_complaints.transform_keys { |k| Date.parse(k) }

      @complaints_by_type = Complaint.where(created_at: @start_date..@end_date)
                                      .group(:complaint_type).count

      @complaints_by_status = Complaint.where(created_at: @start_date..@end_date)
                                       .group(:status).count

      @total = Complaint.where(created_at: @start_date..@end_date).count
      @resolved = Complaint.where(created_at: @start_date..@end_date)
                           .where(status: [:resolved, :closed]).count
      @resolution_rate = @total > 0 ? (@resolved.to_f / @total * 100).round(2) : 0
    end
  end
end
