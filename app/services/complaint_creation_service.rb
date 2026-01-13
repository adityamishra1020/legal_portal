# Service object for creating complaints
# Follows Rails 7 best practices with service objects pattern

class ComplaintCreationService
  # Supported complaint types
  TYPES = %w[
    employment
    student_coaching
    student_college
    consumer
    property
    financial
    matrimonial
    rental
  ].freeze

  # Initialize with parameters
  # @param complaint_params [Hash] Common complaint parameters
  # @param specific_params [Hash] Type-specific parameters
  # @param complaint_type [String] Type of complaint
  def initialize(complaint_params:, specific_params:, complaint_type:)
    @complaint_params = complaint_params
    @specific_params = specific_params
    @complaint_type = complaint_type

    validate_complaint_type!
  end

  # Execute the service - create complaint and type-specific record
  # @return [Array<Complaint, Object>] Returns [complaint, type_specific_instance]
  # @raise [StandardError] If validation fails or creation fails
  def execute
    ActiveRecord::Base.transaction do
      # Create base complaint
      complaint = Complaint.create!(base_complaint_attrs)

      # Create type-specific complaint
      specific = create_specific_complaint!(complaint.id)

      [complaint, specific]
    end
  end

  # Class method shortcut for creating complaints
  # @param complaint_params [Hash]
  # @param specific_params [Hash]
  # @param complaint_type [String]
  # @return [Array<Complaint, Object>]
  def self.create!(complaint_params:, specific_params:, complaint_type:)
    new(
      complaint_params: complaint_params,
      specific_params: specific_params,
      complaint_type: complaint_type
    ).execute
  end

  private

  # Validate complaint type is supported
  def validate_complaint_type!
    return if TYPES.include?(@complaint_type)

    raise ArgumentError, "Invalid complaint type: #{@complaint_type}. Supported types: #{TYPES.join(', ')}"
  end

  # Build attributes for base complaint
  def base_complaint_attrs
    @complaint_params.merge(complaint_type: @complaint_type)
  end

  # Create type-specific complaint based on type
  def create_specific_complaint!(complaint_id)
    specific_class = specific_class_for_type

    attrs = @specific_params.merge(complaint_id: complaint_id)
    specific_class.create!(attrs)
  end

  # Get the specific class for complaint type
  def specific_class_for_type
    "#{@complaint_type}_complaint".classify.constantize
  end
end
