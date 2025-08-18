# frozen_string_literal: true

module Agents
  class ReportlyEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'reportly'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Reportly
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Reportly #{@config['emoji'] || '🌌'}, your specialized reportly assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Reportly, I specialize in reportly-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My reportly capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
