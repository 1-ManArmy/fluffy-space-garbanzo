# PostgreSQL Migration Plan for OneLastAI
# Migration from MongoDB to PostgreSQL with data preservation

# =============================================================================
# GEMFILE UPDATES
# =============================================================================

# Remove MongoDB dependencies
# gem 'mongoid', '~> 9.0'

# Add PostgreSQL dependencies
gem 'pg', '~> 1.5'
gem 'activerecord', '~> 7.1.0'
gem 'activerecord-import', '~> 1.5' # For bulk data migration

# Database migration tools
gem 'data_migrate', '~> 9.0' # For data migrations separate from schema
gem 'strong_migrations', '~> 1.6' # For safe migrations

# Performance and indexing
gem 'pg_search', '~> 2.3' # For full-text search
gem 'scenic', '~> 1.7' # For database views

# =============================================================================
# DATABASE CONFIGURATION
# =============================================================================

# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['DATABASE_USERNAME'] || 'onelastai' %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: <%= ENV['DATABASE_HOST'] || 'localhost' %>
  port: <%= ENV['DATABASE_PORT'] || 5432 %>

development:
  <<: *default
  database: onelastai_development

test:
  <<: *default
  database: onelastai_test

production:
  <<: *default
  database: <%= ENV['DATABASE_NAME'] || 'onelastai_production' %>
  url: <%= ENV['DATABASE_URL'] %>

# =============================================================================
# SCHEMA MIGRATION PLAN
# =============================================================================

# 1. Users Table (replacing MongoDB User documents)
create_table :users do |t|
  t.string :keycloak_id, null: false, index: { unique: true }
  t.string :username, null: false, index: { unique: true }
  t.string :email, null: false, index: { unique: true }
  t.string :first_name
  t.string :last_name
  t.text :avatar_url
  t.json :preferences, default: {}
  t.json :metadata, default: {}
  t.string :subscription_tier, default: 'free'
  t.boolean :email_verified, default: false
  t.boolean :active, default: true
  t.datetime :last_login_at
  t.timestamps
end

# 2. Agents Table (AI agent configurations)
create_table :agents do |t|
  t.string :name, null: false, index: { unique: true }
  t.string :agent_type, null: false
  t.text :description
  t.json :configuration, default: {}
  t.json :personality_traits, default: {}
  t.string :status, default: 'active'
  t.string :subdomain, index: { unique: true }
  t.json :capabilities, default: []
  t.json :model_preferences, default: {}
  t.timestamps
end

# 3. Conversations Table (chat conversations)
create_table :conversations do |t|
  t.references :user, null: false, foreign_key: true
  t.references :agent, null: false, foreign_key: true
  t.string :session_id, index: true
  t.string :title
  t.json :context, default: {}
  t.json :metadata, default: {}
  t.datetime :started_at
  t.datetime :ended_at
  t.timestamps
end

# 4. Messages Table (individual chat messages)
create_table :messages do |t|
  t.references :conversation, null: false, foreign_key: true
  t.references :user, null: true, foreign_key: true
  t.string :role, null: false # 'user', 'assistant', 'system'
  t.text :content, null: false
  t.json :metadata, default: {}
  t.string :model_used
  t.integer :tokens_used, default: 0
  t.float :processing_time, default: 0.0
  t.timestamps
end

# 5. Agent Interactions Table (analytics and usage tracking)
create_table :agent_interactions do |t|
  t.references :user, null: false, foreign_key: true
  t.references :agent, null: false, foreign_key: true
  t.references :conversation, null: true, foreign_key: true
  t.string :interaction_type # 'chat', 'function_call', 'error'
  t.json :input_data, default: {}
  t.json :output_data, default: {}
  t.float :response_time
  t.boolean :success, default: true
  t.text :error_message
  t.timestamps
end

# 6. User Sessions Table (authentication sessions)
create_table :user_sessions do |t|
  t.references :user, null: false, foreign_key: true
  t.string :session_token, null: false, index: { unique: true }
  t.string :keycloak_session_id
  t.json :session_data, default: {}
  t.datetime :expires_at
  t.string :ip_address
  t.string :user_agent
  t.boolean :active, default: true
  t.timestamps
end

# 7. Subscriptions Table (payment and subscription management)
create_table :subscriptions do |t|
  t.references :user, null: false, foreign_key: true
  t.string :stripe_subscription_id, index: { unique: true }
  t.string :stripe_customer_id
  t.string :plan_name, null: false
  t.string :status, null: false
  t.decimal :amount, precision: 10, scale: 2
  t.string :currency, default: 'USD'
  t.datetime :current_period_start
  t.datetime :current_period_end
  t.datetime :canceled_at
  t.json :metadata, default: {}
  t.timestamps
end

# 8. Usage Metrics Table (tracking API usage and limits)
create_table :usage_metrics do |t|
  t.references :user, null: false, foreign_key: true
  t.references :agent, null: true, foreign_key: true
  t.date :date, null: false
  t.integer :requests_count, default: 0
  t.integer :tokens_used, default: 0
  t.float :processing_time_total, default: 0.0
  t.json :breakdown, default: {} # Detailed usage breakdown
  t.timestamps
end

# 9. API Keys Table (for API access)
create_table :api_keys do |t|
  t.references :user, null: false, foreign_key: true
  t.string :key_hash, null: false, index: { unique: true }
  t.string :name, null: false
  t.json :permissions, default: []
  t.json :rate_limits, default: {}
  t.datetime :last_used_at
  t.datetime :expires_at
  t.boolean :active, default: true
  t.timestamps
end

# 10. Audit Logs Table (security and compliance)
create_table :audit_logs do |t|
  t.references :user, null: true, foreign_key: true
  t.string :action, null: false
  t.string :resource_type
  t.string :resource_id
  t.json :changes, default: {}
  t.string :ip_address
  t.string :user_agent
  t.json :metadata, default: {}
  t.timestamps
end

# =============================================================================
# INDEXES FOR PERFORMANCE
# =============================================================================

# Composite indexes for common queries
add_index :conversations, [:user_id, :agent_id, :created_at]
add_index :messages, [:conversation_id, :created_at]
add_index :agent_interactions, [:user_id, :agent_id, :created_at]
add_index :usage_metrics, [:user_id, :date], unique: true
add_index :user_sessions, [:user_id, :active, :expires_at]

# Full-text search indexes
add_index :messages, :content, using: :gin
add_index :conversations, :title, using: :gin

# Performance indexes
add_index :users, :subscription_tier
add_index :agents, :status
add_index :subscriptions, :status
add_index :audit_logs, [:created_at, :action]

# =============================================================================
# DATA MIGRATION STRATEGY
# =============================================================================

# Phase 1: Schema Creation
# - Create all PostgreSQL tables
# - Set up indexes and constraints
# - Verify schema integrity

# Phase 2: Data Export from MongoDB
# - Export users collection to JSON
# - Export agent configurations
# - Export conversation histories
# - Export usage analytics

# Phase 3: Data Transformation and Import
# - Transform MongoDB documents to PostgreSQL records
# - Handle JSON field mapping
# - Preserve relationships and references
# - Validate data integrity

# Phase 4: Application Updates
# - Replace Mongoid with ActiveRecord
# - Update model definitions
# - Update controllers and services
# - Update queries and associations

# Phase 5: Testing and Validation
# - Run comprehensive test suite
# - Verify data consistency
# - Performance testing
# - User acceptance testing

# =============================================================================
# ENVIRONMENT VARIABLES FOR POSTGRESQL
# =============================================================================

# Development
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=onelastai
DATABASE_PASSWORD=your_secure_password
DATABASE_NAME=onelastai_development

# Production
DATABASE_URL=postgresql://username:password@host:port/database
DATABASE_POOL_SIZE=25
DATABASE_TIMEOUT=5000

# Connection pooling with PgBouncer (recommended for production)
PGBOUNCER_URL=postgresql://username:password@pgbouncer_host:port/database

# =============================================================================
# BACKUP AND ROLLBACK STRATEGY
# =============================================================================

# Before migration:
# 1. Full MongoDB backup
mongodump --uri="mongodb+srv://..." --out=/backup/mongodb_backup

# 2. PostgreSQL backup (if applicable)
pg_dump onelastai_production > /backup/postgresql_backup.sql

# During migration:
# 1. Dual-write strategy (write to both databases temporarily)
# 2. Data validation and comparison
# 3. Rollback procedures

# After migration:
# 1. MongoDB archival
# 2. PostgreSQL optimization
# 3. Performance monitoring
