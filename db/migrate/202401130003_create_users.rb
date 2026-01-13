class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name, null: false
      t.string :password_digest, null: false
      t.string :role, default: 'user'
      t.string :phone
      t.text :address
      t.boolean :is_active, default: true
      t.string :status, default: 'active'
      t.datetime :last_login_at
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role
    add_index :users, :is_active
  end
end
