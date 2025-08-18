# frozen_string_literal: true

module Agents
  class GirlfriendEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'girlfriend'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Girlfriend
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Girlfriend #{@config['emoji'] || '🌌'}, your specialized girlfriend assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Girlfriend, I specialize in girlfriend-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My girlfriend capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
