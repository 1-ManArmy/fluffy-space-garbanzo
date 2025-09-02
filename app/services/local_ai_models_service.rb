# frozen_string_literal: true

# Local AI Models Service - Manages communication with local AI models
# Supports the new AI model infrastructure with load balancing and failover

require 'net/http'
require 'uri'
require 'json'

class LocalAiModelsService
  include HTTParty
  
  # Model Configuration
  MODELS_CONFIG = {
    'llama3_2' => {
      endpoint: 'http://localhost:11434',
      model_name: 'llama3.2:3b-instruct-q4_k_m',
      capabilities: ['general_conversation', 'code_assistance', 'reasoning'],
      max_tokens: 4096,
      temperature_range: [0.1, 0.9]
    },
    'gemma3_qat' => {
      endpoint: 'http://localhost:11435',
      model_name: 'gemma2:2b-instruct-q4_0',
      capabilities: ['specialized_tasks', 'efficient_processing', 'domain_specific'],
      max_tokens: 2048,
      temperature_range: [0.2, 0.8]
    },
    'phi4' => {
      endpoint: 'http://localhost:11436',
      model_name: 'phi3:14b-medium-4k-instruct-q4_k_m',
      capabilities: ['advanced_reasoning', 'code_generation', 'complex_analysis'],
      max_tokens: 4096,
      temperature_range: [0.1, 0.7]
    },
    'deepseek_r1' => {
      endpoint: 'http://localhost:11437',
      model_name: 'deepseek-coder:6.7b-instruct-q4_k_m',
      capabilities: ['reasoning', 'analysis', 'problem_solving'],
      max_tokens: 4096,
      temperature_range: [0.1, 0.8]
    },
    'gpt_oss' => {
      endpoint: 'http://localhost:11438',
      model_name: 'mistral:7b-instruct-q4_k_m',
      capabilities: ['open_source_gpt', 'general_purpose'],
      max_tokens: 4096,
      temperature_range: [0.2, 0.9]
    },
    'smollm2' => {
      endpoint: 'http://localhost:11439',
      model_name: 'tinyllama:1.1b-chat-q4_k_m',
      capabilities: ['lightweight_processing', 'fast_responses', 'edge_deployment'],
      max_tokens: 1024,
      temperature_range: [0.3, 0.9]
    },
    'mistral' => {
      endpoint: 'http://localhost:11440',
      model_name: 'mistral:7b-instruct-v0.2-q4_k_m',
      capabilities: ['multilingual', 'code_generation', 'instruction_following'],
      max_tokens: 4096,
      temperature_range: [0.1, 0.8]
    }
  }.freeze

  # Agent to Model Mapping
  AGENT_MODEL_MAPPING = {
    # Conversation Agents
    'neochat' => ['llama3_2', 'gpt_oss'],
    'personax' => ['smollm2', 'llama3_2'],
    'girlfriend' => ['llama3_2', 'smollm2'],
    'emotisense' => ['gemma3_qat', 'smollm2'],
    'callghost' => ['smollm2', 'llama3_2'],
    'memora' => ['llama3_2', 'deepseek_r1'],
    
    # Technical Agents
    'configai' => ['phi4', 'gemma3_qat'],
    'infoseek' => ['phi4', 'llama3_2'],
    'documind' => ['mistral', 'llama3_2'],
    'netscope' => ['deepseek_r1', 'phi4'],
    'authwise' => ['gemma3_qat', 'deepseek_r1'],
    'spylens' => ['deepseek_r1', 'phi4'],
    
    # Creative Agents
    'cinegen' => ['mistral', 'llama3_2'],
    'contentcrafter' => ['mistral', 'gpt_oss'],
    'dreamweaver' => ['gpt_oss', 'llama3_2'],
    'ideaforge' => ['gpt_oss', 'mistral'],
    'aiblogster' => ['mistral', 'llama3_2'],
    'vocamind' => ['smollm2', 'llama3_2'],
    
    # Business Intelligence
    'datasphere' => ['deepseek_r1', 'phi4'],
    'datavision' => ['phi4', 'deepseek_r1'],
    'taskmaster' => ['llama3_2', 'gemma3_qat'],
    'reportly' => ['gemma3_qat', 'mistral'],
    'dnaforge' => ['deepseek_r1', 'phi4'],
    'carebot' => ['gemma3_qat', 'llama3_2'],
    'codemaster' => ['phi4', 'mistral']
  }.freeze

  def initialize(options = {})
    @default_timeout = options[:timeout] || 30
    @max_retries = options[:max_retries] || 2
    @health_check_interval = options[:health_check_interval] || 60
    @model_health_status = {}
    
    # Start health monitoring
    start_health_monitoring if options[:enable_monitoring] != false
  end

  # Main method to generate response using local models
  def generate_response(agent_name, prompt, options = {})
    models = get_models_for_agent(agent_name)
    
    models.each do |model_name|
      begin
        return generate_with_model(model_name, prompt, options)
      rescue ModelUnavailableError => e
        Rails.logger.warn "Model #{model_name} unavailable for #{agent_name}: #{e.message}"
        next # Try next model
      rescue => e
        Rails.logger.error "Error with model #{model_name} for #{agent_name}: #{e.message}"
        next # Try next model
      end
    end
    
    # If all local models fail, fallback to cloud
    Rails.logger.warn "All local models failed for #{agent_name}, falling back to cloud"
    fallback_to_cloud(agent_name, prompt, options)
  end

  # Generate response with specific model
  def generate_with_model(model_name, prompt, options = {})
    model_config = MODELS_CONFIG[model_name]
    raise ModelNotFoundError, "Model #{model_name} not configured" unless model_config

    # Check model health
    unless model_healthy?(model_name)
      raise ModelUnavailableError, "Model #{model_name} is not healthy"
    end

    # Prepare request payload
    payload = build_payload(model_config, prompt, options)
    
    # Make request to model endpoint
    response = make_request(model_config[:endpoint], payload)
    
    # Process and return response
    process_response(response)
  end

  # Check if model is healthy
  def model_healthy?(model_name)
    return false unless MODELS_CONFIG.key?(model_name)
    
    # Check cached health status
    cached_status = @model_health_status[model_name]
    if cached_status && (Time.current - cached_status[:checked_at] < @health_check_interval)
      return cached_status[:healthy]
    end
    
    # Perform health check
    health_status = perform_health_check(model_name)
    @model_health_status[model_name] = {
      healthy: health_status,
      checked_at: Time.current
    }
    
    health_status
  end

  # Get available models for agent
  def get_models_for_agent(agent_name)
    AGENT_MODEL_MAPPING[agent_name] || ['llama3_2'] # Default fallback
  end

  # Get model statistics
  def get_model_stats
    stats = {}
    
    MODELS_CONFIG.each do |model_name, config|
      stats[model_name] = {
        healthy: model_healthy?(model_name),
        endpoint: config[:endpoint],
        capabilities: config[:capabilities],
        last_checked: @model_health_status[model_name]&.dig(:checked_at)
      }
    end
    
    stats
  end

  # Stream response (for real-time interactions)
  def stream_response(agent_name, prompt, options = {}, &block)
    models = get_models_for_agent(agent_name)
    
    models.each do |model_name|
      begin
        return stream_with_model(model_name, prompt, options, &block)
      rescue ModelUnavailableError => e
        Rails.logger.warn "Model #{model_name} unavailable for streaming: #{e.message}"
        next
      rescue => e
        Rails.logger.error "Streaming error with model #{model_name}: #{e.message}"
        next
      end
    end
    
    # Fallback to cloud streaming
    fallback_stream_to_cloud(agent_name, prompt, options, &block)
  end

  private

  def build_payload(model_config, prompt, options)
    temperature = options[:temperature] || 0.7
    max_tokens = options[:max_tokens] || model_config[:max_tokens]
    
    # Ensure temperature is within model's range
    temp_range = model_config[:temperature_range]
    temperature = [[temperature, temp_range[0]].max, temp_range[1]].min
    
    {
      model: model_config[:model_name],
      prompt: prompt,
      stream: false,
      options: {
        temperature: temperature,
        num_predict: max_tokens,
        top_k: options[:top_k] || 40,
        top_p: options[:top_p] || 0.9,
        repeat_penalty: options[:repeat_penalty] || 1.1
      }
    }
  end

  def make_request(endpoint, payload)
    uri = URI("#{endpoint}/api/generate")
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = @default_timeout
    
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = payload.to_json
    
    response = http.request(request)
    
    unless response.code.to_i == 200
      raise RequestError, "HTTP #{response.code}: #{response.body}"
    end
    
    JSON.parse(response.body)
  end

  def process_response(response)
    if response['response']
      {
        text: response['response'],
        model: response['model'],
        context: response['context'],
        processing_time: response['total_duration'] || 0,
        tokens_generated: response['eval_count'] || 0
      }
    else
      raise ResponseError, "Invalid response format: #{response}"
    end
  end

  def perform_health_check(model_name)
    model_config = MODELS_CONFIG[model_name]
    
    begin
      uri = URI("#{model_config[:endpoint]}/api/version")
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 5
      
      request = Net::HTTP::Get.new(uri)
      response = http.request(request)
      
      response.code.to_i == 200
    rescue => e
      Rails.logger.debug "Health check failed for #{model_name}: #{e.message}"
      false
    end
  end

  def stream_with_model(model_name, prompt, options, &block)
    model_config = MODELS_CONFIG[model_name]
    payload = build_payload(model_config, prompt, options)
    payload[:stream] = true
    
    uri = URI("#{model_config[:endpoint]}/api/generate")
    http = Net::HTTP.new(uri.host, uri.port)
    
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = payload.to_json
    
    http.request(request) do |response|
      response.read_body do |chunk|
        begin
          data = JSON.parse(chunk)
          if data['response']
            block.call(data['response']) if block_given?
          end
        rescue JSON::ParserError
          # Skip invalid JSON chunks
          next
        end
      end
    end
  end

  def fallback_to_cloud(agent_name, prompt, options)
    # Use existing BaseAiService for cloud fallback
    cloud_service = BaseAiService.new(provider: :openai, model: 'gpt-3.5-turbo')
    
    response = cloud_service.complete(prompt, options)
    
    {
      text: response,
      model: 'openai:gpt-3.5-turbo',
      context: nil,
      processing_time: 0,
      tokens_generated: 0,
      fallback: true
    }
  end

  def fallback_stream_to_cloud(agent_name, prompt, options, &block)
    # Implement cloud streaming fallback
    cloud_service = BaseAiService.new(provider: :openai, model: 'gpt-3.5-turbo')
    
    # For now, simulate streaming by chunking the response
    response = cloud_service.complete(prompt, options)
    
    # Simulate streaming by breaking response into chunks
    words = response.split(' ')
    words.each_slice(3) do |chunk|
      block.call(chunk.join(' ') + ' ') if block_given?
      sleep(0.1) # Simulate streaming delay
    end
  end

  def start_health_monitoring
    Thread.new do
      loop do
        begin
          MODELS_CONFIG.keys.each do |model_name|
            perform_health_check(model_name)
          end
        rescue => e
          Rails.logger.error "Health monitoring error: #{e.message}"
        end
        
        sleep(@health_check_interval)
      end
    end
  end

  # Custom exception classes
  class LocalAiModelsError < StandardError; end
  class ModelNotFoundError < LocalAiModelsError; end
  class ModelUnavailableError < LocalAiModelsError; end
  class RequestError < LocalAiModelsError; end
  class ResponseError < LocalAiModelsError; end
end
