class Lawyer < User
  # Lawyer specializations
  enum specialization: {
    criminal: 'criminal',
    civil: 'civil',
    corporate: 'corporate',
    family: 'family',
    property: 'property',
    taxation: 'taxation',
    labor: 'labor',
    immigration: 'immigration',
    intellectual_property: 'intellectual_property',
    environmental: 'environmental',
    consumer_protection: 'consumer_protection',
    constitutional: 'constitutional',
    banking: 'banking',
    insurance: 'insurance',
    medical: 'medical',
    education: 'education',
    other: 'other'
  }

  enum status: {
    available: 'available',
    busy: 'busy',
    on_leave: 'on_leave',
    inactive: 'inactive'
  }

  # Scopes
  scope :available, -> { where(status: 'available', is_active: true) }
  scope :by_specialization, ->(spec) { where(specialization: spec) if spec.present? }
  scope :experienced, ->(years) { where("experience >= ?", years) if years.present? }
  scope :highly_rated, ->(rating = 4.0) { where("rating >= ?", rating) if rating.present? }
  scope :by_location, ->(location) { where("location LIKE ?", "%#{location}%") if location.present? }
  scope :by_language, ->(lang) { where("languages LIKE ?", "%#{lang}%") if lang.present? }
  scope :affordable, ->(max_fee) { where("consultation_fee <= ?", max_fee) if max_fee.present? }
  scope :order_by_rating, -> { order(rating: :desc, created_at: :desc) }
  scope :order_by_experience, -> { order(experience: :desc) }
  scope :active_lawyers, -> { where(is_active: true) }

  # Validations
  validates :bar_council_no, presence: true, uniqueness: true
  validates :specialization, presence: true
  validates :experience, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 50 }

  # Lawyer methods
  def lawyer?
    true
  end

  def available?
    status == 'available' && is_active?
  end

  def busy?
    status == 'busy'
  end

  def on_leave?
    status == 'on_leave'
  end

  def formatted_experience
    "#{experience} years"
  end

  def formatted_rating
    rating ? "#{rating.round(1)}/5" : "New"
  end

  def consultation_fee_display
    consultation_fee ? "₹#{consultation_fee}" : "Free Consultation"
  end

  def full_specialization
    specialization.titleize
  end

  def languages_list
    languages.present? ? languages.split(',').map(&:strip) : ['English']
  end

  def accept_complaint?
    available?
  end

  def specializations_list
    specialization.titleize
  end

  def profile_complete?
    bar_council_no.present? && 
    specialization.present? && 
    experience.present? && 
    bio.present?
  end

  def completion_percentage
    fields = %w[profile_image bio education languages consultation_fee location]
    filled = fields.count { |f| send(f).present? }
    (filled.to_f / fields.count * 100).round
  end

  def reviews_count
    0
  end
end
