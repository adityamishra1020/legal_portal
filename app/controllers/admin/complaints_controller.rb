module Admin
  class ComplaintsController < BaseController
    def index
      @complaints = Complaint.all.order(created_at: :desc)

      # Filters
      @complaints = @complaints.by_status(params[:status]) if params[:status].present?
      @complaints = @complaints.by_type(params[:type]) if params[:type].present?

      # Date filter
      if params[:from_date].present?
        @complaints = @complaints.where("created_at >= ?", params[:from_date])
      end
      if params[:to_date].present?
        @complaints = @complaints.where("created_at <= ?", params[:to_date])
      end

      @complaints = @complaints.limit(100)
    end

    def update_status
      @complaint = Complaint.find(params[:id])
      if @complaint.update(status: params[:status])
        redirect_to admin_complaints_path, notice: "Status updated to #{params[:status]}."
      else
        redirect_to admin_complaints_path, alert: "Failed to update status."
      end
    end
  end
end
