class RenameAdminTypeToAdministrator < ActiveRecord::Migration[7.0]
  def change
    # Update existing admin users from 'Admin' to 'Administrator'
    User.where(type: 'Admin').update_all(type: 'Administrator')
  end
end
