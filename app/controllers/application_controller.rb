class ApplicationController < ActionController::Base
  # Add CSRF protection and other security measures
  protect_from_forgery with: :exception

  # Handle PostgreSQL connection issues gracefully
  rescue_from ActiveRecord::ConnectionNotEstablished do |exception|
    Rails.logger.error "PostgreSQL connection failed: #{exception.message}"
    flash.now[:alert] = 'Our database is temporarily unavailable. Some features may be limited.'
    render 'shared/database_unavailable', status: :service_unavailable and return
  end

  rescue_from ActiveRecord::StatementTimeout do |exception|
    Rails.logger.error "PostgreSQL statement timeout: #{exception.message}"
    flash.now[:alert] = 'Database query timeout. Please try again in a moment.'
    render 'shared/database_unavailable', status: :service_unavailable and return
  end

  protected

  # Helper method to check PostgreSQL availability
  # Helper method to check PostgreSQL availability
  def database_available?
    ActiveRecord::Base.connection.execute('SELECT 1')
    true
  rescue ActiveRecord::ConnectionNotEstablished, ActiveRecord::StatementTimeout
    false
  end

  # Create fallback data when database is unavailable
  def create_fallback_agent(agent_type, name, attributes = {})
    OpenStruct.new(
      agent_type: agent_type,
      name: name,
      tagline: attributes[:tagline] || 'AI Agent',
      description: attributes[:description] || 'Advanced AI assistance',
      use_case: attributes[:use_case] || 'General AI assistance',
      created_at: Time.current,
      updated_at: Time.current,
      id: "fallback_#{agent_type}",
      persisted?: false,
      new_record?: true
    )
  end
end
