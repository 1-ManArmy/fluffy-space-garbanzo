class CreateApiKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :api_keys, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :key_hash, null: false, index: { unique: true }
      t.string :name, null: false
      t.json :permissions, default: []
      t.json :rate_limits, default: {}
      t.datetime :last_used_at
      t.datetime :expires_at
      t.boolean :active, default: true, null: false
      t.timestamps

      # Indexes for API key management
      t.index [:user_id, :active], name: 'idx_api_keys_user_active'
      t.index [:active, :expires_at], name: 'idx_api_keys_active_expires'
      t.index :last_used_at
    end

    # Add constraints
    add_check_constraint :api_keys, "expires_at IS NULL OR expires_at > created_at", name: 'api_keys_expires_after_creation'
  end
end
