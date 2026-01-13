class HomeController < ApplicationController
  def index
    @recent_complaints = Complaint.recent.limit(5)
    @stats = {
      total: Complaint.count,
      pending: Complaint.where(status: [:submitted, :under_review]).count,
      resolved: Complaint.where(status: [:resolved, :closed]).count
    }
  end
end
