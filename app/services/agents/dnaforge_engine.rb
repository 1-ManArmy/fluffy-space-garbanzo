# frozen_string_literal: true

module Agents
  class DnaforgeEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'dnaforge'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Dnaforge
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Dnaforge #{@config['emoji'] || '🌌'}, your specialized dnaforge assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Dnaforge, I specialize in dnaforge-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My dnaforge capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
