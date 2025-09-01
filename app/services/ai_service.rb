class AiService
  include HTTParty

  class << self
    # OpenAI GPT Integration
    def openai_chat(message, options = {})
      return { error: 'OpenAI API key not configured' } unless Rails.application.config.openai[:api_key].present?

      begin
        response = HTTParty.post(
          'https://api.openai.com/v1/chat/completions',
          headers: {
            'Authorization' => "Bearer #{Rails.application.config.openai[:api_key]}",
            'Content-Type' => 'application/json'
          },
          body: {
            model: options[:model] || Rails.application.config.openai[:default_model],
            messages: [
              {
                role: 'system',
                content: options[:system_prompt] || 'You are a helpful AI assistant.'
              },
              {
                role: 'user',
                content: message
              }
            ],
            max_tokens: options[:max_tokens] || Rails.application.config.openai[:max_tokens],
            temperature: options[:temperature] || Rails.application.config.openai[:temperature]
          }.to_json,
          timeout: 30
        )

        if response.success?
          {
            success: true,
            response: response.dig('choices', 0, 'message', 'content'),
            usage: response['usage'],
            model: response['model']
          }
        else
          {
            success: false,
            error: response.dig('error', 'message') || 'OpenAI API error',
            status: response.code
          }
        end
      rescue StandardError => e
        Rails.logger.error "OpenAI API Error: #{e.message}"
        { success: false, error: 'OpenAI service temporarily unavailable' }
      end
    end

    # Google AI (agent) Integration
    def google_ai_chat(message, options = {})
      return { error: 'Google AI API key not configured' } unless Rails.application.config.google_ai[:api_key].present?

      begin
        response = HTTParty.post(
          "https://generativelanguage.googleapis.com/v1beta/models/#{options[:model] || Rails.application.config.google_ai[:default_model]}:generateContent",
          headers: {
            'Content-Type' => 'application/json'
          },
          query: {
            key: Rails.application.config.google_ai[:api_key]
          },
          body: {
            contents: [{
              parts: [{
                text: message
              }]
            }],
            generationConfig: {
              temperature: options[:temperature] || 0.7,
              maxOutputTokens: options[:max_tokens] || 4096
            }
          }.to_json,
          timeout: 30
        )

        if response.success?
          {
            success: true,
            response: response.dig('candidates', 0, 'content', 'parts', 0, 'text'),
            model: options[:model] || Rails.application.config.google_ai[:default_model]
          }
        else
          {
            success: false,
            error: response.dig('error', 'message') || 'Google AI API error',
            status: response.code
          }
        end
      rescue StandardError => e
        Rails.logger.error "Google AI API Error: #{e.message}"
        { success: false, error: 'Google AI service temporarily unavailable' }
      end
    end

    # RunwayML Integration
    def runwayml_generate(prompt, options = {})
      return { error: 'RunwayML API key not configured' } unless Rails.application.config.runwayml[:api_key].present?

      begin
        response = HTTParty.post(
          "#{Rails.application.config.runwayml[:api_url]}/generate",
          headers: {
            'Authorization' => "Bearer #{Rails.application.config.runwayml[:api_key]}",
            'Content-Type' => 'application/json'
          },
          body: {
            model: options[:model] || Rails.application.config.runwayml[:default_model],
            prompt:,
            options: {
              duration: options[:duration] || 5,
              resolution: options[:resolution] || '1280x720',
              fps: options[:fps] || 24
            }
          }.to_json,
          timeout: 60
        )

        if response.success?
          {
            success: true,
            task_id: response['id'],
            status: response['status'],
            estimated_time: response['estimated_time']
          }
        else
          {
            success: false,
            error: response.dig('error', 'message') || 'RunwayML API error',
            status: response.code
          }
        end
      rescue StandardError => e
        Rails.logger.error "RunwayML API Error: #{e.message}"
        { success: false, error: 'RunwayML service temporarily unavailable' }
      end
    end

    # Smart AI Chat - Automatically selects best provider
    def smart_chat(message, options = {})
      providers = %i[openai google_ai].shuffle

      providers.each do |provider|
        case provider
        when :openai
          if Rails.application.config.openai[:api_key].present?
            result = openai_chat(message, options)
            return result.merge(provider: :openai) if result[:success]
          end
        when :google_ai
          if Rails.application.config.google_ai[:api_key].present?
            result = google_ai_chat(message, options)
            return result.merge(provider: :google_ai) if result[:success]
          end
        end
      end

      { success: false, error: 'No AI providers available' }
    end

    # Health check for all services
    def health_check
      services = {}

      services[:openai] = if Rails.application.config.openai[:api_key].present?
                            test_openai_connection
                          else
                            { status: 'disabled', reason: 'No API key' }
                          end

      services[:google_ai] = if Rails.application.config.google_ai[:api_key].present?
                               test_google_ai_connection
                             else
                               { status: 'disabled', reason: 'No API key' }
                             end

      services[:runwayml] = if Rails.application.config.runwayml[:api_key].present?
                              test_runwayml_connection
                            else
                              { status: 'disabled', reason: 'No API key' }
                            end

      services
    end

    private

    def test_openai_connection
      response = HTTParty.get(
        'https://api.openai.com/v1/models',
        headers: {
          'Authorization' => "Bearer #{Rails.application.config.openai[:api_key]}"
        },
        timeout: 10
      )

      response.success? ? { status: 'healthy' } : { status: 'error', reason: 'API error' }
    rescue StandardError
      { status: 'error', reason: 'Connection failed' }
    end

    def test_google_ai_connection
      response = HTTParty.get(
        'https://generativelanguage.googleapis.com/v1beta/models',
        query: { key: Rails.application.config.google_ai[:api_key] },
        timeout: 10
      )

      response.success? ? { status: 'healthy' } : { status: 'error', reason: 'API error' }
    rescue StandardError
      { status: 'error', reason: 'Connection failed' }
    end

    def test_runwayml_connection
      response = HTTParty.get(
        "#{Rails.application.config.runwayml[:api_url]}/health",
        headers: {
          'Authorization' => "Bearer #{Rails.application.config.runwayml[:api_key]}"
        },
        timeout: 10
      )

      response.success? ? { status: 'healthy' } : { status: 'error', reason: 'API error' }
    rescue StandardError
      { status: 'error', reason: 'Connection failed' }
    end
  end
end
