class LawyersController < ApplicationController
  before_action :set_lawyer, only: [:show]

  def index
    @lawyers = Lawyer.active

    if params[:specialization].present?
      @lawyers = @lawyers.by_specialization(params[:specialization])
    end

    if params[:location].present?
      @lawyers = @lawyers.by_location(params[:location])
    end

    if params[:min_experience].present?
      @lawyers = @lawyers.experienced(params[:min_experience])
    end

    if params[:max_fee].present?
      @lawyers = @lawyers.affordable(params[:max_fee])
    end

    if params[:sort] == 'rating'
      @lawyers = @lawyers.order_by_rating
    elsif params[:sort] == 'experience'
      @lawyers = @lawyers.order_by_experience
    else
      @lawyers = @lawyers.order(created_at: :desc)
    end

    @specializations = Lawyer.specializations.keys
    @locations = Lawyer.where.not(location: nil).distinct.pluck(:location)
  end

  def show
  end

  private

  def set_lawyer
    @lawyer = Lawyer.find(params[:id])
  end
end
