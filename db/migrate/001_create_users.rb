class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :keycloak_id, null: false, index: { unique: true }
      t.string :username, null: false, index: { unique: true }
      t.string :email, null: false, index: { unique: true }
      t.string :first_name
      t.string :last_name
      t.text :avatar_url
      t.json :preferences, default: {}
      t.json :metadata, default: {}
      t.string :subscription_tier, default: 'free', null: false
      t.boolean :email_verified, default: false, null: false
      t.boolean :active, default: true, null: false
      t.datetime :last_login_at
      t.timestamps

      # Indexes for performance
      t.index :subscription_tier
      t.index [:active, :subscription_tier]
      t.index :last_login_at
    end

    # Add constraints
    add_check_constraint :users, "subscription_tier IN ('free', 'pro', 'enterprise')", name: 'users_subscription_tier_check'
  end
end
