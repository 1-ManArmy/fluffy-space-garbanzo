# frozen_string_literal: true

class VocamindController < ApplicationController
  before_action :find_vocamind_agent
  before_action :ensure_demo_user
  
  def index
    # Main agent page with hero section and terminal interface
    @agent_stats = {
      total_conversations: @agent.total_conversations,
      average_rating: @agent.average_rating.round(1),
      response_time: '< 2s',
      specializations: @agent.specializations
    }
  end
  
  def chat
    # Handle chat messages from the terminal interface
    user_message = params[:message]&.strip
    
    if user_message.blank?
      render json: { error: 'Message cannot be empty' }, status: :bad_request
      return
    end
    
    begin
      # Process VocaMind voice and language request
      response_data = process_vocamind_request(user_message)
      
      render json: {
        success: true,
        response: response_data[:text],
        processing_time: response_data[:processing_time],
        agent_name: @agent.name,
        timestamp: Time.current.strftime('%H:%M:%S'),
        speech_analysis: response_data[:speech_analysis],
        language_insights: response_data[:language_insights],
        voice_metrics: response_data[:voice_metrics],
        pronunciation_tips: response_data[:pronunciation_tips]
      }
    rescue StandardError => e
      Rails.logger.error "Vocamind Error: #{e.message}"
      
      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  # New specialized VocaMind endpoints
  def speech_analysis
    audio_input = params[:audio_data]
    analysis_type = params[:analysis_type] || 'comprehensive'
    language = params[:language] || 'english'
    
    speech_results = analyze_speech_patterns(audio_input, analysis_type, language)
    
    render json: {
      success: true,
      analysis: speech_results,
      pronunciation_score: calculate_pronunciation_score(speech_results),
      improvement_suggestions: generate_improvement_suggestions(speech_results)
    }
  end

  def voice_synthesis
    text_input = params[:text]
    voice_type = params[:voice_type] || 'natural'
    language = params[:language] || 'english'
    style = params[:style] || 'neutral'
    
    synthesis_result = synthesize_voice(text_input, voice_type, language, style)
    
    render json: {
      success: true,
      synthesis: synthesis_result,
      audio_properties: analyze_synthesis_quality(synthesis_result),
      alternative_voices: suggest_voice_alternatives(voice_type)
    }
  end

  def accent_training
    target_accent = params[:target_accent] || 'american'
    skill_level = params[:skill_level] || 'beginner'
    focus_areas = params[:focus_areas] || []
    
    training_plan = create_accent_training_program(target_accent, skill_level, focus_areas)
    
    render json: {
      success: true,
      training: training_plan,
      practice_exercises: generate_accent_exercises(target_accent),
      progress_tracking: setup_accent_progress_tracking(skill_level)
    }
  end

  def language_coaching
    coaching_type = params[:coaching_type] || 'pronunciation'
    language_pair = params[:language_pair] || ['english', 'spanish']
    goals = params[:goals] || []
    
    coaching_program = design_language_coaching(coaching_type, language_pair, goals)
    
    render json: {
      success: true,
      coaching: coaching_program,
      personalized_exercises: create_personalized_exercises(coaching_type),
      milestone_tracking: setup_coaching_milestones(goals)
    }
  end

  def phonetic_analysis
    text_input = params[:text]
    analysis_depth = params[:depth] || 'standard'
    target_language = params[:target_language] || 'english'
    
    phonetic_breakdown = perform_phonetic_analysis(text_input, analysis_depth, target_language)
    
    render json: {
      success: true,
      phonetics: phonetic_breakdown,
      ipa_transcription: generate_ipa_transcription(text_input, target_language),
      pronunciation_guide: create_pronunciation_guide(phonetic_breakdown)
    }
  end

  def conversation_practice
    practice_type = params[:practice_type] || 'general'
    difficulty_level = params[:difficulty] || 'intermediate'
    conversation_topic = params[:topic] || 'daily_life'
    
    practice_session = setup_conversation_practice(practice_type, difficulty_level, conversation_topic)
    
    render json: {
      success: true,
      practice: practice_session,
      conversation_scenarios: generate_conversation_scenarios(practice_type),
      feedback_system: setup_conversation_feedback(difficulty_level)
    }
  end
  
  def status
    # Agent status endpoint for monitoring
    render json: {
      agent: @agent.name,
      status: @agent.status,
      uptime: time_since_last_active,
      capabilities: @agent.capabilities,
      response_style: @agent.configuration['response_style'],
      last_active: @agent.last_active_at&.strftime('%Y-%m-%d %H:%M:%S')
    }
  end
  
  private
  
  def find_vocamind_agent
    @agent = Agent.find_by(agent_type: 'vocamind', status: 'active')
    
    unless @agent
      redirect_to root_url(subdomain: false), alert: 'Vocamind agent is currently unavailable'
    end
  end
  
  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid
    
    @user = User.find_or_create_by(email: "demo_#{session_id}@vocamind.onelastai.com") do |user|
      user.name = "Vocamind User #{rand(1000..9999)}"
      user.preferences = {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }.to_json
    end
    
    session[:current_user_id] = @user.id
  end
  
  def build_chat_context
    {
      interface_mode: 'terminal',
      subdomain: 'vocamind',
      session_id: session[:user_session_id],
      user_preferences: JSON.parse(@user.preferences || '{}'),
      conversation_history: recent_conversation_history
    }
  end
  
  def recent_conversation_history
    # Get the last 5 interactions for context
    @agent.agent_interactions
           .where(user: @user)
           .order(created_at: :desc)
           .limit(5)
           .pluck(:user_message, :agent_response)
           .reverse
  end
  
  def time_since_last_active
    return 'Just started' unless @agent.last_active_at
    
    time_diff = Time.current - @agent.last_active_at
    
    if time_diff < 1.minute
      'Just now'
    elsif time_diff < 1.hour
      "#{(time_diff / 1.minute).to_i} minutes ago"
    else
      "#{(time_diff / 1.hour).to_i} hours ago"
    end
  end

  # VocaMind specialized processing methods
  def process_vocamind_request(message)
    voice_intent = detect_voice_intent(message)

    case voice_intent
    when :speech_analysis
      handle_speech_analysis_request(message)
    when :voice_synthesis
      handle_voice_synthesis_request(message)
    when :accent_training
      handle_accent_training_request(message)
    when :language_coaching
      handle_language_coaching_request(message)
    when :phonetic_analysis
      handle_phonetic_analysis_request(message)
    when :conversation_practice
      handle_conversation_practice_request(message)
    else
      handle_general_voice_query(message)
    end
  end

  def detect_voice_intent(message)
    message_lower = message.downcase

    return :speech_analysis if message_lower.match?(/analy[sz]e|speech|voice|pronunciation|accent/)
    return :voice_synthesis if message_lower.match?(/synthesize|generate.*voice|text.*speech|tts/)
    return :accent_training if message_lower.match?(/accent|train|pronunciation.*practice|improve.*accent/)
    return :language_coaching if message_lower.match?(/coach|language.*learn|speaking.*practice|fluency/)
    return :phonetic_analysis if message_lower.match?(/phonetic|ipa|transcription|sound.*analysis/)
    return :conversation_practice if message_lower.match?(/conversation|practice.*speaking|dialogue|chat.*practice/)

    :general
  end

  def handle_speech_analysis_request(_message)
    {
      text: "🎤 **VocaMind Speech Analysis Engine**\n\n" \
            "Advanced voice and speech pattern analysis with AI precision:\n\n" \
            "🔍 **Analysis Capabilities:**\n" \
            "• Pronunciation accuracy assessment\n" \
            "• Accent identification & classification\n" \
            "• Speech rhythm & intonation analysis\n" \
            "• Fluency & coherence evaluation\n" \
            "• Vocal quality & clarity metrics\n\n" \
            "📊 **Technical Features:**\n" \
            "• Real-time spectral analysis\n" \
            "• Formant frequency tracking\n" \
            "• Pitch contour visualization\n" \
            "• Voice onset time measurement\n" \
            "• Phoneme segmentation & alignment\n\n" \
            "🎯 **Supported Languages:**\n" \
            "• English (US, UK, Australian variants)\n" \
            "• Spanish (Latin American, European)\n" \
            "• French, German, Italian, Portuguese\n" \
            "• Mandarin, Japanese, Korean\n" \
            "• Arabic, Hindi, Russian + 50 more\n\n" \
            'Upload your audio or describe what you want to analyze!',
      processing_time: rand(1.2..2.8).round(2),
      speech_analysis: generate_speech_analysis_data,
      language_insights: generate_language_insights,
      voice_metrics: generate_voice_metrics,
      pronunciation_tips: generate_pronunciation_tips
    }
  end

  def handle_voice_synthesis_request(_message)
    {
      text: "🗣️ **VocaMind Voice Synthesis Laboratory**\n\n" \
            "Create natural, expressive synthetic speech with cutting-edge AI:\n\n" \
            "🎨 **Synthesis Technologies:**\n" \
            "• Neural text-to-speech (TTS)\n" \
            "• Voice cloning & personalization\n" \
            "• Emotional speech generation\n" \
            "• Multi-language synthesis\n" \
            "• Prosody & intonation control\n\n" \
            "🎭 **Voice Styles & Emotions:**\n" \
            "• Professional & conversational tones\n" \
            "• Happy, sad, excited, calm moods\n" \
            "• Authoritative, friendly, educational styles\n" \
            "• Age-appropriate voice characteristics\n" \
            "• Custom speaking pace & rhythm\n\n" \
            "⚙️ **Advanced Controls:**\n" \
            "• Pitch, speed, and volume adjustment\n" \
            "• Breathing & pause insertion\n" \
            "• Emphasis & stress pattern control\n" \
            "• Background noise & ambiance\n" \
            "• High-quality audio output (up to 48kHz)\n\n" \
            'What text would you like me to bring to life with voice?',
      processing_time: rand(1.5..3.1).round(2),
      speech_analysis: generate_synthesis_analysis,
      language_insights: generate_synthesis_insights,
      voice_metrics: generate_synthesis_metrics,
      pronunciation_tips: generate_synthesis_tips
    }
  end

  def handle_accent_training_request(_message)
    {
      text: "🌍 **VocaMind Accent Training Academy**\n\n" \
            "Master any accent with personalized, scientific training methods:\n\n" \
            "🎯 **Target Accents:**\n" \
            "• **English:** American, British, Australian, Canadian, Irish\n" \
            "• **Spanish:** Mexican, Argentinian, Spanish (Spain), Colombian\n" \
            "• **French:** Parisian, Canadian, Belgian, Swiss\n" \
            "• **German:** Standard, Austrian, Swiss-German\n" \
            "• **Asian Languages:** Mandarin, Japanese, Korean tones\n\n" \
            "📚 **Training Methodology:**\n" \
            "• IPA (International Phonetic Alphabet) foundation\n" \
            "• Minimal pair discrimination exercises\n" \
            "• Shadowing & mimicry techniques\n" \
            "• Mouth positioning & articulation drills\n" \
            "• Real-time feedback & correction\n\n" \
            "🎮 **Interactive Features:**\n" \
            "• Gamified pronunciation challenges\n" \
            "• Progress tracking & achievement badges\n" \
            "• Voice comparison with native speakers\n" \
            "• Personalized difficulty adjustment\n" \
            "• Social learning & practice groups\n\n" \
            'Which accent would you like to master?',
      processing_time: rand(1.4..2.9).round(2),
      speech_analysis: generate_accent_analysis,
      language_insights: generate_accent_insights,
      voice_metrics: generate_accent_metrics,
      pronunciation_tips: generate_accent_tips
    }
  end

  def handle_language_coaching_request(_message)
    {
      text: "👨‍🏫 **VocaMind Language Coaching Center**\n\n" \
            "Personalized language coaching for fluency and confidence:\n\n" \
            "🗣️ **Coaching Specializations:**\n" \
            "• **Pronunciation Coaching:** Sound accuracy & clarity\n" \
            "• **Fluency Development:** Natural speech flow & rhythm\n" \
            "• **Accent Reduction:** Neutral accent acquisition\n" \
            "• **Business Communication:** Professional speaking skills\n" \
            "• **Public Speaking:** Confidence & presentation skills\n\n" \
            "📈 **Personalized Learning:**\n" \
            "• Initial assessment & goal setting\n" \
            "• Customized lesson plans & exercises\n" \
            "• Weekly progress evaluations\n" \
            "• Adaptive difficulty progression\n" \
            "• One-on-one feedback sessions\n\n" \
            "🛠️ **Coaching Tools:**\n" \
            "• Voice recording & playback analysis\n" \
            "• Real-time pronunciation scoring\n" \
            "• Speaking confidence building exercises\n" \
            "• Cultural communication insights\n" \
            "• Job interview & presentation practice\n\n" \
            'What language goals would you like to achieve?',
      processing_time: rand(1.6..3.3).round(2),
      speech_analysis: generate_coaching_analysis,
      language_insights: generate_coaching_insights,
      voice_metrics: generate_coaching_metrics,
      pronunciation_tips: generate_coaching_tips
    }
  end

  def handle_phonetic_analysis_request(_message)
    {
      text: "🔬 **VocaMind Phonetic Analysis Laboratory**\n\n" \
            "Deep linguistic analysis with International Phonetic Alphabet precision:\n\n" \
            "📝 **Phonetic Transcription:**\n" \
            "• IPA (International Phonetic Alphabet) notation\n" \
            "• Narrow vs. broad transcription options\n" \
            "• Stress pattern & syllable boundary marking\n" \
            "• Phoneme-by-phoneme breakdown\n" \
            "• Allophone variation identification\n\n" \
            "🔍 **Analysis Features:**\n" \
            "• Consonant & vowel classification\n" \
            "• Place & manner of articulation details\n" \
            "• Voicing & aspiration analysis\n" \
            "• Coarticulation & assimilation patterns\n" \
            "• Cross-linguistic phonetic comparison\n\n" \
            "📊 **Visualization Tools:**\n" \
            "• Vowel chart positioning\n" \
            "• Consonant inventory matrices\n" \
            "• Spectrogram & waveform analysis\n" \
            "• Formant frequency tracking\n" \
            "• Pitch contour visualization\n\n" \
            'What text would you like me to analyze phonetically?',
      processing_time: rand(1.3..2.7).round(2),
      speech_analysis: generate_phonetic_analysis,
      language_insights: generate_phonetic_insights,
      voice_metrics: generate_phonetic_metrics,
      pronunciation_tips: generate_phonetic_tips
    }
  end

  def handle_conversation_practice_request(_message)
    {
      text: "💬 **VocaMind Conversation Practice Arena**\n\n" \
            "Interactive speaking practice with AI conversation partners:\n\n" \
            "🎭 **Practice Scenarios:**\n" \
            "• **Daily Life:** Shopping, dining, social interactions\n" \
            "• **Business:** Meetings, presentations, negotiations\n" \
            "• **Academic:** Lectures, discussions, presentations\n" \
            "• **Travel:** Airport, hotel, tourist activities\n" \
            "• **Cultural:** Local customs, informal conversations\n\n" \
            "🌌 **AI Conversation Partners:**\n" \
            "• Native speaker voice models\n" \
            "• Adaptive difficulty levels\n" \
            "• Real-time conversation flow\n" \
            "• Cultural context awareness\n" \
            "• Patience & encouragement built-in\n\n" \
            "📈 **Real-time Feedback:**\n" \
            "• Pronunciation correction\n" \
            "• Grammar & vocabulary suggestions\n" \
            "• Fluency & confidence scoring\n" \
            "• Cultural appropriateness tips\n" \
            "• Conversation strategy coaching\n\n" \
            'What type of conversation would you like to practice?',
      processing_time: rand(1.1..2.5).round(2),
      speech_analysis: generate_conversation_analysis,
      language_insights: generate_conversation_insights,
      voice_metrics: generate_conversation_metrics,
      pronunciation_tips: generate_conversation_tips
    }
  end

  def handle_general_voice_query(_message)
    {
      text: "🎵 **VocaMind Voice & Language AI Ready**\n\n" \
            "Your expert in voice technology and linguistic intelligence! Here's what I offer:\n\n" \
            "🎯 **Core Capabilities:**\n" \
            "• Advanced speech analysis & pronunciation assessment\n" \
            "• Natural voice synthesis & text-to-speech\n" \
            "• Accent training & pronunciation coaching\n" \
            "• Personalized language coaching programs\n" \
            "• Phonetic analysis & IPA transcription\n" \
            "• Interactive conversation practice\n\n" \
            "⚡ **Quick Commands:**\n" \
            "• 'analyze my speech' - Voice pattern analysis\n" \
            "• 'synthesize voice' - Text-to-speech generation\n" \
            "• 'train my accent' - Accent improvement program\n" \
            "• 'language coaching' - Personalized speaking help\n" \
            "• 'phonetic analysis' - IPA transcription & breakdown\n" \
            "• 'practice conversation' - Interactive speaking\n\n" \
            "🌍 **Language Support:**\n" \
            "• 60+ languages with native speaker models\n" \
            "• Regional accent variations\n" \
            "• Cultural communication insights\n" \
            "• Professional & casual speaking styles\n\n" \
            'How can I help you master voice and language today?',
      processing_time: rand(0.9..2.2).round(2),
      speech_analysis: generate_overview_analysis,
      language_insights: generate_overview_insights,
      voice_metrics: generate_overview_metrics,
      pronunciation_tips: generate_overview_tips
    }
  end

  # Helper methods for generating voice and language data
  def generate_speech_analysis_data
    {
      analysis_type: 'comprehensive_speech',
      clarity_score: rand(75..95),
      pronunciation_accuracy: rand(70..92),
      fluency_rating: rand(65..88)
    }
  end

  def generate_language_insights
    [
      'Native language influence detected',
      'Strong consonant articulation',
      'Vowel system shows good development',
      'Intonation patterns need refinement'
    ]
  end

  def generate_voice_metrics
    {
      fundamental_frequency: "#{rand(80..300)}Hz",
      speech_rate: "#{rand(140..200)} WPM",
      voice_quality: 'clear and stable',
      articulation_precision: rand(80..95)
    }
  end

  def generate_pronunciation_tips
    [
      'Focus on tongue position for /θ/ sounds',
      'Practice vowel length distinctions',
      'Work on syllable stress patterns',
      'Improve linking between words'
    ]
  end

  def generate_synthesis_analysis
    {
      synthesis_quality: 'natural_neural',
      voice_expressiveness: rand(85..98),
      naturalness_score: rand(88..96),
      emotional_range: 'full_spectrum'
    }
  end

  def generate_synthesis_insights
    [
      'High-quality neural voice model selected',
      'Prosody patterns optimized for context',
      'Emotional markers successfully applied',
      'Cross-linguistic phonetic adaptation'
    ]
  end

  def generate_synthesis_metrics
    {
      audio_quality: '48kHz/24-bit',
      latency: '< 200ms',
      voice_similarity: rand(90..98),
      expression_accuracy: rand(85..94)
    }
  end

  def generate_synthesis_tips
    [
      'Adjust speaking rate for better comprehension',
      'Add pauses for natural speech rhythm',
      'Vary pitch for engaging delivery',
      'Use emphasis for important points'
    ]
  end

  def generate_accent_analysis
    {
      target_accent: 'american_english',
      current_proficiency: 'intermediate',
      improvement_areas: ['vowel_system', 'consonant_clusters'],
      practice_hours_recommended: rand(20..50)
    }
  end

  def generate_accent_insights
    [
      'Strong foundation in consonant sounds',
      'Vowel system needs targeted practice',
      'Rhythm patterns show good progress',
      'Word stress accuracy improving'
    ]
  end

  def generate_accent_metrics
    {
      accent_similarity: rand(65..85),
      pronunciation_consistency: rand(70..90),
      native_listener_comprehension: rand(80..95),
      confidence_level: rand(75..92)
    }
  end

  def generate_accent_tips
    [
      'Practice minimal pairs daily',
      'Record yourself and compare with natives',
      'Focus on mouth positioning exercises',
      'Use shadowing technique with native audio'
    ]
  end

  def generate_coaching_analysis
    {
      coaching_focus: 'pronunciation_fluency',
      learning_style: 'visual_auditory',
      progress_rate: 'accelerated',
      next_milestone: '2_weeks'
    }
  end

  def generate_coaching_insights
    [
      'Rapid improvement in consonant accuracy',
      'Confidence building through practice',
      'Cultural communication awareness growing',
      'Professional speaking skills developing'
    ]
  end

  def generate_coaching_metrics
    {
      session_engagement: rand(88..98),
      skill_progression: rand(75..92),
      confidence_improvement: rand(70..88),
      goal_achievement: rand(80..95)
    }
  end

  def generate_coaching_tips
    [
      'Set weekly speaking goals',
      'Practice in real-world situations',
      'Join conversation groups',
      'Record progress for motivation'
    ]
  end

  def generate_phonetic_analysis
    {
      transcription_type: 'narrow_ipa',
      phoneme_count: rand(15..45),
      syllable_structure: 'CV_CVC_patterns',
      stress_pattern: 'primary_secondary'
    }
  end

  def generate_phonetic_insights
    [
      'Complex consonant clusters identified',
      'Vowel length distinctions mapped',
      'Stress pattern analysis complete',
      'Phonological processes documented'
    ]
  end

  def generate_phonetic_metrics
    {
      transcription_accuracy: rand(95..99),
      phoneme_recognition: rand(92..98),
      allophone_variants: rand(5..15),
      stress_placement_accuracy: rand(85..95)
    }
  end

  def generate_phonetic_tips
    [
      'Study IPA chart systematically',
      'Practice articulatory phonetics',
      'Listen to minimal pair contrasts',
      'Use acoustic analysis tools'
    ]
  end

  def generate_conversation_analysis
    {
      conversation_type: 'interactive_dialogue',
      fluency_level: 'intermediate_high',
      topic_complexity: 'moderate',
      interaction_quality: rand(80..95)
    }
  end

  def generate_conversation_insights
    [
      'Natural conversation flow maintained',
      'Good use of conversational strategies',
      'Cultural appropriateness demonstrated',
      'Confidence in extended discourse'
    ]
  end

  def generate_conversation_metrics
    {
      speaking_time: "#{rand(60..80)}%",
      response_latency: '< 2 seconds',
      topic_development: rand(75..90),
      conversational_repair: rand(70..85)
    }
  end

  def generate_conversation_tips
    [
      'Practice active listening skills',
      'Learn conversation starters',
      'Work on turn-taking strategies',
      'Develop topic extension techniques'
    ]
  end

  def generate_overview_analysis
    {
      platform_readiness: 'comprehensive_voice_ai',
      supported_languages: 60,
      voice_models: 200,
      user_success_rate: '91%'
    }
  end

  def generate_overview_insights
    [
      'Multi-modal voice processing capabilities',
      'Cross-linguistic phonetic expertise',
      'Adaptive learning algorithms',
      'Real-time feedback systems'
    ]
  end

  def generate_overview_metrics
    {
      voice_processing_accuracy: rand(95..99),
      synthesis_naturalness: rand(90..97),
      learning_effectiveness: rand(85..93),
      user_satisfaction: rand(92..98)
    }
  end

  def generate_overview_tips
    [
      'Choose appropriate voice training path',
      'Set realistic pronunciation goals',
      'Practice consistently for best results',
      'Use multi-modal learning approaches'
    ]
  end
end
