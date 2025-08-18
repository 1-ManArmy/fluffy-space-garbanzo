# frozen_string_literal: true

module Agents
  class DocumindEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'documind'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Documind
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Documind #{@config['emoji'] || '🌌'}, your specialized documind assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Documind, I specialize in documind-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My documind capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
