# OneLastAI Application Configuration
# This file manages all environment variables and API configurations

module OneLastAI
  class Configuration
    include ActiveSupport::Configurable

    # =============================================================================
    # CORE APPLICATION SETTINGS
    # =============================================================================

    config_accessor :app_name, default: 'OneLastAI'
    config_accessor :app_version, default: '1.0.0'
    config_accessor :environment, default: Rails.env
    config_accessor :secret_key_base, default: ENV['SECRET_KEY_BASE']

    # =============================================================================
    # AI MODEL API KEYS
    # =============================================================================

    # OpenAI Configuration
    config_accessor :openai_api_key, default: ENV['OPENAI_API_KEY']
    config_accessor :openai_organization_id, default: ENV['OPENAI_ORGANIZATION_ID']
    config_accessor :openai_model, default: 'gpt-4'
    config_accessor :openai_max_tokens, default: 4000
    config_accessor :openai_temperature, default: 0.7

    # Anthropic Claude Configuration
    config_accessor :anthropic_api_key, default: ENV['ANTHROPIC_API_KEY']
    config_accessor :anthropic_model, default: 'claude-3-sonnet-20240229'
    config_accessor :anthropic_max_tokens, default: 4000

    # Google AI / agent Configuration
    config_accessor :google_ai_api_key, default: ENV['GOOGLE_AI_API_KEY']
    config_accessor :google_cloud_project_id, default: ENV['GOOGLE_CLOUD_PROJECT_ID']
    config_accessor :google_ai_model, default: 'agent-pro'

    # Hugging Face Configuration
    config_accessor :huggingface_api_key, default: ENV['HUGGINGFACE_API_KEY']
    config_accessor :huggingface_model, default: 'mistralai/Mixtral-8x7B-Instruct-v0.1'

    # Cohere Configuration
    config_accessor :cohere_api_key, default: ENV['COHERE_API_KEY']
    config_accessor :cohere_model, default: 'command'

    # Replicate Configuration
    config_accessor :replicate_api_token, default: ENV['REPLICATE_API_TOKEN']

    # =============================================================================
    # SPECIALIZED AI SERVICES
    # =============================================================================

    # ElevenLabs (Voice Synthesis)
    config_accessor :elevenlabs_api_key, default: ENV['ELEVENLABS_API_KEY']
    config_accessor :elevenlabs_voice_id, default: 'pNInz6obpgDQGcFmaJgB' # Adam voice

    # AssemblyAI (Speech Recognition)
    config_accessor :assemblyai_api_key, default: ENV['ASSEMBLYAI_API_KEY']

    # Stability AI (Image Generation)
    config_accessor :stability_api_key, default: ENV['STABILITY_API_KEY']
    config_accessor :stability_model, default: 'stable-diffusion-xl-1024-v1-0'

    # Runway ML (Video Generation)
    config_accessor :runwayml_api_key, default: ENV['RUNWAYML_API_KEY']

    # DeepL (Translation)
    config_accessor :deepl_api_key, default: ENV['DEEPL_API_KEY']

    # =============================================================================
    # CLOUD STORAGE & CDN
    # =============================================================================

    # Cloudflare Configuration
    config_accessor :cloudflare_api_token, default: ENV['CLOUDFLARE_API_TOKEN']
    config_accessor :cloudflare_zone_id, default: ENV['CLOUDFLARE_ZONE_ID']

    # =============================================================================
    # DATABASE CONFIGURATION
    # =============================================================================

    config_accessor :database_url, default: ENV['DATABASE_URL']
    config_accessor :redis_url, default: ENV['REDIS_URL'] || 'redis://localhost:6379/0'
    config_accessor :redis_cache_url, default: ENV['REDIS_CACHE_URL'] || 'redis://localhost:6379/1'

    # =============================================================================
    # EMAIL & COMMUNICATION
    # =============================================================================

    # SendGrid Configuration
    config_accessor :sendgrid_api_key, default: ENV['SENDGRID_API_KEY']
    config_accessor :from_email, default: ENV['FROM_EMAIL'] || 'noreply@onelastai.com'

    # Twilio Configuration
    config_accessor :twilio_account_sid, default: ENV['TWILIO_ACCOUNT_SID']
    config_accessor :twilio_auth_token, default: ENV['TWILIO_AUTH_TOKEN']
    config_accessor :twilio_phone_number, default: ENV['TWILIO_PHONE_NUMBER']

    # Slack Configuration
    config_accessor :slack_bot_token, default: ENV['SLACK_BOT_TOKEN']
    config_accessor :slack_webhook_url, default: ENV['SLACK_WEBHOOK_URL']

    # Discord Configuration
    config_accessor :discord_bot_token, default: ENV['DISCORD_BOT_TOKEN']

    # =============================================================================
    # ANALYTICS & MONITORING
    # =============================================================================

    config_accessor :google_analytics_id, default: ENV['GOOGLE_ANALYTICS_ID']
    config_accessor :mixpanel_token, default: ENV['MIXPANEL_TOKEN']
    config_accessor :sentry_dsn, default: ENV['SENTRY_DSN']
    config_accessor :new_relic_license_key, default: ENV['NEW_RELIC_LICENSE_KEY']

    # =============================================================================
    # PAYMENT PROCESSING
    # =============================================================================

    # Stripe Configuration
    config_accessor :stripe_publishable_key, default: ENV['STRIPE_PUBLISHABLE_KEY']
    config_accessor :stripe_secret_key, default: ENV['STRIPE_SECRET_KEY']
    config_accessor :stripe_webhook_secret, default: ENV['STRIPE_WEBHOOK_SECRET']

    # PayPal Configuration
    config_accessor :paypal_client_id, default: ENV['PAYPAL_CLIENT_ID']
    config_accessor :paypal_client_secret, default: ENV['PAYPAL_CLIENT_SECRET']
    config_accessor :paypal_mode, default: ENV['PAYPAL_MODE'] || 'sandbox'

    # =============================================================================
    # SECURITY & AUTHENTICATION
    # =============================================================================

    config_accessor :jwt_secret, default: ENV['JWT_SECRET']
    config_accessor :session_secret, default: ENV['SESSION_SECRET']

    # OAuth Configuration
    config_accessor :github_client_id, default: ENV['GITHUB_CLIENT_ID']
    config_accessor :github_client_secret, default: ENV['GITHUB_CLIENT_SECRET']
    config_accessor :google_oauth_client_id, default: ENV['GOOGLE_OAUTH_CLIENT_ID']
    config_accessor :google_oauth_client_secret, default: ENV['GOOGLE_OAUTH_CLIENT_SECRET']

    # =============================================================================
    # RATE LIMITING & SECURITY
    # =============================================================================

    config_accessor :rate_limit_max_requests, default: ENV['RATE_LIMIT_MAX_REQUESTS']&.to_i || 1000
    config_accessor :rate_limit_window_ms, default: ENV['RATE_LIMIT_WINDOW_MS']&.to_i || 900_000
    config_accessor :cors_origin, default: ENV['CORS_ORIGIN']&.split(',') || ['*']

    # =============================================================================
    # FEATURE FLAGS
    # =============================================================================

    config_accessor :enable_premium_features, default: ENV['ENABLE_PREMIUM_FEATURES'] == 'true'
    config_accessor :enable_beta_agents, default: ENV['ENABLE_BETA_AGENTS'] == 'true'
    config_accessor :enable_api_v2, default: ENV['ENABLE_API_V2'] == 'true'
    config_accessor :maintenance_mode, default: ENV['MAINTENANCE_MODE'] == 'true'

    # =============================================================================
    # NETWORKING & INFRASTRUCTURE
    # =============================================================================

    config_accessor :production_host, default: ENV['PRODUCTION_HOST'] || 'onelastai.com'
    config_accessor :api_base_url, default: ENV['API_BASE_URL'] || 'https://api.onelastai.com'
    config_accessor :cdn_url, default: ENV['CDN_URL'] || 'https://cdn.onelastai.com'

    # =============================================================================
    # AI AGENT SPECIFIC CONFIGURATIONS
    # =============================================================================

    # Agent rate limits (requests per minute)
    config_accessor :agent_rate_limit_free, default: 10
    config_accessor :agent_rate_limit_pro, default: 100
    config_accessor :agent_rate_limit_enterprise, default: 1000

    # Agent timeout settings (seconds)
    config_accessor :agent_timeout_default, default: 30
    config_accessor :agent_timeout_long, default: 120
    config_accessor :agent_timeout_image, default: 60
    config_accessor :agent_timeout_video, default: 300

    # Agent model preferences
    config_accessor :agent_models, default: {
      'neochat' => 'gpt-4',
      'emotisense' => 'claude-3-sonnet-20240229',
      'cinegen' => 'stable-diffusion-xl-1024-v1-0',
      'contentcrafter' => 'gpt-4',
      'memora' => 'claude-3-sonnet-20240229'
    }

    # =============================================================================
    # CACHING CONFIGURATION
    # =============================================================================

    config_accessor :cache_ttl_short, default: 5.minutes
    config_accessor :cache_ttl_medium, default: 1.hour
    config_accessor :cache_ttl_long, default: 24.hours
    config_accessor :cache_ttl_user_session, default: 7.days

    # =============================================================================
    # VALIDATION METHODS
    # =============================================================================

    def self.validate!
      validate_required_keys!
      validate_ai_apis!
      validate_infrastructure!
    end

    def self.validate_required_keys!
      required_keys = %w[
        SECRET_KEY_BASE
        OPENAI_API_KEY
      ]

      missing_keys = required_keys.select { |key| ENV[key].blank? }

      return unless missing_keys.any?

      raise "Missing required environment variables: #{missing_keys.join(', ')}"
    end

    def self.validate_ai_apis!
      # Check if at least one AI API is configured
      ai_apis = [
        ENV['OPENAI_API_KEY'],
        ENV['ANTHROPIC_API_KEY'],
        # ENV['GOOGLE_AI_API_KEY'], # Disabled for deployment
        ENV['HUGGINGFACE_API_KEY'],
        ENV['COHERE_API_KEY']
      ]

      return unless ai_apis.all?(&:blank?)

      Rails.logger.warn 'No AI API keys configured. Some features may not work.'
    end

    def self.validate_infrastructure!
      # Validate URLs
      if config.api_base_url.present? && !valid_url?(config.api_base_url)
        raise "Invalid API_BASE_URL: #{config.api_base_url}"
      end

      return unless config.cdn_url.present? && !valid_url?(config.cdn_url)

      raise "Invalid CDN_URL: #{config.cdn_url}"
    end

    def self.valid_url?(url)
      uri = URI.parse(url)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end

    # =============================================================================
    # CONFIGURATION HELPERS
    # =============================================================================

    def self.development?
      Rails.env.development?
    end

    def self.production?
      Rails.env.production?
    end

    def self.test?
      Rails.env.test?
    end

    def self.ai_api_configured?(service)
      case service.to_sym
      when :openai
        config.openai_api_key.present?
      when :anthropic
        config.anthropic_api_key.present?
      when :google
        config.google_ai_api_key.present?
      when :huggingface
        config.huggingface_api_key.present?
      when :cohere
        config.cohere_api_key.present?
      else
        false
      end
    end

    def self.agent_model_for(agent_name)
      config.agent_models[agent_name.to_s] || config.openai_model
    end

    def self.rate_limit_for_tier(tier)
      case tier.to_sym
      when :free
        config.agent_rate_limit_free
      when :pro
        config.agent_rate_limit_pro
      when :enterprise
        config.agent_rate_limit_enterprise
      else
        config.agent_rate_limit_free
      end
    end
  end

  # Add configure class method
  def self.configure
    yield(self) if block_given?
  end
end

# Initialize configuration
OneLastAI.configure do |config|
  # Any custom configuration can be set here
end
