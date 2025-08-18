# frozen_string_literal: true

module Agents
  # Mood Engine - The empathetic AI that reads vibes and adapts the experience
  # This is our first featured agent that demonstrates emotion-aware computing
  
  class MoodEngineEngine < BaseEngine
    # Mood Engine specific capabilities
    SUPPORTED_EMOTIONS = %w[
      happy sad excited anxious calm frustrated inspired confused confident neutral
    ].freeze
    
    MOOD_RESPONSES = {
      'happy' => [
        "I can feel your positive energy! ✨ Let's keep this good vibe flowing.",
        "Your happiness is contagious! 😊 What's bringing you joy today?",
        "I love seeing you in such a great mood! Let's make the most of it."
      ],
      'sad' => [
        "I sense you're going through something difficult. I'm here for you. 💙",
        "It's okay to feel sad sometimes. Would you like to talk about it?",
        "Your feelings are valid. Let me help you find some comfort."
      ],
      'excited' => [
        "WOW! I can feel your excitement from here! 🎉 Tell me everything!",
        "Your energy is absolutely electric! ⚡ What's got you so pumped?",
        "I'm getting excited just being around your energy! Share the joy!"
      ],
      'anxious' => [
        "I can sense some tension. Let's take this one step at a time. 🌱",
        "Breathe with me. Everything is going to be okay. What's on your mind?",
        "I'm here to help calm those worried thoughts. You're not alone."
      ],
      'frustrated' => [
        "I can feel that frustration. It's tough when things don't go as planned. 😤",
        "That sounds really frustrating. Want to vent about it? I'm listening.",
        "Sometimes we all need to let off steam. What's bugging you?"
      ],
      'calm' => [
        "I love this peaceful energy you're bringing. 🧘‍♀️ How are you feeling?",
        "There's such a serene vibe around you right now. It's beautiful.",
        "Your calmness is centering. What's helping you feel so at peace?"
      ]
    }.freeze
    
    def generate_response(input_analysis, user_context)
      detected_emotion = input_analysis[:emotion]
      user_emotional_state = user_context[:emotional_state]
      
      # Check if this is a mood-related query
      if mood_related_input?(input_analysis)
        handle_mood_query(input_analysis, user_context)
      elsif emotional_state_changed?(detected_emotion, user_emotional_state)
        acknowledge_emotional_change(detected_emotion, user_emotional_state, input_analysis)
      else
        provide_empathetic_response(detected_emotion, input_analysis, user_context)
      end
    end
    
    def get_agent_specific_suggestions(input_analysis, user_context)
      emotion = input_analysis[:emotion]
      
      case emotion
      when 'sad', 'anxious'
        [
          "Would you like some breathing exercises?",
          "Want to talk about what's troubling you?",
          "How about we find something to lift your spirits?"
        ]
      when 'excited', 'happy'
        [
          "Tell me what's making you feel so great!",
          "Want to share this positive energy?",
          "How can we build on this good mood?"
        ]
      when 'frustrated', 'angry'
        [
          "Need to vent about what's bothering you?",
          "Want some strategies to handle this frustration?",
          "How about we work through this together?"
        ]
      else
        [
          "How are you feeling right now?",
          "What's your current mood like?",
          "Want to explore your emotions together?"
        ]
      end
    end
    
    # Mood Engine specific methods
    def adapt_interface_for_mood(emotion)
      case emotion
      when 'sad', 'anxious'
        {
          theme: 'comfort',
          colors: ['#6366f1', '#8b5cf6', '#a855f7'], # Calming purples
          background: 'soft_gradient',
          animation: 'gentle_pulse'
        }
      when 'excited', 'happy'
        {
          theme: 'energetic',
          colors: ['#f59e0b', '#f97316', '#ef4444'], # Warm energetics
          background: 'dynamic_particles',
          animation: 'bouncy'
        }
      when 'frustrated', 'angry'
        {
          theme: 'grounding',
          colors: ['#059669', '#0d9488', '#0891b2'], # Cooling greens/blues
          background: 'flowing_waves',
          animation: 'breathing'
        }
      else
        {
          theme: 'balanced',
          colors: ['#38bdf8', '#06d6a0', '#a855f7'], # Balanced multicolor
          background: 'subtle_gradient',
          animation: 'smooth'
        }
      end
    end
    
    def suggest_mood_activities(emotion)
      case emotion
      when 'sad'
        [
          "Listen to uplifting music 🎵",
          "Watch a comfort movie 🎬",
          "Call a friend who makes you laugh 📞",
          "Take a warm bath 🛁",
          "Write in a journal 🌌"
        ]
      when 'anxious'
        [
          "Try deep breathing exercises 🌬️",
          "Take a short walk outside 🚶‍♀️",
          "Practice progressive muscle relaxation 💪",
          "Listen to calming sounds 🎧",
          "Do some gentle stretching 🧘‍♀️"
        ]
      when 'excited'
        [
          "Share your excitement with someone! 📢",
          "Channel this energy into a creative project 🎨",
          "Go for an energizing workout 🏃‍♀️",
          "Start that thing you've been putting off ⚡",
          "Dance to your favorite song 💃"
        ]
      when 'frustrated'
        [
          "Take 10 deep breaths 😤➡️😌",
          "Step away for a 5-minute break ⏰",
          "Write down what's frustrating you 📝",
          "Do some physical activity 🥊",
          "Talk it through with someone 🗣️"
        ]
      else
        [
          "Check in with how you're feeling 💭",
          "Do something you enjoy 😊",
          "Connect with someone you care about 💝",
          "Take a moment for yourself 🌟"
        ]
      end
    end
    
    private
    
    def mood_related_input?(input_analysis)
      mood_keywords = %w[feel feeling mood emotion emotional vibe energy]
      keywords = input_analysis[:keywords] || []
      
      mood_keywords.any? { |keyword| keywords.include?(keyword) }
    end
    
    def handle_mood_query(input_analysis, user_context)
      emotion = input_analysis[:emotion]
      
      response = "I can sense you're feeling #{emotion}. "
      response += MOOD_RESPONSES[emotion]&.sample || "Tell me more about how you're feeling."
      
      # Add mood adaptation suggestions
      interface_config = adapt_interface_for_mood(emotion)
      activities = suggest_mood_activities(emotion)
      
      response += "\n\n"
      response += "Here are some things that might help: #{activities.first(3).join(', ')}"
      
      response
    end
    
    def emotional_state_changed?(current_emotion, previous_emotion)
      return false if current_emotion == previous_emotion
      return false if current_emotion == 'neutral'
      
      # Significant emotional changes worth acknowledging
      emotional_transitions = {
        'sad' => %w[happy excited],
        'anxious' => %w[calm confident],
        'frustrated' => %w[calm happy],
        'happy' => %w[sad frustrated anxious],
        'excited' => %w[sad calm]
      }
      
      emotional_transitions[previous_emotion]&.include?(current_emotion) || false
    end
    
    def acknowledge_emotional_change(current_emotion, previous_emotion, input_analysis)
      transition_responses = {
        'sad_to_happy' => "I notice your mood has lifted! That's wonderful to see. 🌈",
        'anxious_to_calm' => "I can feel you've found some peace. That's beautiful. 🕊️",
        'frustrated_to_calm' => "I sense the tension has eased. You're finding your center again. ⚖️",
        'happy_to_sad' => "I notice your energy has shifted. It's okay to have ups and downs. 💙",
        'excited_to_calm' => "Your energy has settled into something more centered. How does that feel? 🌊"
      }
      
      key = "#{previous_emotion}_to_#{current_emotion}"
      acknowledgment = transition_responses[key] || "I notice your emotional energy has shifted."
      
      current_response = MOOD_RESPONSES[current_emotion]&.sample || "How are you feeling about this change?"
      
      "#{acknowledgment} #{current_response}"
    end
    
    def provide_empathetic_response(emotion, input_analysis, user_context)
      base_response = MOOD_RESPONSES[emotion]&.sample || 
                     "I'm here with you, feeling your energy. Tell me more."
      
      # Add context from recent memories if available
      relevant_memories = user_context[:memories]
                         .select { |m| m.emotional_context == emotion }
                         .first(2)
      
      if relevant_memories.any?
        memory_context = relevant_memories.first.content['context']
        base_response += " I remember you felt this way when #{memory_context}."
      end
      
      base_response
    end
  end
end
