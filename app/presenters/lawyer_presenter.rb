# Presenter for Lawyer model
# Handles view-specific formatting and logic
#
# Usage:
#   presenter = LawyerPresenter.new(lawyer)
#   presenter.display_name  # "Adv. John Doe"
#   presenter.experience_badge  # HTML badge with years
#   presenter.specialization_label  # "Criminal Law"

class LawyerPresenter
  attr_reader :lawyer, :view_context

  def initialize(lawyer, view_context = nil)
    @lawyer = lawyer
    @view_context = view_context
  end

  # Display name with title
  def display_name
    "Adv. #{@lawyer.name}"
  end

  # Short name for cards
  def short_name
    @lawyer.name.split.first
  end

  # Experience formatted
  def experience
    return 'N/A' unless @lawyer.experience
    "#{@lawyer.experience} #{'year'.pluralize(@lawyer.experience)} experience"
  end

  # Experience badge HTML
  def experience_badge
    content_tag(:span, experience, class: 'badge badge-info')
  end

  # Specialization label
  def specialization_label
    @lawyer.specialization&.titleize || 'General'
  end

  # Specialization badge
  def specialization_badge
    content_tag(:span, specialization_label, class: 'badge badge-primary')
  end

  # Rating display
  def rating
    @lawyer.rating ? "#{@lawyer.rating.round(1)}/5" : 'New'
  end

  # Rating stars HTML
  def rating_stars
    return content_tag(:span, 'New Lawyer', class: 'text-muted') unless @lawyer.rating

    full_stars = @lawyer.rating.floor
    half_star = @lawyer.rating % 1 >= 0.5
    empty_stars = 5 - full_stars - (half_star ? 1 : 0)

    stars_html = ''
    stars_html += content_tag(:i, '', class: 'fas fa-star text-warning') * full_stars
    stars_html += content_tag(:i, '', class: 'fas fa-star-half-alt text-warning') if half_star
    stars_html += content_tag(:i, '', class: 'far fa-star text-muted') * empty_stars

    content_tag(:div, stars_html.html_safe, class: 'rating-stars')
  end

  # Consultation fee
  def fee
    return 'Free Consultation' unless @lawyer.consultation_fee
    "₹#{@lawyer.consultation_fee}"
  end

  # Fee badge
  def fee_badge
    fee_text = @lawyer.consultation_fee ? "₹#{@lawyer.consultation_fee}" : 'Free'
    content_tag(:span, fee_text, class: 'badge badge-success')
  end

  # Availability status
  def availability
    case @lawyer.status
    when 'available'
      content_tag(:span, 'Available', class: 'status-available')
    when 'busy'
      content_tag(:span, 'Busy', class: 'status-busy')
    when 'on_leave'
      content_tag(:span, 'On Leave', class: 'status-leave')
    else
      content_tag(:span, 'Inactive', class: 'status-inactive')
    end
  end

  # Location
  def location
    @lawyer.location || 'Location not specified'
  end

  # Languages
  def languages
    return ['English'] unless @lawyer.languages
    @lawyer.languages.split(',').map(&:strip)
  end

  # Languages list HTML
  def languages_list
    languages.map { |lang| content_tag(:span, lang, class: 'language-tag') }.join(' ').html_safe
  end

  # Bio/truncated bio
  def bio
    @lawyer.bio || 'No bio available'
  end

  def truncated_bio(length = 150)
    truncate(bio, length: length, omission: '...')
  end

  # Profile completeness
  def profile_completeness
    return 100 if @lawyer.profile_complete?
    @lawyer.completion_percentage
  end

  # Profile progress bar
  def profile_progress
    content_tag(:div, class: 'progress') do
      content_tag(:div, "#{profile_completeness}%", 
                  class: 'progress-bar', 
                  style: "width: #{profile_completeness}%")
    end
  end

  # Profile URL
  def profile_url
    return '#' unless @view_context
    @view_context.lawyer_path(@lawyer)
  end

  # Profile link HTML
  def profile_link
    return display_name unless @view_context
    @view_context.link_to(display_name, @view_context.lawyer_path(@lawyer))
  end

  # Contact button
  def contact_button
    return content_tag(:span, 'Not Available', class: 'btn btn-secondary disabled') unless @lawyer.available?
    return content_tag(:span, 'Contact Lawyer', class: 'btn btn-primary')
  end

  # Avatar/image
  def avatar(size = 150)
    if @lawyer.profile_image
      image_tag(@lawyer.profile_image, size: size, class: 'lawyer-avatar')
    else
      image_tag(avatar_url(size), size: size, class: 'lawyer-avatar')
    end
  end

  # Avatar URL
  def avatar_url(size = 150)
    "https://ui-avatars.com/api/?name=#{@lawyer.name}&size=#{size}&background=random&color=fff"
  end

  # Bar Council Number
  def bar_council_no
    @lawyer.bar_council_no || 'N/A'
  end

  # Full profile data for JSON
  def to_json
    {
      id: @lawyer.id,
      name: display_name,
      specialization: specialization_label,
      experience: @lawyer.experience,
      rating: @lawyer.rating,
      fee: fee,
      location: location,
      languages: languages,
      available: @lawyer.available?,
      profile_url: profile_url
    }
  end

  private

  def content_tag(tag, content, class_name = nil)
    return content unless @view_context

    options = {}
    options[:class] = class_name if class_name.present?
    @view_context.content_tag(tag, content, options)
  end

  def truncate(text, length:, omission:)
    return text unless text && text.length > length
    text[0...length] + omission
  end
end
