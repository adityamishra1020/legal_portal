# Create default admin user
admin = User.find_or_initialize_by(email: 'admin@justicehub.in')
admin.update!(
  name: 'Admin User',
  password: 'admin123',
  role: 'admin',
  type: 'Administrator',
  phone: '+911800000000',
  is_active: true,
  status: 'active'
)
puts "Admin user created: #{admin.email} (password: admin123)"

# Create sample lawyer
lawyer = User.find_or_initialize_by(email: 'lawyer@justicehub.in')
lawyer.update!(
  name: 'Adv. John Smith',
  password: 'lawyer123',
  role: 'lawyer',
  type: 'Lawyer',
  phone: '+919999999999',
  specialization: 'criminal',
  experience: 10,
  bar_council_no: 'BAR123456',
  bio: 'Experienced criminal lawyer with 10+ years of practice in district and high courts.',
  education: 'LLB from Delhi University',
  languages: 'English, Hindi, Punjabi',
  rating: 4.5,
  consultation_fee: 2000,
  location: 'New Delhi',
  is_active: true,
  status: 'available'
)
puts "Lawyer user created: #{lawyer.email} (password: lawyer123)"

# Create sample staff
staff = User.find_or_initialize_by(email: 'staff@justicehub.in')
staff.update!(
  name: 'Staff Member',
  password: 'staff123',
  role: 'staff',
  type: 'Staff',
  phone: '+918888888888',
  department: 'support',
  access_level: 'junior',
  is_active: true,
  status: 'active'
)
puts "Staff user created: #{staff.email} (password: staff123)"

# Create additional sample lawyers
lawyers_data = [
  {
    email: 'lawyer2@justicehub.in',
    name: 'Adv. Sarah Johnson',
    password: 'lawyer123',
    specialization: 'family',
    experience: 8,
    bar_council_no: 'BAR654321',
    bio: 'Specialist in family law, divorce, and child custody cases.',
    education: 'LLM from NALSAR',
    languages: 'English, Hindi, Telugu',
    rating: 4.8,
    consultation_fee: 1500,
    location: 'Mumbai'
  },
  {
    email: 'lawyer3@justicehub.in',
    name: 'Adv. Michael Chen',
    password: 'lawyer123',
    specialization: 'property',
    experience: 15,
    bar_council_no: 'BAR987654',
    bio: 'Senior property lawyer handling real estate disputes and title verification.',
    education: 'LLB from Symbiosis',
    languages: 'English, Hindi, Marathi',
    rating: 4.6,
    consultation_fee: 3000,
    location: 'Pune'
  },
  {
    email: 'lawyer4@justicehub.in',
    name: 'Adv. Priya Sharma',
    password: 'lawyer123',
    specialization: 'corporate',
    experience: 12,
    bar_council_no: 'BAR456789',
    bio: 'Corporate lawyer specializing in mergers, acquisitions, and compliance.',
    education: 'LLB from NLUI',
    languages: 'English, Hindi, Tamil',
    rating: 4.9,
    consultation_fee: 5000,
    location: 'Bangalore'
  },
  {
    email: 'lawyer5@justicehub.in',
    name: 'Adv. Raj Patel',
    password: 'lawyer123',
    specialization: 'labor',
    experience: 20,
    bar_council_no: 'BAR321654',
    bio: 'Labor law expert with two decades of experience in employment disputes.',
    education: 'LLB from DU',
    languages: 'English, Hindi, Gujarati',
    rating: 4.7,
    consultation_fee: 2500,
    location: 'Ahmedabad'
  }
]

lawyers_data.each do |data|
  lawyer = User.find_or_initialize_by(email: data[:email])
  lawyer.update!(data.merge(
    role: 'lawyer',
    type: 'Lawyer',
    is_active: true,
    status: 'available'
  ))
  puts "Lawyer user created: #{lawyer.email} (password: lawyer123)"
end

puts "\nAll seed users created successfully!"
