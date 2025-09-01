# Base AI Service with Enterprise Integrations
class BaseAiServiceEnterprise
  include HTTParty

  # Service configuration
  PROVIDERS = {
    openai: {
      base_url: 'https://api.openai.com/v1',
      headers: -> { { 'Authorization' => "Bearer #{ENV['OPENAI_API_KEY']}" } },
      models: %w[gpt-4 gpt-4-turbo gpt-3.5-turbo]
    },
    anthropic: {
      base_url: 'https://api.anthropic.com/v1',
      headers: -> { { 'x-api-key' => ENV['ANTHROPIC_API_KEY'] } },
      models: %w[claude-3-opus claude-3-sonnet claude-3-haiku]
    },
    google: {
      base_url: 'https://generativelanguage.googleapis.com/v1',
      headers: -> { { 'Authorization' => "Bearer #{ENV['GOOGLE_AI_API_KEY']}" } },
      models: %w[agent-pro agent-pro-vision]
    },
    huggingface: {
      base_url: 'https://api-inference.huggingface.co',
      headers: -> { { 'Authorization' => "Bearer #{ENV['HUGGINGFACE_API_KEY']}" } },
      models: %w[microsoft/DialoGPT-large facebook/blenderbot-400M-distill]
    },
    cohere: {
      base_url: 'https://api.cohere.ai/v1',
      headers: -> { { 'Authorization' => "Bearer #{ENV['COHERE_API_KEY']}" } },
      models: %w[command command-light command-nightly]
    },
    # Enterprise AI Services
    runwayml: {
      base_url: 'https://api.runwayml.com/v1',
      headers: lambda {
        {
          'Authorization' => "Bearer #{ENV['RUNWAYML_API_KEY']}",
          'X-Team-ID' => ENV['RUNWAYML_TEAM_ID']
        }
      },
      models: %w[gen3 gen2 stable-diffusion inpainting]
    },
    elevenlabs: {
      base_url: 'https://api.elevenlabs.io/v1',
      headers: -> { { 'xi-api-key' => ENV['ELEVENLABS_API_KEY'] } },
      models: %w[eleven_monolingual_v1 eleven_multilingual_v2]
    },
    assemblyai: {
      base_url: 'https://api.assemblyai.com/v2',
      headers: -> { { 'authorization' => ENV['ASSEMBLYAI_API_KEY'] } },
      models: %w[best nano]
    }
  }.freeze

  def initialize(provider: :openai, model: nil, options: {})
    @provider = provider.to_sym
    @model = model || default_model_for(@provider)
    @options = default_options.merge(options)

    validate_provider!
    validate_api_key!
  end

  # Main completion method
  def complete(prompt, **options)
    merged_options = @options.merge(options)

    case @provider
    when :openai
      openai_complete(prompt, merged_options)
    when :anthropic
      anthropic_complete(prompt, merged_options)
    when :google
      google_complete(prompt, merged_options)
    when :huggingface
      huggingface_complete(prompt, merged_options)
    when :cohere
      cohere_complete(prompt, merged_options)
    when :runwayml
      runwayml_complete(prompt, merged_options)
    when :elevenlabs
      elevenlabs_synthesize(prompt, merged_options)
    when :assemblyai
      assemblyai_transcribe(prompt, merged_options)
    else
      raise UnsupportedProviderError, "Provider #{@provider} is not supported"
    end
  rescue StandardError => e
    handle_error(e)
  end

  # Streaming support for real-time responses
  def stream(prompt, **options, &block)
    merged_options = @options.merge(options).merge(stream: true)

    case @provider
    when :openai
      openai_stream(prompt, merged_options, &block)
    when :anthropic
      anthropic_stream(prompt, merged_options, &block)
    else
      # Fallback to non-streaming for providers that don't support it
      result = complete(prompt, **options)
      yield result if block_given?
      result
    end
  end

  # RunwayML specific methods for video/image generation
  def generate_video(prompt, duration: 10, **options)
    return unless @provider == :runwayml

    payload = {
      model: @model,
      prompt: prompt,
      duration: duration,
      **options
    }

    response = post_request('/generations/videos', payload)
    handle_runwayml_response(response)
  end

  def generate_image(prompt, **options)
    case @provider
    when :runwayml
      runwayml_generate_image(prompt, options)
    when :openai
      openai_generate_image(prompt, options)
    else
      raise UnsupportedOperationError, "Image generation not supported for #{@provider}"
    end
  end

  # Voice synthesis with ElevenLabs
  def synthesize_speech(text, voice_id: nil, **options)
    return unless @provider == :elevenlabs

    voice_id ||= ENV['ELEVENLABS_DEFAULT_VOICE_ID'] || 'pNInz6obpgDQGcFmaJgB'

    payload = {
      text: text,
      model_id: @model,
      voice_settings: {
        stability: options[:stability] || 0.5,
        similarity_boost: options[:similarity_boost] || 0.5
      }
    }

    response = post_request("/text-to-speech/#{voice_id}", payload)
    handle_audio_response(response)
  end

  # Speech recognition with AssemblyAI
  def transcribe_audio(audio_url, **options)
    return unless @provider == :assemblyai

    # First, upload the audio file
    upload_response = post_request('/upload', { audio_url: audio_url })
    upload_url = upload_response['upload_url']

    # Then, create transcription job
    transcription_config = {
      audio_url: upload_url,
      model: @model,
      **options
    }

    response = post_request('/transcript', transcription_config)
    poll_transcription(response['id'])
  end

  private

  def validate_provider!
    return if PROVIDERS.key?(@provider)

    raise InvalidProviderError, "Unknown provider: #{@provider}"
  end

  def validate_api_key!
    config = PROVIDERS[@provider]
    headers = config[:headers].call
    key_header = headers.keys.first

    return unless headers[key_header].blank?

    raise MissingApiKeyError, "API key not found for #{@provider}"
  end

  def default_model_for(provider)
    PROVIDERS[provider][:models].first
  end

  def default_options
    {
      temperature: 0.7,
      max_tokens: 4096,
      top_p: 1.0,
      frequency_penalty: 0.0,
      presence_penalty: 0.0
    }
  end

  def provider_config
    PROVIDERS[@provider]
  end

  def base_url
    provider_config[:base_url]
  end

  def headers
    provider_config[:headers].call.merge({
                                           'Content-Type' => 'application/json',
                                           'User-Agent' => 'OneLastAI/1.0'
                                         })
  end

  # HTTP request helpers
  def post_request(endpoint, payload)
    url = "#{base_url}#{endpoint}"

    response = HTTParty.post(url, {
                               headers: headers,
                               body: payload.to_json,
                               timeout: 60
                             })

    handle_response(response)
  end

  def get_request(endpoint)
    url = "#{base_url}#{endpoint}"

    response = HTTParty.get(url, {
                              headers: headers,
                              timeout: 30
                            })

    handle_response(response)
  end

  def handle_response(response)
    case response.code
    when 200..299
      JSON.parse(response.body)
    when 401
      raise AuthenticationError, "Invalid API key for #{@provider}"
    when 429
      raise RateLimitError, "Rate limit exceeded for #{@provider}"
    when 500..599
      raise ServiceError, "#{@provider} service unavailable"
    else
      raise APIError, "API error: #{response.code} - #{response.body}"
    end
  rescue JSON::ParserError
    response.body
  end

  # Provider-specific implementations
  def openai_complete(prompt, options)
    payload = {
      model: @model,
      messages: [{ role: 'user', content: prompt }],
      **options.except(:stream)
    }

    response = post_request('/chat/completions', payload)
    response.dig('choices', 0, 'message', 'content')
  end

  def anthropic_complete(prompt, options)
    payload = {
      model: @model,
      messages: [{ role: 'user', content: prompt }],
      max_tokens: options[:max_tokens] || 4096
    }

    response = post_request('/messages', payload)
    response.dig('content', 0, 'text')
  end

  def google_complete(prompt, options)
    payload = {
      contents: [{ parts: [{ text: prompt }] }],
      generationConfig: {
        temperature: options[:temperature],
        maxOutputTokens: options[:max_tokens]
      }
    }

    response = post_request("/models/#{@model}:generateContent?key=#{ENV['GOOGLE_AI_API_KEY']}", payload)
    response.dig('candidates', 0, 'content', 'parts', 0, 'text')
  end

  def runwayml_complete(prompt, options)
    # RunwayML primarily for video/image generation
    generate_video(prompt, **options)
  end

  def runwayml_generate_image(prompt, options)
    payload = {
      model: 'stable-diffusion',
      prompt: prompt,
      width: options[:width] || 512,
      height: options[:height] || 512,
      steps: options[:steps] || 20
    }

    response = post_request('/generations/images', payload)
    response['image_url']
  end

  # Streaming implementations
  def openai_stream(prompt, options, &block)
    # Implementation for OpenAI streaming
    # This would use Server-Sent Events (SSE)
    payload = {
      model: @model,
      messages: [{ role: 'user', content: prompt }],
      stream: true,
      **options.except(:stream)
    }

    # Streaming implementation would go here
    # For now, fallback to regular completion
    complete(prompt, **options.except(:stream))
  end

  # Error handling
  def handle_error(error)
    Rails.logger.error "AI Service Error (#{@provider}): #{error.message}"

    case error
    when Net::TimeoutError
      raise TimeoutError, "Request timed out for #{@provider}"
    when Errno::ECONNREFUSED
      raise ConnectionError, "Could not connect to #{@provider}"
    else
      raise error
    end
  end

  # Helper methods for async operations
  def poll_transcription(transcription_id)
    max_attempts = 60 # 5 minutes with 5-second intervals
    attempts = 0

    loop do
      response = get_request("/transcript/#{transcription_id}")
      status = response['status']

      case status
      when 'completed'
        return response['text']
      when 'error'
        raise TranscriptionError, response['error']
      when 'processing', 'queued'
        attempts += 1
        raise TimeoutError, 'Transcription timed out' if attempts >= max_attempts

        sleep 5
      end
    end
  end

  def handle_runwayml_response(response)
    if response['status'] == 'processing'
      # Poll for completion
      job_id = response['id']
      poll_runwayml_job(job_id)
    else
      response
    end
  end

  def poll_runwayml_job(job_id)
    max_attempts = 120 # 10 minutes for video generation
    attempts = 0

    loop do
      response = get_request("/generations/#{job_id}")
      status = response['status']

      case status
      when 'completed'
        return response['video_url'] || response['image_url']
      when 'failed'
        raise GenerationError, response['error']
      when 'processing', 'queued'
        attempts += 1
        raise TimeoutError, 'Generation timed out' if attempts >= max_attempts

        sleep 5
      end
    end
  end

  # Custom exception classes
  class BaseAiServiceError < StandardError; end
  class InvalidProviderError < BaseAiServiceError; end
  class UnsupportedProviderError < BaseAiServiceError; end
  class UnsupportedOperationError < BaseAiServiceError; end
  class MissingApiKeyError < BaseAiServiceError; end
  class AuthenticationError < BaseAiServiceError; end
  class RateLimitError < BaseAiServiceError; end
  class ServiceError < BaseAiServiceError; end
  class APIError < BaseAiServiceError; end
  class TimeoutError < BaseAiServiceError; end
  class ConnectionError < BaseAiServiceError; end
  class TranscriptionError < BaseAiServiceError; end
  class GenerationError < BaseAiServiceError; end
end
