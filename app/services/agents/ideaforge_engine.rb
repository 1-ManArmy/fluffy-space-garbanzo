# frozen_string_literal: true

module Agents
  class IdeaforgeEngine < BaseAgentEngine
    def initialize(agent)
      super(agent)
      @agent_specialization = 'ideaforge'
    end
    
    private
    
    def generate_agent_response(input, user_context)
      # Custom response logic for Ideaforge
      case user_context[:intent]
      when 'greeting'
        "Hello! I'm Ideaforge #{@config['emoji'] || '🌌'}, your specialized ideaforge assistant. How can I help you today?"
      when 'question'
        "Excellent question! As Ideaforge, I specialize in ideaforge-related tasks. Let me help you with that."
      when 'task'
        "I'd love to help you with that task! My ideaforge capabilities are perfect for what you need."
      else
        super(input, user_context)
      end
    end
  end
end
