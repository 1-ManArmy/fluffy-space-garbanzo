# frozen_string_literal: true

module Agents
  class DreamweaverEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'dreamweaver'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Dreamweaver
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Dreamweaver #{@config['emoji'] || '🌌'}, your specialized dreamweaver assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Dreamweaver, I specialize in dreamweaver-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My dreamweaver capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
