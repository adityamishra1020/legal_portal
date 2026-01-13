# Factory for creating different types of users
#
# Usage:
#   # Create a regular user
#   user = UserFactory.create_user(email: 'john@example.com', name: 'John', password: '123456')
#
#   # Create a lawyer
#   lawyer = UserFactory.create_lawyer(
#     email: 'lawyer@example.com',
#     name: 'Adv. Smith',
#     password: 'secure123',
#     specialization: 'criminal',
#     bar_council_no: 'ABC123'
#   )
#
#   # Create an admin
#   admin = UserFactory.create_admin(
#     email: 'admin@example.com',
#     name: 'Admin User',
#     password: 'admin123',
#     admin_type: 'super_admin'
#   )

class UserFactory
  # Factory methods return unsaved instances
  # Call .save! or .save to persist

  def self.create_user(params)
    User.new(
      email: params[:email],
      name: params[:name],
      password: params[:password],
      role: 'user',
      type: 'User',
      phone: params[:phone],
      address: params[:address],
      is_active: true,
      status: 'active'
    )
  end

  def self.create_lawyer(params)
    Lawyer.new(
      email: params[:email],
      name: params[:name],
      password: params[:password],
      role: 'lawyer',
      type: 'Lawyer',
      phone: params[:phone],
      address: params[:address],
      is_active: params[:is_active] || true,
      status: params[:status] || 'available',
      specialization: params[:specialization],
      experience: params[:experience] || 0,
      bar_council_no: params[:bar_council_no],
      bio: params[:bio],
      education: params[:education],
      languages: params[:languages] || 'English',
      consultation_fee: params[:consultation_fee],
      location: params[:location],
      rating: params[:rating],
      profile_image: params[:profile_image]
    )
  end

  def self.create_admin(params)
    Admin.new(
      email: params[:email],
      name: params[:name],
      password: params[:password],
      role: 'admin',
      type: 'Admin',
      phone: params[:phone],
      address: params[:address],
      is_active: params[:is_active] || true,
      status: params[:status] || 'active',
      admin_type: params[:admin_type] || 'admin'
    )
  end

  def self.create_staff(params)
    Staff.new(
      email: params[:email],
      name: params[:name],
      password: params[:password],
      role: 'staff',
      type: 'Staff',
      phone: params[:phone],
      address: params[:address],
      is_active: params[:is_active] || true,
      status: params[:status] || 'active',
      department: params[:department],
      access_level: params[:access_level] || 'junior'
    )
  end

  # Bulk creation
  def self.create_lawyers_batch(lawyers_data)
    lawyers_data.map { |data| create_lawyer(data) }
  end

  # Build from form data (e.g., registration form)
  def self.build_from_registration(form_data, role = 'user')
    case role
    when 'lawyer'
      create_lawyer(form_data)
    when 'admin'
      create_admin(form_data)
    when 'staff'
      create_staff(form_data)
    else
      create_user(form_data)
    end
  end

  # Clone existing user with changes
  def self.clone_with_changes(user, **changes)
    user.dup.tap do |new_user|
      changes.each { |key, value| new_user[key] = value }
      new_user.email = "#{SecureRandom.uuid}@clone.com" if new_user.email == user.email
    end
  end
end
