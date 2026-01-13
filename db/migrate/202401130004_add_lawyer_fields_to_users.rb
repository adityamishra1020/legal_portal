class AddLawyerFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    # STI type column (for Single Table Inheritance)
    add_column :users, :type, :string

    # Lawyer specific fields
    add_column :users, :specialization, :string
    add_column :users, :experience, :integer
    add_column :users, :bar_council_no, :string
    add_column :users, :bio, :text
    add_column :users, :education, :string
    add_column :users, :languages, :string
    add_column :users, :rating, :decimal, precision: 3, scale: 2
    add_column :users, :consultation_fee, :decimal, precision: 10, scale: 2
    add_column :users, :location, :string

    # Admin specific fields
    add_column :users, :admin_type, :string

    # Staff specific fields
    add_column :users, :department, :string
    add_column :users, :access_level, :string

    # Add indexes for better query performance
    add_index :users, :type
    add_index :users, :specialization
    add_index :users, :department
    add_index :users, :location
    add_index :users, :bar_council_no, unique: true

    # Update existing users with type column
    User.reset_column_information
    User.update_all(type: 'User')
  end
end
