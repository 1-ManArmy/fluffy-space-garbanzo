# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_09_01_201303) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "agent_interactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "agent_id", null: false
    t.uuid "conversation_id"
    t.string "interaction_type", null: false
    t.json "input_data", default: {}
    t.json "output_data", default: {}
    t.float "response_time"
    t.boolean "success", default: true, null: false
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id", "interaction_type", "created_at"], name: "idx_interactions_agent_type_created"
    t.index ["agent_id"], name: "index_agent_interactions_on_agent_id"
    t.index ["conversation_id"], name: "index_agent_interactions_on_conversation_id"
    t.index ["interaction_type"], name: "index_agent_interactions_on_interaction_type"
    t.index ["success", "created_at"], name: "idx_interactions_success_created"
    t.index ["user_id", "agent_id", "created_at"], name: "idx_interactions_user_agent_created"
    t.index ["user_id"], name: "index_agent_interactions_on_user_id"
    t.check_constraint "interaction_type::text = ANY (ARRAY['chat'::character varying, 'function_call'::character varying, 'error'::character varying, 'system'::character varying, 'conversation_start'::character varying, 'conversation_end'::character varying]::text[])", name: "interactions_type_check"
    t.check_constraint "response_time >= 0::double precision", name: "interactions_response_time_positive"
  end

  create_table "agents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "agent_type", null: false
    t.text "description"
    t.json "configuration", default: {}
    t.json "personality_traits", default: {}
    t.string "status", default: "active", null: false
    t.string "subdomain"
    t.json "capabilities", default: []
    t.json "model_preferences", default: {}
    t.string "ai_model_endpoint"
    t.string "fallback_model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_type"], name: "index_agents_on_agent_type"
    t.index ["name"], name: "index_agents_on_name", unique: true
    t.index ["status", "agent_type"], name: "index_agents_on_status_and_agent_type"
    t.index ["status"], name: "index_agents_on_status"
    t.index ["subdomain"], name: "index_agents_on_subdomain", unique: true
    t.check_constraint "agent_type::text = ANY (ARRAY['chatbot'::character varying, 'assistant'::character varying, 'specialist'::character varying, 'analyzer'::character varying]::text[])", name: "agents_type_check"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'inactive'::character varying, 'maintenance'::character varying]::text[])", name: "agents_status_check"
  end

  create_table "api_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "key_hash", null: false
    t.string "name", null: false
    t.json "permissions", default: []
    t.json "rate_limits", default: {}
    t.datetime "last_used_at"
    t.datetime "expires_at"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active", "expires_at"], name: "idx_api_keys_active_expires"
    t.index ["key_hash"], name: "index_api_keys_on_key_hash", unique: true
    t.index ["last_used_at"], name: "index_api_keys_on_last_used_at"
    t.index ["user_id", "active"], name: "idx_api_keys_user_active"
    t.index ["user_id"], name: "index_api_keys_on_user_id"
    t.check_constraint "expires_at IS NULL OR expires_at > created_at", name: "api_keys_expires_after_creation"
  end

  create_table "audit_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "action", null: false
    t.string "resource_type"
    t.string "resource_id"
    t.json "changes", default: {}
    t.string "ip_address"
    t.string "user_agent"
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action", "created_at"], name: "idx_audit_logs_action_created"
    t.index ["created_at"], name: "index_audit_logs_on_created_at"
    t.index ["resource_type", "resource_id"], name: "idx_audit_logs_resource"
    t.index ["user_id", "created_at"], name: "idx_audit_logs_user_created"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "conversations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "agent_id", null: false
    t.string "session_id"
    t.string "title"
    t.json "context", default: {}
    t.json "metadata", default: {}
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id", "created_at"], name: "idx_conversations_agent_created"
    t.index ["agent_id"], name: "index_conversations_on_agent_id"
    t.index ["session_id"], name: "index_conversations_on_session_id"
    t.index ["title"], name: "index_conversations_on_title", opclass: :gin_trgm_ops, using: :gin
    t.index ["user_id", "agent_id", "created_at"], name: "idx_conversations_user_agent_created"
    t.index ["user_id", "created_at"], name: "idx_conversations_user_created"
    t.index ["user_id"], name: "index_conversations_on_user_id"
  end

  create_table "messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "conversation_id", null: false
    t.uuid "user_id"
    t.string "role", null: false
    t.text "content", null: false
    t.json "metadata", default: {}
    t.string "model_used"
    t.integer "tokens_used", default: 0
    t.float "processing_time", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content"], name: "index_messages_on_content", opclass: :gin_trgm_ops, using: :gin
    t.index ["conversation_id", "created_at"], name: "idx_messages_conversation_created"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["model_used"], name: "index_messages_on_model_used"
    t.index ["role"], name: "index_messages_on_role"
    t.index ["user_id", "created_at"], name: "idx_messages_user_created"
    t.index ["user_id"], name: "index_messages_on_user_id"
    t.check_constraint "processing_time >= 0::double precision", name: "messages_processing_time_positive"
    t.check_constraint "role::text = ANY (ARRAY['user'::character varying, 'assistant'::character varying, 'system'::character varying]::text[])", name: "messages_role_check"
    t.check_constraint "tokens_used >= 0", name: "messages_tokens_positive"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "stripe_subscription_id"
    t.string "stripe_customer_id"
    t.string "lemon_squeezy_subscription_id"
    t.string "paypal_subscription_id"
    t.string "payment_provider", default: "stripe", null: false
    t.string "plan_name", null: false
    t.string "status", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.string "currency", default: "USD", null: false
    t.datetime "current_period_start"
    t.datetime "current_period_end"
    t.datetime "canceled_at"
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lemon_squeezy_subscription_id"], name: "index_subscriptions_on_lemon_squeezy_subscription_id", unique: true
    t.index ["payment_provider"], name: "index_subscriptions_on_payment_provider"
    t.index ["paypal_subscription_id"], name: "index_subscriptions_on_paypal_subscription_id", unique: true
    t.index ["plan_name"], name: "index_subscriptions_on_plan_name"
    t.index ["status", "current_period_end"], name: "idx_subscriptions_status_period_end"
    t.index ["stripe_subscription_id"], name: "index_subscriptions_on_stripe_subscription_id", unique: true
    t.index ["user_id", "status"], name: "idx_subscriptions_user_status"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
    t.check_constraint "amount >= 0::numeric", name: "subscriptions_amount_positive"
    t.check_constraint "current_period_end > current_period_start", name: "subscriptions_period_valid"
    t.check_constraint "payment_provider::text = ANY (ARRAY['stripe'::character varying, 'lemon_squeezy'::character varying, 'paypal'::character varying]::text[])", name: "subscriptions_provider_check"
    t.check_constraint "status::text = ANY (ARRAY['active'::character varying, 'canceled'::character varying, 'past_due'::character varying, 'incomplete'::character varying, 'trialing'::character varying]::text[])", name: "subscriptions_status_check"
  end

  create_table "usage_metrics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "agent_id"
    t.date "date", null: false
    t.integer "requests_count", default: 0, null: false
    t.integer "tokens_used", default: 0, null: false
    t.float "processing_time_total", default: 0.0, null: false
    t.json "breakdown", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent_id", "date"], name: "idx_usage_metrics_agent_date"
    t.index ["agent_id"], name: "index_usage_metrics_on_agent_id"
    t.index ["date", "requests_count"], name: "idx_usage_metrics_date_requests"
    t.index ["user_id", "date"], name: "idx_usage_metrics_user_date_unique", unique: true
    t.index ["user_id"], name: "index_usage_metrics_on_user_id"
    t.check_constraint "processing_time_total >= 0::double precision", name: "usage_metrics_processing_time_positive"
    t.check_constraint "requests_count >= 0", name: "usage_metrics_requests_positive"
    t.check_constraint "tokens_used >= 0", name: "usage_metrics_tokens_positive"
  end

  create_table "user_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "session_token", null: false
    t.string "keycloak_session_id"
    t.json "session_data", default: {}
    t.datetime "expires_at"
    t.string "ip_address"
    t.string "user_agent"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active", "expires_at"], name: "idx_sessions_active_expires"
    t.index ["expires_at"], name: "index_user_sessions_on_expires_at"
    t.index ["keycloak_session_id"], name: "index_user_sessions_on_keycloak_session_id"
    t.index ["session_token"], name: "index_user_sessions_on_session_token", unique: true
    t.index ["user_id", "active", "expires_at"], name: "idx_sessions_user_active_expires"
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
    t.check_constraint "expires_at > created_at", name: "sessions_expires_after_creation"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "keycloak_id", null: false
    t.string "username", null: false
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.text "avatar_url"
    t.json "preferences", default: {}
    t.json "metadata", default: {}
    t.string "subscription_tier", default: "free", null: false
    t.boolean "email_verified", default: false, null: false
    t.boolean "active", default: true, null: false
    t.datetime "last_login_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active", "subscription_tier"], name: "index_users_on_active_and_subscription_tier"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["keycloak_id"], name: "index_users_on_keycloak_id", unique: true
    t.index ["last_login_at"], name: "index_users_on_last_login_at"
    t.index ["subscription_tier"], name: "index_users_on_subscription_tier"
    t.index ["username"], name: "index_users_on_username", unique: true
    t.check_constraint "subscription_tier::text = ANY (ARRAY['free'::character varying, 'pro'::character varying, 'enterprise'::character varying]::text[])", name: "users_subscription_tier_check"
  end

  add_foreign_key "agent_interactions", "agents"
  add_foreign_key "agent_interactions", "conversations"
  add_foreign_key "agent_interactions", "users"
  add_foreign_key "api_keys", "users"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "conversations", "agents"
  add_foreign_key "conversations", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "usage_metrics", "agents"
  add_foreign_key "usage_metrics", "users"
  add_foreign_key "user_sessions", "users"
end
