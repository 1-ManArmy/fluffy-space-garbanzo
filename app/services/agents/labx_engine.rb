# frozen_string_literal: true

module Agents
  class LabxEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'labx'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Labx
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Labx #{@config['emoji'] || '🌌'}, your specialized labx assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Labx, I specialize in labx-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My labx capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
