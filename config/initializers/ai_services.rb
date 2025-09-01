# AI Services Configuration
# This initializer sets up all AI service providers with their API keys

Rails.application.configure do
  # OpenAI Configuration
  config.openai = {
    api_key: ENV['OPENAI_API_KEY'],
    organization_id: ENV['OPENAI_ORGANIZATION_ID'],
    default_model: ENV['OPENAI_DEFAULT_MODEL'] || 'gpt-4',
    max_tokens: ENV['OPENAI_MAX_TOKENS']&.to_i || 4096,
    temperature: ENV['OPENAI_TEMPERATURE']&.to_f || 0.7
  }

  # Google AI / agent Configuration
  config.google_ai = {
    api_key: ENV['GOOGLE_AI_API_KEY'],
    project_id: ENV['GOOGLE_AI_PROJECT_ID'],
    location: ENV['GOOGLE_AI_LOCATION'] || 'us-central1',
    default_model: ENV['GOOGLE_AI_DEFAULT_MODEL'] || 'agent-1.5-flash'
  }

  # RunwayML Configuration
  config.runwayml = {
    api_key: ENV['RUNWAYML_API_KEY'],
    api_url: ENV['RUNWAYML_API_URL'] || 'https://api.runwayml.com/v1',
    default_model: ENV['RUNWAYML_DEFAULT_MODEL'] || 'gen-3-alpha-turbo',
    webhook_secret: ENV['RUNWAYML_WEBHOOK_SECRET']
  }

  # Feature Flags for AI Services
  config.ai_features = {
    openai_enabled: ENV['OPENAI_API_KEY'].present?,
    google_ai_enabled: false, # Disabled for deployment - ENV['GOOGLE_AI_API_KEY'].present?,
    runwayml_enabled: ENV['RUNWAYML_API_KEY'].present?,
    enable_ai_services: ENV['ENABLE_AI_SERVICES'] == 'true'
  }

  # Global AI Service Settings
  config.ai_settings = {
    default_provider: :openai,
    fallback_provider: :google_ai,
    max_retries: 3,
    timeout: 30.seconds,
    rate_limit_per_minute: ENV['RATE_LIMIT_REQUESTS_PER_MINUTE']&.to_i || 60
  }
end

# Validation - Ensure required keys are present
required_keys = {
  'OPENAI_API_KEY' => ENV['OPENAI_API_KEY']
  # 'GOOGLE_AI_API_KEY' => ENV['GOOGLE_AI_API_KEY'], # Disabled for deployment
  # 'RUNWAYML_API_KEY' => ENV['RUNWAYML_API_KEY'] # Disabled for deployment
}

missing_keys = required_keys.select { |_key, value| value.blank? }

if missing_keys.any? && Rails.env.production?
  Rails.logger.warn "Missing AI API keys: #{missing_keys.keys.join(', ')}"
  puts '⚠️  WARNING: Missing AI API keys in production environment'
  puts "Missing keys: #{missing_keys.keys.join(', ')}"
else
  puts '✅ AI Services Configuration Loaded Successfully'
  puts "🌌 OpenAI: #{ENV['OPENAI_API_KEY'].present? ? 'Configured' : 'Missing'}"
  # puts "🌌 Google AI: #{ENV['GOOGLE_AI_API_KEY'].present? ? 'Configured' : 'Missing'}" # Disabled for deployment
  puts "🎬 RunwayML: #{ENV['RUNWAYML_API_KEY'].present? ? 'Configured' : 'Missing'}"
end
