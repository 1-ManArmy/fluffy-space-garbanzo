# frozen_string_literal: true

module Agents
  class VocamindEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'vocamind'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Vocamind
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Vocamind #{@config['emoji'] || '🌌'}, your specialized vocamind assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Vocamind, I specialize in vocamind-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My vocamind capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
