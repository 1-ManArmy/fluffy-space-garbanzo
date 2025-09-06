require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"  # Enabled for PostgreSQL
require "active_storage/engine"  # Enabled for PostgreSQL
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"  # Enabled for PostgreSQL
require "action_text/engine"     # Enabled for PostgreSQL
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OneLastAI
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    
    # Configure for onelastai.com domain
    config.application_name = "OneLastAI"
    
    # Allow ngrok and development hosts
    config.hosts << "humbly-tidy-coral.ngrok-free.app" if defined?(config.hosts)
    
    # Allow Railway domains  
    config.hosts << /.*\.railway\.app$/ if defined?(config.hosts)
    config.hosts << /.*\.up\.railway\.app$/ if defined?(config.hosts)
    
    # Load application configuration
    require_relative 'application_config'
    
    # Configure session store
    config.session_store :cookie_store, 
      key: '_onelastai_session',
      domain: Rails.env.production? ? '.onelastai.com' : nil,
      secure: Rails.env.production?,
      httponly: true,
      same_site: :lax
      
    # Configure CORS for API endpoints
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'onelastai.com', 'www.onelastai.com', '*.onelastai.com', 
                'humbly-tidy-coral.ngrok-free.app', 
                /.*\.railway\.app$/, /.*\.up\.railway\.app$/
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head],
          credentials: true
      end
    end
  end
end
