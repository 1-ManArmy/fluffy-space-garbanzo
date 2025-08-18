# frozen_string_literal: true

module Agents
  # NeoChat Engine - The Universal Chat Assistant
  # A versatile AI agent capable of answering questions, providing suggestions,
  # and engaging in helpful conversations across all topics
  
  class NeochatEngine < BaseEngine
    def initialize(agent)
      super
      @agent_name = "NeoChat"
      @primary_capabilities = [
        'general_conversation',
        'question_answering', 
        'suggestions_and_advice',
        'problem_solving',
        'information_synthesis',
        'creative_brainstorming'
      ]
    end
    
    def process_input(user, input, context = {})
      start_time = Time.current
      
      # Build conversation context
      conversation_context = build_context(user, input, context)
      
      # Generate response based on NeoChat's personality
      response_text = generate_neochat_response(input, conversation_context)
      
      # Track processing time
      processing_time = (Time.current - start_time).round(3)
      
      {
        text: response_text,
        agent: @agent_name,
        processing_time: processing_time,
        context: conversation_context,
        capabilities_used: determine_capabilities_used(input)
      }
    end
    
    private
    
    def generate_neochat_response(input, context)
      # Analyze input type and respond accordingly
      response_type = analyze_input_type(input)
      
      case response_type
      when :question
        generate_answer_response(input, context)
      when :request_for_help
        generate_assistance_response(input, context)  
      when :creative_prompt
        generate_creative_response(input, context)
      when :casual_conversation
        generate_conversational_response(input, context)
      when :problem_solving
        generate_problem_solving_response(input, context)
      else
        generate_default_response(input, context)
      end
    end
    
    def analyze_input_type(input)
      input_lower = input.downcase
      
      return :question if input_lower.match?(/\b(what|how|why|when|where|who|which|can you|do you know)\b/)
      return :request_for_help if input_lower.match?(/\b(help|assist|support|guide|show me|teach me)\b/)
      return :creative_prompt if input_lower.match?(/\b(create|generate|brainstorm|imagine|design|come up with)\b/)
      return :problem_solving if input_lower.match?(/\b(solve|fix|resolve|figure out|work out)\b/)
      return :casual_conversation if input_lower.match?(/\b(hello|hi|hey|good|thanks|bye)\b/)
      
      :general_inquiry
    end
    
    def generate_answer_response(input, context)
      # Base response with NeoChat's knowledgeable personality
      responses = [
        "Great question! Let me break this down for you...",
        "I'd be happy to help explain that...", 
        "That's an interesting topic. Here's what I know...",
        "Let me provide you with a comprehensive answer...",
        "Excellent question! Here's the information you're looking for..."
      ]
      
      base_response = responses.sample
      
      # Add specific helpful content based on context
      if context[:emotional_context]&.include?('confused')
        base_response += " I'll make sure to explain this clearly and step by step."
      elsif context[:emotional_context]&.include?('urgent')
        base_response += " I'll get straight to the point for you."
      end
      
      base_response += "\n\n💡 **Key Points:**\n"
      base_response += "• I'm here to provide accurate, helpful information\n"
      base_response += "• Feel free to ask follow-up questions for clarification\n"
      base_response += "• I can break down complex topics into simpler parts\n\n"
      base_response += "What specific aspect would you like me to focus on?"
    end
    
    def generate_assistance_response(input, context)
      responses = [
        "I'm here to help! Let me assist you with that...",
        "Absolutely! I'd be glad to guide you through this...",
        "No problem at all! Here's how I can help...",
        "I'm ready to support you. Let's tackle this together...",
        "Perfect! I love helping people solve challenges..."
      ]
      
      base_response = responses.sample
      base_response += "\n\n🚀 **How I Can Assist:**\n"
      base_response += "• Step-by-step guidance and explanations\n"
      base_response += "• Breaking down complex problems into manageable parts\n"
      base_response += "• Providing multiple approaches and perspectives\n"
      base_response += "• Offering practical tips and best practices\n\n"
      base_response += "Tell me more details about what you need help with!"
    end
    
    def generate_creative_response(input, context)
      responses = [
        "I love creative challenges! Let's brainstorm together...",
        "Creative thinking is one of my favorite activities! Here's what I'm thinking...",
        "Excellent! Let me put on my creative hat and explore this with you...",
        "I'm excited to help you create something amazing! Let's start...",
        "Creative projects are so much fun! Here are some ideas..."
      ]
      
      base_response = responses.sample
      base_response += "\n\n🎨 **Creative Approach:**\n"
      base_response += "• I'll help generate multiple creative options\n"
      base_response += "• We can explore different angles and perspectives\n"
      base_response += "• I'll provide both innovative and practical solutions\n"
      base_response += "• We can refine ideas together through conversation\n\n"
      base_response += "What's the creative vision you have in mind?"
    end
    
    def generate_conversational_response(input, context)
      if input.downcase.match?(/\b(hello|hi|hey)\b/)
        "Hey there! 👋 I'm NeoChat, your AI conversation partner. I'm here to chat, answer questions, help with problems, or just have a great conversation. What's on your mind today?"
      elsif input.downcase.match?(/\b(thanks|thank you)\b/)
        "You're very welcome! 😊 I'm always happy to help. Is there anything else you'd like to chat about or any other questions I can answer for you?"
      elsif input.downcase.match?(/\b(bye|goodbye)\b/)
        "Take care! 🌟 It was great chatting with you. Feel free to come back anytime you want to talk, ask questions, or need assistance with anything. Until next time!"
      else
        "I'm enjoying our conversation! 💬 I'm here to chat about whatever interests you - whether that's answering questions, solving problems, brainstorming ideas, or just having a friendly discussion. What would you like to explore?"
      end
    end
    
    def generate_problem_solving_response(input, context)
      responses = [
        "Let's solve this problem together! I'll approach it systematically...",
        "Problem-solving is one of my strengths! Let me analyze this...",
        "Great! I love tackling challenges. Here's my approach...",
        "Let's break this down and find the best solution...",
        "I'm ready to help you work through this step by step..."
      ]
      
      base_response = responses.sample
      base_response += "\n\n🔧 **Problem-Solving Process:**\n"
      base_response += "• First, I'll help clarify and define the problem\n"
      base_response += "• Then we'll explore potential solutions\n"
      base_response += "• I'll help you evaluate pros and cons\n"
      base_response += "• Finally, we'll create an action plan\n\n"
      base_response += "Can you give me more context about the specific challenge you're facing?"
    end
    
    def generate_default_response(input, context)
      "I'm NeoChat, your versatile AI assistant! 🌌 I can help you with:\n\n" +
      "💭 **Questions & Answers** - Ask me anything you're curious about\n" +
      "🛠 **Problem Solving** - Let's work through challenges together\n" +
      "💡 **Suggestions & Advice** - I'll provide helpful recommendations\n" +
      "🎨 **Creative Brainstorming** - Let's generate ideas and explore possibilities\n" +
      "📚 **Information & Learning** - I can explain concepts and provide insights\n\n" +
      "What would you like to chat about today?"
    end
    
    def determine_capabilities_used(input)
      capabilities = []
      input_lower = input.downcase
      
      capabilities << 'question_answering' if input_lower.match?(/\b(what|how|why|when|where)\b/)
      capabilities << 'problem_solving' if input_lower.match?(/\b(solve|fix|resolve)\b/)
      capabilities << 'creative_brainstorming' if input_lower.match?(/\b(create|brainstorm|imagine)\b/)
      capabilities << 'suggestions_and_advice' if input_lower.match?(/\b(suggest|recommend|advice)\b/)
      capabilities << 'general_conversation' # Always available
      
      capabilities.uniq
    end
    
    def build_context(user, input, context)
      base_context = super
      
      # Add NeoChat-specific context
      base_context.merge(
        agent_type: 'neochat',
        response_style: 'helpful_and_knowledgeable',
        conversation_mode: 'terminal_chat',
        capabilities: @primary_capabilities
      )
    end
  end
end
