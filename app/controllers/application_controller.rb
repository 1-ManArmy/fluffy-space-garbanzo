class ApplicationController < ActionController::Base
  # Add CSRF protection and other security measures
  protect_from_forgery with: :exception

  # Handle MongoDB connection issues gracefully
  rescue_from Mongo::Error::NoServerAvailable do |exception|
    Rails.logger.error "MongoDB connection failed: #{exception.message}"
    flash.now[:alert] = 'Our database is temporarily unavailable. Some features may be limited.'
    render 'shared/database_unavailable', status: :service_unavailable and return
  end

  rescue_from Mongo::Error::SocketTimeoutError do |exception|
    Rails.logger.error "MongoDB socket timeout: #{exception.message}"
    flash.now[:alert] = 'Database connection timeout. Please try again in a moment.'
    render 'shared/database_unavailable', status: :service_unavailable and return
  end

  protected

  # Helper method to check MongoDB availability
  def mongodb_available?
    Mongoid.default_client.command(ping: 1)
    true
  rescue Mongo::Error::NoServerAvailable, Mongo::Error::SocketTimeoutError
    false
  end

  # Create fallback data when MongoDB is unavailable
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
