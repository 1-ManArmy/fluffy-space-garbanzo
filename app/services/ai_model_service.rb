# frozen_string_literal: true

require 'net/http'
require 'json'

# AI Model Service - Handles communication with Docker-hosted AI models
class AiModelService
  # Model configurations
  MODELS = {
    'llama32' => {
      endpoint: 'http://localhost:8080/api/llama32',
      model_name: 'llama3.2:3b',
      description: 'Lightweight general-purpose model (3.21B parameters)',
      strengths: %w[general_conversation quick_responses lightweight],
      max_context: 8192,
      timeout: 30
    },
    'gemma3' => {
      endpoint: 'http://localhost:8080/api/gemma3',
      model_name: 'gemma2:2b',
      description: 'Efficient specialized task model (3.88B parameters)',
      strengths: %w[specialized_tasks efficient_processing domain_specific],
      max_context: 8192,
      timeout: 30
    },
    'phi4' => {
      endpoint: 'http://localhost:8080/api/phi4',
      model_name: 'phi3:14b',
      description: 'Advanced reasoning and code generation (14.66B parameters)',
      strengths: %w[code_generation complex_reasoning technical_analysis],
      max_context: 32_768,
      timeout: 60
    },
    'deepseek' => {
      endpoint: 'http://localhost:8080/api/deepseek',
      model_name: 'deepseek-coder:6.7b',
      description: 'Reasoning and analysis specialist (8.03B parameters)',
      strengths: %w[deep_analysis reasoning problem_solving],
      max_context: 16_384,
      timeout: 45
    },
    'gpt_oss' => {
      endpoint: 'http://localhost:8080/api/gpt-oss',
      model_name: 'mistral:7b',
      description: 'Open source GPT alternative',
      strengths: %w[general_purpose creative_writing conversation],
      max_context: 8192,
      timeout: 45
    }
  }.freeze

  class << self
    # Generate response using specified model
    def generate(model_name, prompt, options = {})
      model_config = MODELS[model_name.to_s]
      raise ArgumentError, "Unknown model: #{model_name}" unless model_config

      request_payload = build_request_payload(model_config, prompt, options)

      start_time = Time.current
      response = make_request(model_config[:endpoint], request_payload, model_config[:timeout])
      processing_time = ((Time.current - start_time) * 1000).to_i

      {
        success: true,
        response: parse_response(response),
        model: model_name,
        processing_time_ms: processing_time,
        tokens_used: estimate_tokens(prompt + (response['response'] || '')),
        metadata: {
          model_config: model_config,
          request_options: options
        }
      }
    rescue StandardError => e
      Rails.logger.error "AI Model Error (#{model_name}): #{e.message}"

      {
        success: false,
        error: e.message,
        model: model_name,
        processing_time_ms: 0,
        tokens_used: 0
      }
    end

    # Smart model selection based on task type
    def smart_generate(prompt, task_type = 'general', options = {})
      model_name = select_best_model(task_type, prompt.length)
      generate(model_name, prompt, options.merge(selected_by: 'smart_routing'))
    end

    # Check model availability
    def model_status(model_name = nil)
      if model_name
        check_single_model(model_name)
      else
        check_all_models
      end
    end

    # Get available models
    def available_models
      MODELS.keys
    end

    # Get model information
    def model_info(model_name)
      MODELS[model_name.to_s]
    end

    private

    def build_request_payload(model_config, prompt, options)
      {
        model: model_config[:model_name],
        prompt: prompt,
        stream: false,
        options: {
          temperature: options[:temperature] || 0.7,
          top_p: options[:top_p] || 0.9,
          max_tokens: options[:max_tokens] || 2048,
          stop: options[:stop_sequences] || []
        }
      }
    end

    def make_request(endpoint, payload, timeout)
      uri = URI("#{endpoint}/api/generate")

      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = timeout
      http.open_timeout = 10

      request = Net::HTTP::Post.new(uri)
      request['Content-Type'] = 'application/json'
      request.body = payload.to_json

      response = http.request(request)

      raise "HTTP #{response.code}: #{response.body}" unless response.code.to_i == 200

      JSON.parse(response.body)
    end

    def parse_response(response)
      response['response'] || response['content'] || response.to_s
    end

    def estimate_tokens(text)
      # Rough estimation: 1 token ≈ 4 characters
      (text.length / 4.0).ceil
    end

    def select_best_model(task_type, prompt_length)
      case task_type.to_s.downcase
      when 'code', 'programming', 'technical'
        prompt_length > 4000 ? 'phi4' : 'deepseek'
      when 'analysis', 'reasoning', 'research'
        'deepseek'
      when 'creative', 'writing', 'story'
        'gpt_oss'
      when 'quick', 'simple', 'chat'
        'llama32'
      when 'specialized', 'domain_specific'
        'gemma3'
      else
        # Default to llama32 for general tasks
        'llama32'
      end
    end

    def check_single_model(model_name)
      model_config = MODELS[model_name.to_s]
      return { status: 'unknown', error: 'Model not found' } unless model_config

      begin
        uri = URI("#{model_config[:endpoint]}/api/version")
        response = Net::HTTP.get_response(uri)

        {
          status: response.code.to_i == 200 ? 'online' : 'offline',
          model: model_name,
          endpoint: model_config[:endpoint],
          last_checked: Time.current
        }
      rescue StandardError => e
        {
          status: 'offline',
          model: model_name,
          error: e.message,
          last_checked: Time.current
        }
      end
    end

    def check_all_models
      results = {}

      MODELS.each do |model_name, _config|
        results[model_name] = check_single_model(model_name)
      end

      {
        gateway_status: gateway_status,
        models: results,
        checked_at: Time.current
      }
    end

    def gateway_status
      uri = URI('http://localhost:8080/health')
      response = Net::HTTP.get_response(uri)
      response.code.to_i == 200 ? 'online' : 'offline'
    rescue StandardError
      'offline'
    end
  end
end
