# frozen_string_literal: true

# AI Agent Engine - Base class for all AI agent implementations
class AiAgentEngine
  attr_reader :agent, :model_name, :personality, :capabilities

  def initialize(agent, options = {})
    @agent = agent
    @model_name = options[:model_name] || select_default_model
    @personality = build_personality_prompt
    @capabilities = agent.capabilities || []
    @conversation_memory = {}
  end

  # Main interaction method
  def process_request(input_data, context = {})
    # Build the prompt with personality and context
    prompt = build_prompt(input_data, context)

    # Generate response using AI model
    model_response = AiModelService.generate(@model_name, prompt, generation_options)

    # Process and enhance the response
    processed_response = process_response(model_response, input_data, context)

    # Store conversation memory
    store_conversation_memory(input_data, processed_response, context)

    # Return formatted response
    {
      success: model_response[:success],
      response: processed_response,
      agent_id: @agent.id.to_s,
      agent_name: @agent.name,
      model_used: @model_name,
      processing_time_ms: model_response[:processing_time_ms],
      tokens_used: model_response[:tokens_used],
      metadata: {
        capabilities_used: detect_capabilities_used(input_data),
        personality_applied: true,
        context_length: prompt.length,
        timestamp: Time.current
      }
    }
  rescue StandardError => e
    Rails.logger.error "Agent Engine Error (#{@agent.name}): #{e.message}"

    {
      success: false,
      error: e.message,
      agent_id: @agent.id.to_s,
      agent_name: @agent.name,
      fallback_response: generate_fallback_response,
      timestamp: Time.current
    }
  end

  # Stream response for real-time interactions
  def stream_response(input_data, context = {})
    # For streaming, we'll simulate it by chunking the response
    # In a real implementation, you'd use the streaming API
    response = process_request(input_data, context)

    if response[:success]
      text = response[:response]
      chunks = text.scan(/.{1,50}/)

      chunks.each_with_index do |chunk, index|
        yield({
          chunk: chunk,
          index: index,
          finished: index == chunks.length - 1,
          agent_name: @agent.name
        })
        sleep(0.1) # Simulate streaming delay
      end
    else
      yield({
        error: response[:error],
        finished: true,
        agent_name: @agent.name
      })
    end
  end

  private

  def select_default_model
    # Select model based on agent type and capabilities
    case @agent.agent_type
    when 'cinegen', 'video', 'creative'
      'gpt_oss' # Better for creative tasks
    when 'codemaster', 'technical', 'programming'
      'phi4' # Best for code generation
    when 'datasphere', 'analysis', 'research'
      'deepseek' # Best for analysis
    when 'chat', 'conversation', 'simple'
      'llama32' # Lightweight for quick responses
    else
      'llama32' # Default general-purpose model
    end
  end

  def build_personality_prompt
    traits = @agent.personality_traits || {}
    config = @agent.configuration || {}

    base_prompt = "You are #{@agent.name}, #{config['tagline'] || 'an AI assistant'}.\n"

    if traits.is_a?(Hash)
      if traits['primary_traits']
        base_prompt += "Your primary personality traits: #{traits['primary_traits'].join(', ')}.\n"
      end

      base_prompt += "Communication style: #{traits['communication_style']}.\n" if traits['communication_style']

      base_prompt += "Expertise level: #{traits['expertise_level']}.\n" if traits['expertise_level']
    end

    base_prompt += "Your capabilities include: #{@capabilities.join(', ')}.\n" if @capabilities.any?

    base_prompt += "Always respond in character and use your specialized knowledge to provide helpful, accurate responses.\n\n"

    base_prompt
  end

  def build_prompt(input_data, context)
    prompt = @personality

    # Add conversation history if available
    if context[:conversation_history] && context[:conversation_history].any?
      prompt += "Previous conversation:\n"
      context[:conversation_history].last(3).each do |msg|
        prompt += "#{msg[:role]}: #{msg[:content]}\n"
      end
      prompt += "\n"
    end

    # Add specific context
    prompt += "Additional context: #{context[:additional_context]}\n\n" if context[:additional_context]

    # Add the current request
    user_input = extract_user_input(input_data)
    prompt += "User: #{user_input}\n"
    prompt += "#{@agent.name}:"

    prompt
  end

  def extract_user_input(input_data)
    case input_data
    when String
      input_data
    when Hash
      input_data['message'] || input_data['prompt'] || input_data['text'] || input_data.to_s
    else
      input_data.to_s
    end
  end

  def generation_options
    {
      temperature: 0.7,
      max_tokens: 2048,
      top_p: 0.9
    }
  end

  def process_response(model_response, input_data, context)
    return model_response[:error] unless model_response[:success]

    response_text = model_response[:response]

    # Clean up the response
    response_text = response_text.strip

    # Remove any agent name prefix if it was added
    response_text = response_text.gsub(/^#{@agent.name}:\s*/, '')

    # Apply any agent-specific post-processing
    apply_agent_specific_processing(response_text, input_data, context)
  end

  def apply_agent_specific_processing(response, _input_data, _context)
    # This can be overridden in specific agent implementations
    # For now, just return the response as-is
    response
  end

  def detect_capabilities_used(input_data)
    used_capabilities = []
    input_text = extract_user_input(input_data).downcase

    @capabilities.each do |capability|
      capability_keywords = capability.split('_')
      used_capabilities << capability if capability_keywords.any? { |keyword| input_text.include?(keyword) }
    end

    used_capabilities
  end

  def store_conversation_memory(input_data, response, context)
    user_input = extract_user_input(input_data)

    @conversation_memory[Time.current.to_i] = {
      user_input: user_input,
      agent_response: response,
      context: context,
      timestamp: Time.current
    }

    # Keep only last 10 interactions in memory
    if @conversation_memory.size > 10
      oldest_key = @conversation_memory.keys.min
      @conversation_memory.delete(oldest_key)
    end

    # Also store in database for persistence
    AgentMemory.store_memory(
      @agent,
      'conversation',
      "session_#{context[:session_id] || 'default'}",
      {
        user_input: user_input,
        agent_response: response,
        interaction_time: Time.current
      },
      {
        expires_at: 24.hours.from_now,
        importance_score: calculate_importance_score(user_input, response)
      }
    )
  end

  def calculate_importance_score(user_input, response)
    # Simple scoring based on length and complexity
    score = 1.0
    score += 1.0 if user_input.length > 100
    score += 1.0 if response.length > 200
    score += 2.0 if user_input.match?(/\b(important|urgent|help|problem)\b/i)

    [score, 10.0].min # Cap at 10.0
  end

  def generate_fallback_response
    "I apologize, but I'm experiencing some technical difficulties right now. " \
    'Please try again in a moment, or rephrase your request. ' \
    "As #{@agent.name}, I'm here to help with #{@capabilities.join(', ')} when I'm back online."
  end
end
