# frozen_string_literal: true

module Agents
  class BaseAgentEngine < BaseEngine
    def initialize(agent)
      @agent = agent
      @agent_name = agent.name
      @agent_type = agent.agent_type
      @personality = agent.personality_traits
      @capabilities = agent.capabilities
      @config = agent.configuration || {}
    end
    
    def process_input(user, input, context = {})
      start_time = Time.current
      
      # Analyze user input
      user_context = analyze_user_input(user, input, context)
      
      # Generate response based on agent type and personality
      response_text = generate_agent_response(input, user_context)
      
      processing_time = (Time.current - start_time).round(3)
      
      {
        text: response_text,
        processing_time: processing_time,
        agent_type: @agent_type,
        user_context: user_context
      }
    end
    
    private
    
    def analyze_user_input(user, input, context)
      {
        input_type: detect_input_type(input),
        sentiment: analyze_sentiment(input),
        intent: detect_intent(input),
        entities: extract_entities(input),
        context: context,
        user_preferences: user&.preferences ? JSON.parse(user.preferences) : {}
      }
    end
    
    def generate_agent_response(input, user_context)
      # Base response generation - can be overridden by specific agent engines
      agent_personality = @personality.sample(3).join(', ')
      agent_emoji = @config['emoji'] || '🌌'
      
      case user_context[:intent]
      when 'greeting'
        generate_greeting_response
      when 'question'
        generate_question_response(input, user_context)
      when 'task'
        generate_task_response(input, user_context)
      when 'casual'
        generate_casual_response(input, user_context)
      else
        generate_default_response(input, user_context)
      end
    end
    
    def generate_greeting_response
      greetings = [
        "Hello! I'm #{@agent_name} #{@config['emoji'] || '🌌'}, ready to help!",
        "Greetings! #{@agent_name} here, what can I assist you with today?",
        "Hi there! #{@agent_name} at your service #{@config['emoji'] || '🌌'}",
        "Welcome! I'm #{@agent_name}, your AI assistant. How can I help?"
      ]
      greetings.sample
    end
    
    def generate_question_response(input, user_context)
      "Great question! As #{@agent_name}, I'd be happy to help you with that. Let me analyze your query and provide you with the best possible answer based on my #{@agent_type} capabilities."
    end
    
    def generate_task_response(input, user_context)
      "I understand you'd like me to help with a task. As #{@agent_name}, I'm equipped with #{@capabilities.join(', ')} capabilities. Let me process your request and get started!"
    end
    
    def generate_casual_response(input, user_context)
      personality_traits = @personality.sample(2).join(' and ')
      "Thanks for chatting with me! I'm #{@agent_name}, and I tend to be #{personality_traits}. #{@config['emoji'] || '🌌'} What's on your mind?"
    end
    
    def generate_default_response(input, user_context)
      "I'm #{@agent_name} #{@config['emoji'] || '🌌'}, your #{@agent_type.humanize} assistant. I noticed you said: '#{input.truncate(50)}'. How can I help you with that? My specializations include #{@agent.specializations.sample(3).join(', ')}."
    end
    
    def detect_input_type(input)
      return 'voice' if input.include?('[voice]')
      return 'command' if input.start_with?('/')
      return 'code' if input.include?('```')
      'text'
    end
    
    def analyze_sentiment(input)
      positive_words = ['good', 'great', 'awesome', 'excellent', 'love', 'like', 'happy', 'yes']
      negative_words = ['bad', 'terrible', 'hate', 'no', 'sad', 'angry', 'frustrated']
      
      input_lower = input.downcase
      positive_score = positive_words.count { |word| input_lower.include?(word) }
      negative_score = negative_words.count { |word| input_lower.include?(word) }
      
      if positive_score > negative_score
        'positive'
      elsif negative_score > positive_score
        'negative'
      else
        'neutral'
      end
    end
    
    def detect_intent(input)
      input_lower = input.downcase
      
      return 'greeting' if input_lower.match?(/\b(hi|hello|hey|greetings|good morning|good afternoon)\b/)
      return 'question' if input_lower.match?(/\b(what|how|why|when|where|who|can you|could you)\b/)
      return 'task' if input_lower.match?(/\b(help me|can you|please|create|generate|make|build)\b/)
      return 'farewell' if input_lower.match?(/\b(bye|goodbye|see you|farewell|thanks)\b/)
      
      'casual'
    end
    
    def extract_entities(input)
      # Simple entity extraction
      entities = []
      
      # Extract mentions of technologies
      tech_terms = ['AI', 'machine learning', 'neural network', 'algorithm', 'code', 'programming']
      tech_terms.each do |term|
        entities << { type: 'technology', value: term } if input.downcase.include?(term.downcase)
      end
      
      # Extract numbers
      numbers = input.scan(/\d+/)
      numbers.each { |num| entities << { type: 'number', value: num } }
      
      entities
    end
  end
end
