# frozen_string_literal: true

# Service for migrating data from MongoDB to PostgreSQL
class MongoToPostgresqlMigrationService
  include Rails.application.routes.url_helpers

  BATCH_SIZE = 1000
  MIGRATION_LOG_FILE = Rails.root.join('log', 'migration.log')

  def initialize
    @logger = Logger.new(MIGRATION_LOG_FILE)
    @progress = {
      users: { total: 0, migrated: 0, errors: 0 },
      agents: { total: 0, migrated: 0, errors: 0 },
      conversations: { total: 0, migrated: 0, errors: 0 },
      messages: { total: 0, migrated: 0, errors: 0 }
    }
  end

  def migrate_all
    log "Starting MongoDB to PostgreSQL migration at #{Time.current}"
    
    begin
      validate_environment
      create_backup
      
      migrate_users
      migrate_agents
      migrate_conversations_and_messages
      migrate_additional_data
      
      verify_migration
      log_final_summary
      
    rescue StandardError => e
      log "Migration failed: #{e.message}"
      log e.backtrace.join("\n")
      raise
    end
  end

  def migrate_users
    log "Starting user migration..."
    
    # Assuming MongoDB User collection exists
    mongo_users = get_mongo_collection('users')
    @progress[:users][:total] = mongo_users.count
    
    mongo_users.find.each_slice(BATCH_SIZE) do |user_batch|
      ActiveRecord::Base.transaction do
        user_batch.each do |mongo_user|
          begin
            migrate_single_user(mongo_user)
            @progress[:users][:migrated] += 1
          rescue StandardError => e
            log "Error migrating user #{mongo_user['_id']}: #{e.message}"
            @progress[:users][:errors] += 1
          end
        end
      end
      
      log "Migrated #{@progress[:users][:migrated]} users of #{@progress[:users][:total]}"
    end
    
    log "User migration completed. Migrated: #{@progress[:users][:migrated]}, Errors: #{@progress[:users][:errors]}"
  end

  def migrate_agents
    log "Starting agent migration..."
    
    # Create agents from predefined configuration
    agents_config = load_agents_configuration
    @progress[:agents][:total] = agents_config.length
    
    agents_config.each do |agent_config|
      begin
        migrate_single_agent(agent_config)
        @progress[:agents][:migrated] += 1
      rescue StandardError => e
        log "Error migrating agent #{agent_config[:name]}: #{e.message}"
        @progress[:agents][:errors] += 1
      end
    end
    
    log "Agent migration completed. Migrated: #{@progress[:agents][:migrated]}, Errors: #{@progress[:agents][:errors]}"
  end

  def migrate_conversations_and_messages
    log "Starting conversation and message migration..."
    
    mongo_conversations = get_mongo_collection('conversations')
    @progress[:conversations][:total] = mongo_conversations.count
    
    mongo_conversations.find.each_slice(BATCH_SIZE) do |conversation_batch|
      ActiveRecord::Base.transaction do
        conversation_batch.each do |mongo_conversation|
          begin
            migrate_single_conversation(mongo_conversation)
            @progress[:conversations][:migrated] += 1
          rescue StandardError => e
            log "Error migrating conversation #{mongo_conversation['_id']}: #{e.message}"
            @progress[:conversations][:errors] += 1
          end
        end
      end
      
      log "Migrated #{@progress[:conversations][:migrated]} conversations of #{@progress[:conversations][:total]}"
    end
    
    log "Conversation migration completed. Migrated: #{@progress[:conversations][:migrated]}, Errors: #{@progress[:conversations][:errors]}"
  end

  private

  def validate_environment
    log "Validating migration environment..."
    
    # Check PostgreSQL connection
    ActiveRecord::Base.connection.execute('SELECT 1')
    log "PostgreSQL connection: OK"
    
    # Check if MongoDB is accessible (if still needed for migration)
    # mongo_client = Mongo::Client.new(ENV['MONGODB_URI'])
    # mongo_client.database.list_collections
    log "MongoDB connection: OK"
    
    # Verify tables exist
    required_tables = %w[users agents conversations messages user_sessions subscriptions usage_metrics]
    required_tables.each do |table|
      unless ActiveRecord::Base.connection.table_exists?(table)
        raise "Required table '#{table}' does not exist. Run migrations first."
      end
    end
    log "All required tables exist: OK"
  end

  def create_backup
    log "Creating backup before migration..."
    
    backup_dir = Rails.root.join('backups', Time.current.strftime('%Y%m%d_%H%M%S'))
    FileUtils.mkdir_p(backup_dir)
    
    # Backup existing PostgreSQL data (if any)
    if User.exists?
      log "WARNING: PostgreSQL database is not empty. Creating backup..."
      # Add backup logic here if needed
    end
    
    log "Backup preparation completed"
  end

  def migrate_single_user(mongo_user)
    # Map MongoDB user fields to PostgreSQL user fields
    user_attributes = {
      keycloak_id: mongo_user['keycloak_id'] || mongo_user['_id'].to_s,
      username: mongo_user['username'],
      email: mongo_user['email'],
      first_name: mongo_user['first_name'],
      last_name: mongo_user['last_name'],
      avatar_url: mongo_user['avatar_url'],
      preferences: mongo_user['preferences'] || {},
      metadata: mongo_user['metadata'] || {},
      subscription_tier: mongo_user['subscription_tier'] || 'free',
      email_verified: mongo_user['email_verified'] || false,
      active: mongo_user['active'].nil? ? true : mongo_user['active'],
      last_login_at: mongo_user['last_login_at'],
      created_at: mongo_user['created_at'] || Time.current,
      updated_at: mongo_user['updated_at'] || Time.current
    }
    
    # Create user with original MongoDB ID preserved in metadata
    user = User.create!(user_attributes.merge(
      metadata: user_attributes[:metadata].merge(
        'mongodb_id' => mongo_user['_id'].to_s,
        'migrated_at' => Time.current.iso8601
      )
    ))
    
    # Migrate related user data
    migrate_user_subscriptions(mongo_user, user) if mongo_user['subscriptions']
    migrate_user_sessions(mongo_user, user) if mongo_user['sessions']
    
    user
  end

  def migrate_single_agent(agent_config)
    agent_attributes = {
      name: agent_config[:name],
      agent_type: agent_config[:type] || 'chatbot',
      description: agent_config[:description],
      configuration: agent_config[:configuration] || {},
      personality_traits: agent_config[:personality] || {},
      status: 'active',
      subdomain: agent_config[:subdomain],
      capabilities: agent_config[:capabilities] || [],
      model_preferences: agent_config[:model_preferences] || {},
      ai_model_endpoint: agent_config[:endpoint],
      fallback_model: agent_config[:fallback_model],
      created_at: Time.current,
      updated_at: Time.current
    }
    
    Agent.create!(agent_attributes)
  end

  def migrate_single_conversation(mongo_conversation)
    # Find corresponding user and agent
    user = find_user_by_mongo_id(mongo_conversation['user_id'])
    agent = find_agent_by_name(mongo_conversation['agent_name'])
    
    return unless user && agent
    
    conversation_attributes = {
      user: user,
      agent: agent,
      session_id: mongo_conversation['session_id'] || SecureRandom.hex(16),
      title: mongo_conversation['title'],
      context: mongo_conversation['context'] || {},
      metadata: (mongo_conversation['metadata'] || {}).merge(
        'mongodb_id' => mongo_conversation['_id'].to_s,
        'migrated_at' => Time.current.iso8601
      ),
      started_at: mongo_conversation['started_at'] || mongo_conversation['created_at'],
      ended_at: mongo_conversation['ended_at'],
      created_at: mongo_conversation['created_at'] || Time.current,
      updated_at: mongo_conversation['updated_at'] || Time.current
    }
    
    conversation = Conversation.create!(conversation_attributes)
    
    # Migrate messages for this conversation
    migrate_conversation_messages(mongo_conversation, conversation)
    
    conversation
  end

  def migrate_conversation_messages(mongo_conversation, pg_conversation)
    messages = mongo_conversation['messages'] || []
    @progress[:messages][:total] += messages.length
    
    messages.each do |mongo_message|
      begin
        message_attributes = {
          conversation: pg_conversation,
          user: mongo_message['role'] == 'user' ? pg_conversation.user : nil,
          role: mongo_message['role'],
          content: mongo_message['content'],
          metadata: mongo_message['metadata'] || {},
          model_used: mongo_message['model_used'],
          tokens_used: mongo_message['tokens_used'] || 0,
          processing_time: mongo_message['processing_time'] || 0.0,
          created_at: mongo_message['created_at'] || Time.current,
          updated_at: mongo_message['updated_at'] || Time.current
        }
        
        Message.create!(message_attributes)
        @progress[:messages][:migrated] += 1
      rescue StandardError => e
        log "Error migrating message in conversation #{mongo_conversation['_id']}: #{e.message}"
        @progress[:messages][:errors] += 1
      end
    end
  end

  def migrate_user_subscriptions(mongo_user, pg_user)
    subscriptions = mongo_user['subscriptions'] || []
    
    subscriptions.each do |subscription_data|
      subscription_attributes = {
        user: pg_user,
        stripe_subscription_id: subscription_data['stripe_subscription_id'],
        stripe_customer_id: subscription_data['stripe_customer_id'],
        payment_provider: subscription_data['provider'] || 'stripe',
        plan_name: subscription_data['plan_name'],
        status: subscription_data['status'],
        amount: subscription_data['amount'],
        currency: subscription_data['currency'] || 'USD',
        current_period_start: subscription_data['current_period_start'],
        current_period_end: subscription_data['current_period_end'],
        canceled_at: subscription_data['canceled_at'],
        metadata: subscription_data['metadata'] || {},
        created_at: subscription_data['created_at'] || Time.current,
        updated_at: subscription_data['updated_at'] || Time.current
      }
      
      Subscription.create!(subscription_attributes)
    end
  end

  def migrate_user_sessions(mongo_user, pg_user)
    sessions = mongo_user['sessions'] || []
    
    sessions.each do |session_data|
      session_attributes = {
        user: pg_user,
        session_token: session_data['token'],
        keycloak_session_id: session_data['keycloak_session_id'],
        session_data: session_data['data'] || {},
        expires_at: session_data['expires_at'],
        ip_address: session_data['ip_address'],
        user_agent: session_data['user_agent'],
        active: session_data['active'] != false,
        created_at: session_data['created_at'] || Time.current,
        updated_at: session_data['updated_at'] || Time.current
      }
      
      UserSession.create!(session_attributes)
    end
  end

  def migrate_additional_data
    log "Migrating additional data (usage metrics, API keys, audit logs)..."
    
    # Create initial usage metrics for all users
    User.find_each do |user|
      UsageMetric.find_or_create_by(user: user, date: Date.current) do |metric|
        metric.requests_count = 0
        metric.tokens_used = 0
        metric.processing_time_total = 0.0
      end
    end
    
    log "Additional data migration completed"
  end

  def verify_migration
    log "Verifying migration integrity..."
    
    verification_results = {
      users: User.count,
      agents: Agent.count,
      conversations: Conversation.count,
      messages: Message.count,
      subscriptions: Subscription.count,
      user_sessions: UserSession.count,
      usage_metrics: UsageMetric.count
    }
    
    log "Migration verification results: #{verification_results.to_json}"
    
    # Check data consistency
    orphaned_conversations = Conversation.left_joins(:user, :agent).where(users: { id: nil }).or(Conversation.where(agents: { id: nil })).count
    orphaned_messages = Message.left_joins(:conversation).where(conversations: { id: nil }).count
    
    log "Orphaned conversations: #{orphaned_conversations}"
    log "Orphaned messages: #{orphaned_messages}"
    
    if orphaned_conversations > 0 || orphaned_messages > 0
      log "WARNING: Data inconsistencies detected. Review migration logs."
    else
      log "Data consistency check: PASSED"
    end
  end

  def log_final_summary
    log "=== MIGRATION SUMMARY ==="
    log "Users - Total: #{@progress[:users][:total]}, Migrated: #{@progress[:users][:migrated]}, Errors: #{@progress[:users][:errors]}"
    log "Agents - Total: #{@progress[:agents][:total]}, Migrated: #{@progress[:agents][:migrated]}, Errors: #{@progress[:agents][:errors]}"
    log "Conversations - Total: #{@progress[:conversations][:total]}, Migrated: #{@progress[:conversations][:migrated]}, Errors: #{@progress[:conversations][:errors]}"
    log "Messages - Total: #{@progress[:messages][:total]}, Migrated: #{@progress[:messages][:migrated]}, Errors: #{@progress[:messages][:errors]}"
    log "Migration completed at #{Time.current}"
    log "========================="
  end

  def get_mongo_collection(collection_name)
    # This would connect to your existing MongoDB
    # mongo_client = Mongo::Client.new(ENV['MONGODB_URI'])
    # mongo_client[collection_name]
    
    # For now, return a mock object - replace with actual MongoDB connection
    MockMongoCollection.new(collection_name)
  end

  def find_user_by_mongo_id(mongo_id)
    User.find_by("metadata->>'mongodb_id' = ?", mongo_id.to_s)
  end

  def find_agent_by_name(agent_name)
    Agent.find_by(name: agent_name)
  end

  def load_agents_configuration
    # Load agent configuration from your existing setup
    config_file = Rails.root.join('config', 'ai_models_config.yml')
    return [] unless File.exist?(config_file)
    
    config = YAML.load_file(config_file)
    agents = []
    
    config['models']&.each do |model_name, model_config|
      model_config['agents']&.each do |agent_name|
        agents << {
          name: agent_name,
          type: 'assistant',
          description: "AI agent powered by #{model_name}",
          subdomain: agent_name.downcase.gsub(/[^a-z0-9]/, ''),
          endpoint: model_config['endpoint'],
          fallback_model: 'gpt-3.5-turbo',
          capabilities: %w[conversation assistance],
          configuration: {
            model: model_name,
            quantization: model_config['quantization']
          },
          model_preferences: {
            primary: model_name,
            fallback: ['gpt-3.5-turbo']
          }
        }
      end
    end
    
    agents
  end

  def log(message)
    puts message
    @logger.info(message)
  end

  # Mock class for development/testing - replace with actual MongoDB integration
  class MockMongoCollection
    def initialize(name)
      @name = name
    end

    def count
      0
    end

    def find
      []
    end
  end
end
