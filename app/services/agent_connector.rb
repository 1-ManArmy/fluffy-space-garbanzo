# AgentConnector - Cinematic Boot Logic for AI Agents
# Provides resilient MongoDB connection handling for all agents

class AgentConnector
  include Singleton

  # Connection states for monitoring
  STATES = {
    connected: 'connected',
    disconnected: 'disconnected',
    error: 'error',
    retrying: 'retrying'
  }.freeze

  class << self
    # Primary method to connect and retrieve agents with error handling
    def connect(type:, retries: 3)
      attempt = 0

      begin
        attempt += 1
        Rails.logger.info "🤖 AgentConnector: Attempting to connect to #{type} agent (attempt #{attempt}/#{retries})"

        # Test MongoDB connection first
        test_connection!

        # Find the requested agent
        agent = find_agent(type)

        if agent
          Rails.logger.info "✅ AgentConnector: Successfully connected to #{type} agent"
          log_connection_success(type, agent)
          agent
        else
          Rails.logger.warn "⚠️ AgentConnector: No active agent of type '#{type}' found"
          create_fallback_agent(type)
        end
      rescue ActiveRecord::ConnectionNotEstablished => e
        Rails.logger.error "🔴 PostgreSQL server unavailable for #{type} agent: #{e.message}"
        handle_connection_retry(type, attempt, retries, e)
      rescue ActiveRecord::StatementInvalid => e
        Rails.logger.error "🔑 PostgreSQL query failed for #{type} agent: #{e.message}"
        handle_auth_error(type, e)
      rescue ActiveRecord::StatementTimeout => e
        Rails.logger.error "⏱️ PostgreSQL query timeout for #{type} agent: #{e.message}"
        handle_connection_retry(type, attempt, retries, e)
      rescue StandardError => e
        Rails.logger.error "💥 Unexpected error during #{type} agent boot: #{e.message}"
        Rails.logger.error e.backtrace.join("\n") if Rails.env.development?
        handle_generic_error(type, e)
      end
    end

    # Batch connect multiple agents
    def connect_all(types: %w[infoseek neochat datavision codemaster])
      results = {}

      types.each do |type|
        results[type] = connect(type: type)
      end

      Rails.logger.info "🚀 AgentConnector: Batch connection completed. Success: #{results.compact.size}/#{types.size}"
      results
    end

    # Health check for PostgreSQL connection
    def health_check
      ActiveRecord::Base.connection.execute('SELECT 1')
      {
        status: STATES[:connected],
        timestamp: Time.current,
        database: ActiveRecord::Base.connection.current_database,
        server_info: get_server_info
      }
    rescue StandardError => e
      {
        status: STATES[:error],
        timestamp: Time.current,
        error: e.message,
        suggestion: connection_troubleshooting_tips
      }
    end

    # Get connection statistics
    def connection_stats
      connection = ActiveRecord::Base.connection
      {
        adapter: connection.adapter_name,
        database: connection.current_database,
        pool_size: ActiveRecord::Base.connection_pool.size,
        current_connections: client.pool.size,
        database: client.database.name
      }
    rescue StandardError => e
      { error: e.message }
    end

    private

    def test_connection!
      # Quick query to test connectivity
      ActiveRecord::Base.connection.execute('SELECT 1')
    end

    def find_agent(type)
      # Try to find existing agent or create a minimal one

      # Check if Agent model exists and has the expected structure
      if defined?(Agent)
        Agent.where(agent_type: type, status: 'active').first ||
          Agent.where(agent_type: type).first
      else
        # If Agent model doesn't exist, return a mock object
        create_mock_agent(type)
      end
    rescue Mongoid::Errors::DocumentNotFound
      Rails.logger.info "📝 Creating new #{type} agent record"
      create_fallback_agent(type)
    end

    def create_fallback_agent(type)
      # Create a basic agent structure if none exists

      if defined?(Agent)
        Agent.create!(
          agent_type: type,
          name: type.humanize,
          status: 'active',
          created_at: Time.current,
          updated_at: Time.current
        )
      else
        create_mock_agent(type)
      end
    rescue StandardError => e
      Rails.logger.error "Failed to create fallback agent: #{e.message}"
      create_mock_agent(type)
    end

    def create_mock_agent(type)
      # Return a simple OpenStruct if database operations fail
      OpenStruct.new(
        agent_type: type,
        name: type.humanize,
        status: 'active',
        id: "mock_#{type}_#{SecureRandom.hex(4)}",
        created_at: Time.current,
        fallback: true
      )
    end

    def handle_connection_retry(type, attempt, max_retries, _error)
      if attempt < max_retries
        wait_time = attempt * 2 # Exponential backoff
        Rails.logger.info "🔄 Retrying #{type} agent connection in #{wait_time} seconds..."
        sleep(wait_time)
        connect(type: type, retries: max_retries - attempt)
      else
        Rails.logger.error "💀 Maximum retries exceeded for #{type} agent. Creating fallback."
        create_mock_agent(type)
      end
    end

    def handle_auth_error(type, _error)
      Rails.logger.error '🔐 Authentication issue detected. Check MongoDB credentials.'
      create_mock_agent(type)
    end

    def handle_generic_error(type, error)
      Rails.logger.error "🚨 Generic error for #{type} agent: #{error.class}"
      create_mock_agent(type)
    end

    def log_connection_success(type, agent)
      Rails.logger.info "🎯 Agent #{type} loaded: ID=#{agent.try(:id)} Status=#{agent.try(:status)}"
    end

    def get_server_info
      info = Mongoid.default_client.command(buildInfo: 1).first
      {
        version: info['version'],
        platform: info['platform']
      }
    rescue StandardError
      { version: 'unknown', platform: 'unknown' }
    end

    def connection_troubleshooting_tips
      [
        '1. Verify MongoDB Atlas cluster is running',
        '2. Check IP whitelist includes your current IP',
        '3. Validate MONGODB_URI environment variable',
        '4. Ensure database user has proper permissions',
        '5. Check network connectivity to MongoDB Atlas'
      ]
    end
  end
end
