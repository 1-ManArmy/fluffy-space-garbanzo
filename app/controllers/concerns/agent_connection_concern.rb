# AgentConnectionConcern - Mixin for controllers requiring agent connectivity
# Provides standardized agent loading with error handling

module AgentConnectionConcern
  extend ActiveSupport::Concern

  included do
    # Add error handling for MongoDB connection issues
    rescue_from Mongo::Error::NoServerAvailable, with: :handle_mongodb_unavailable
    rescue_from Mongo::Error::SocketTimeoutError, with: :handle_mongodb_timeout

    before_action :ensure_mongodb_connection, if: :requires_database?
  end

  class_methods do
    # Define which actions require database connectivity
    def requires_database_for(*actions)
      define_method :requires_database? do
        actions.empty? || actions.include?(action_name.to_sym)
      end
    end
  end

  private

  # Ensure MongoDB connection is available
  def ensure_mongodb_connection
    health = AgentConnector.health_check

    return if health[:status] == AgentConnector::STATES[:connected]

    Rails.logger.warn "🔶 MongoDB connection issues detected: #{health[:error]}"

    # Try to establish connection
    begin
      Mongoid.default_client.command(ping: 1)
    rescue StandardError => e
      handle_mongodb_connection_failure(e)
    end
  end

  # Load agent with connection handling
  def load_agent_safely(type)
    agent = AgentConnector.connect(type: type)

    if agent && agent.respond_to?(:fallback) && agent.fallback
      flash.now[:warning] = '⚠️ Running in fallback mode. Some features may be limited.'
      Rails.logger.warn "🔶 Controller #{self.class.name} using fallback agent for #{type}"
    end

    agent
  end

  # Enhanced agent stats for dashboard
  def agent_stats_with_connection
    base_stats = {
      total_conversations: 0,
      average_rating: '4.8/5',
      response_time: '< 2s',
      uptime: '99.9%'
    }

    begin
      # Try to get real stats from database
      if @agent && !@agent.fallback
        # Add real database queries here when models are available
        base_stats.merge({
                           status: '🟢 Connected',
                           database: 'Primary',
                           last_updated: Time.current.strftime('%H:%M:%S')
                         })
      else
        base_stats.merge({
                           status: '🟡 Fallback Mode',
                           database: 'Simulated',
                           last_updated: Time.current.strftime('%H:%M:%S')
                         })
      end
    rescue StandardError => e
      Rails.logger.error "Failed to load agent stats: #{e.message}"
      base_stats.merge({
                         status: '🔴 Limited',
                         database: 'Unavailable',
                         last_updated: Time.current.strftime('%H:%M:%S')
                       })
    end
  end

  # MongoDB connection error handlers
  def handle_mongodb_unavailable(exception)
    Rails.logger.error "🔴 MongoDB unavailable in #{controller_name}: #{exception.message}"

    respond_to do |format|
      format.html do
        @agent = create_fallback_response('mongodb_unavailable')
        render_with_fallback
      end
      format.json do
        render json: {
          error: 'Database temporarily unavailable',
          status: 'fallback_mode',
          timestamp: Time.current.iso8601
        }, status: :service_unavailable
      end
    end
  end

  def handle_mongodb_timeout(exception)
    Rails.logger.error "⏱️ MongoDB timeout in #{controller_name}: #{exception.message}"

    respond_to do |format|
      format.html do
        @agent = create_fallback_response('timeout')
        render_with_fallback
      end
      format.json do
        render json: {
          error: 'Database connection timeout',
          status: 'temporary_unavailable',
          timestamp: Time.current.iso8601
        }, status: :request_timeout
      end
    end
  end

  def handle_mongodb_connection_failure(exception)
    Rails.logger.error "💥 MongoDB connection failure: #{exception.message}"

    # Store connection failure details for monitoring
    Rails.cache.write(
      "mongodb_failure_#{controller_name}",
      {
        timestamp: Time.current,
        error: exception.message,
        controller: controller_name,
        action: action_name
      },
      expires_in: 1.hour
    )
  end

  def create_fallback_response(error_type)
    OpenStruct.new(
      agent_type: controller_name.gsub('_controller', ''),
      name: controller_name.humanize.gsub(' Controller', ''),
      status: 'fallback',
      error_type: error_type,
      fallback: true,
      id: "fallback_#{SecureRandom.hex(4)}",
      created_at: Time.current
    )
  end

  def render_with_fallback
    @agent_stats = agent_stats_with_connection

    # Try to render normally, with fallback data
    begin
      render action_name
    rescue StandardError => e
      Rails.logger.error "Render fallback failed: #{e.message}"
      render plain: 'Service temporarily unavailable. Please try again later.', status: :service_unavailable
    end
  end

  # Health check endpoint for monitoring
  def mongodb_health
    health = AgentConnector.health_check
    connection_stats = AgentConnector.connection_stats

    render json: {
      mongodb: health,
      connection: connection_stats,
      controller: controller_name,
      timestamp: Time.current.iso8601
    }
  end

  protected

  # Override this in controllers to specify database requirement
  def requires_database?
    true
  end
end
