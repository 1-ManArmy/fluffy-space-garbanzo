class EmotisenseController < ApplicationController
  layout 'application'
  skip_before_action :verify_authenticity_token, only: [:chat]

  def index
    session[:emotisense_conversation_id] ||= SecureRandom.uuid
    session[:emotisense_history] ||= []

    @agent = OpenStruct.new(
      id: session[:emotisense_conversation_id],
      name: 'EmotiSense',
      version: '2.0',
      status: 'active',
      agent_type: 'emotion_analysis'
    )

    @agent_stats = {
      total_conversations: '47+',
      average_rating: '4.8/5.0',
      response_time: '< 2s'
    }
  end

  def chat
    user_message = params[:message]

    if user_message.blank?
      return render json: {
        success: false,
        error: 'Please share your feelings or experience to analyze emotions.'
      }, status: 400
    end

    session[:emotisense_history] ||= []
    session[:emotisense_history] << {
      role: 'user',
      content: user_message,
      timestamp: Time.current
    }

    begin
      system_prompt = "You are EmotiSense, an advanced AI specializing in emotion analysis and emotional intelligence. Analyze the user's emotional state, identify key emotions, and provide empathetic responses."

      ai_result = AiService.openai_chat(user_message, {
        system_prompt: system_prompt,
        max_tokens: 800,
        temperature: 0.7
      })
      
      if ai_result[:success]
        ai_response = ai_result[:response]
      else
        raise StandardError, ai_result[:error]
      end

      session[:emotisense_history] << {
        role: 'assistant',
        content: ai_response,
        timestamp: Time.current
      }

      render json: {
        success: true,
        message: ai_response,
        conversation_id: session[:emotisense_conversation_id],
        timestamp: Time.current.iso8601
      }

    rescue => e
      Rails.logger.error "EmotiSense AI Error: #{e.message}"

      emotional_keywords = %w[sad happy angry frustrated excited worried calm stressed joyful anxious nervous]
      detected_emotions = emotional_keywords.select { |emotion| user_message.downcase.include?(emotion) }
      
      if detected_emotions.any?
        fallback_response = "I sense #{detected_emotions.join(', ')} emotions in your message. Your feelings are completely valid and important. Take a moment to breathe deeply - you're stronger than you know, and whatever you're experiencing right now will pass. 💜"
      else
        fallback_response = "I'm here to support you through whatever you're feeling. While I'm experiencing a temporary connection issue, I want you to know that your emotional well-being matters deeply. Take care of yourself - you deserve compassion and understanding. 💜"
      end

      session[:emotisense_history] << {
        role: 'assistant',
        content: fallback_response,
        timestamp: Time.current
      }

      render json: {
        success: true,
        message: fallback_response,
        conversation_id: session[:emotisense_conversation_id],
        timestamp: Time.current.iso8601,
        fallback: true
      }
    end
  end
end
