# frozen_string_literal: true

module Agents
  class PersonaxEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'personax'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Personax
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Personax #{@config['emoji'] || '🌌'}, your specialized personax assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Personax, I specialize in personax-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My personax capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
