Rails.application.configure do
  # Disable Sprockets entirely for this session
  config.assets.enabled = false
  config.serve_static_files = true
  
  # Basic development settings
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.server_timing = true
  
  # Disable caching
  config.action_controller.perform_caching = false
  config.cache_store = :null_store
  
  # Mailer settings
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  
  # Logging
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []
  
  # Hosts configuration
  config.hosts << 'localhost'
  config.hosts << '127.0.0.1'
  config.hosts << 'localhost:3000'
  config.hosts << '127.0.0.1:3000'
end
