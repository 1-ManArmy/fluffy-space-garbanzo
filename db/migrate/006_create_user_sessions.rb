class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :session_token, null: false, index: { unique: true }
      t.string :keycloak_session_id
      t.json :session_data, default: {}
      t.datetime :expires_at
      t.string :ip_address
      t.string :user_agent
      t.boolean :active, default: true, null: false
      t.timestamps

      # Indexes for session management
      t.index [:user_id, :active, :expires_at], name: 'idx_sessions_user_active_expires'
      t.index [:active, :expires_at], name: 'idx_sessions_active_expires'
      t.index :keycloak_session_id
      t.index :expires_at
    end

    # Add constraints
    add_check_constraint :user_sessions, "expires_at > created_at", name: 'sessions_expires_after_creation'
  end
end
