# OneLastAI Configuration Initializer
# This file loads and validates the application configuration

require_relative '../application_config'

# Validate configuration in production
# OneLastAI::Configuration.validate! if Rails.env.production? # Temporarily disabled for deployment

# Set up Redis configuration
$redis = Redis.new(url: OneLastAI::Configuration.config.redis_url) if OneLastAI::Configuration.config.redis_url.present?

# Configure Sentry for error monitoring
# TODO: Re-enable when Sentry is properly configured
# begin
#   if OneLastAI::Configuration.config.sentry_dsn.present?
#     require 'sentry-ruby'
#     require 'sentry-rails'
#
#     Sentry.configure do |config|
#       config.dsn = OneLastAI::Configuration.config.sentry_dsn
#       config.breadcrumbs_logger = %i[active_support_logger http_logger]
#       config.environment = Rails.env
#       config.release = OneLastAI::Configuration.config.app_version
#     end
#   end
# rescue LoadError
#   # Sentry gems not available, skip configuration
#   Rails.logger.warn "Sentry gems not available, skipping Sentry configuration"
# end

# Log configuration status
Rails.logger.info "OneLastAI Configuration loaded for #{Rails.env} environment"
Rails.logger.info "OpenAI API: #{OneLastAI::Configuration.ai_api_configured?(:openai) ? 'Configured' : 'Not configured'}"
# Rails.logger.info "Anthropic API: #{OneLastAI::Configuration.ai_api_configured?(:anthropic) ? 'Configured' : 'Not configured'}" # Disabled for deployment
# Rails.logger.info "Google AI API: #{OneLastAI::Configuration.ai_api_configured?(:google) ? 'Configured' : 'Not configured'}" # Disabled for deployment
Rails.logger.info "Redis: #{OneLastAI::Configuration.config.redis_url.present? ? 'Configured' : 'Not configured'}"
