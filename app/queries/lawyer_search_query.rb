# Query object for searching/filtering lawyers
#
# Usage:
#   query = LawyerSearchQuery.new(
#     specialization: 'criminal',
#     min_experience: 5,
#     location: 'Mumbai',
#     max_fee: 5000,
#     language: 'Hindi',
#     sort_by: 'rating'
#   )
#
#   lawyers = query.call
#   lawyers = query.call.page(1).per(10)

class LawyerSearchQuery
  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 12

  attr_reader :params, :relation

  def initialize(params = {})
    @params = params
    @relation = Lawyer.all
    apply_filters
  end

  def call
    apply_sorting
    @relation
  end

  def call_with_pagination(page = DEFAULT_PAGE, per_page = DEFAULT_PER_PAGE)
    call.page(page).per(per_page)
  end

  def count
    @relation.count
  end

  def exists?
    @relation.exists?
  end

  private

  def apply_filters
    filter_by_specialization
    filter_by_experience
    filter_by_location
    filter_by_language
    filter_by_fee
    filter_by_availability
    filter_by_rating
    filter_by_active
  end

  def filter_by_specialization
    return unless @params[:specialization].present?
    @relation = @relation.where(specialization: @params[:specialization])
  end

  def filter_by_experience
    return unless @params[:min_experience].present?
    @relation = @relation.where('experience >= ?', @params[:min_experience])
  end

  def filter_by_location
    return unless @params[:location].present?
    @relation = @relation.where('location ILIKE ?', "%#{@params[:location]}%")
  end

  def filter_by_language
    return unless @params[:language].present?
    @relation = @relation.where('languages ILIKE ?', "%#{@params[:language]}%")
  end

  def filter_by_fee
    return unless @params[:max_fee].present?
    @relation = @relation.where('consultation_fee <= ?', @params[:max_fee])
  end

  def filter_by_availability
    return if @params[:include_unavailable] == 'true'
    @relation = @relation.available
  end

  def filter_by_rating
    return unless @params[:min_rating].present?
    @relation = @relation.where('rating >= ?', @params[:min_rating])
  end

  def filter_by_active
    return if @params[:include_inactive] == 'true'
    @relation = @relation.active_lawyers
  end

  def apply_sorting
    case @params[:sort_by]
    when 'rating'
      @relation = @relation.order_by_rating
    when 'experience'
      @relation = @relation.order_by_experience
    when 'fee_low'
      @relation = @relation.order(consultation_fee: :asc)
    when 'fee_high'
      @relation = @relation.order(consultation_fee: :desc)
    when 'newest'
      @relation = @relation.order(created_at: :desc)
    when 'oldest'
      @relation = @relation.order(created_at: :asc)
    else
      @relation = @relation.order_by_rating
    end
  end
end
