# frozen_string_literal: true

require 'ostruct'

class PersonaxController < ApplicationController
  before_action :initialize_agent_data
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
      # Process PersonaX personality analysis request
      response_data = process_personax_request(user_message)

      render json: {
        success: true,
        response: response_data[:text],
        processing_time: response_data[:processing_time],
        agent_name: @agent.name,
        timestamp: Time.current.strftime('%H:%M:%S'),
        personality_insights: response_data[:personality_insights],
        behavioral_patterns: response_data[:behavioral_patterns],
        communication_style: response_data[:communication_style],
        recommendations: response_data[:recommendations]
      }
    rescue StandardError => e
      Rails.logger.error "Personax Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  # New specialized PersonaX endpoints
  def personality_analysis
    text_input = params[:text]
    analysis_type = params[:analysis_type] || 'comprehensive'

    analysis_results = analyze_personality_traits(text_input, analysis_type)

    render json: {
      success: true,
      analysis: analysis_results,
      big_five_scores: calculate_big_five(text_input),
      communication_patterns: identify_communication_style(text_input)
    }
  end

  def mbti_assessment
    responses = params[:responses] || []
    assessment_mode = params[:mode] || 'standard'

    mbti_results = conduct_mbti_analysis(responses, assessment_mode)

    render json: {
      success: true,
      mbti_type: mbti_results,
      type_description: get_mbti_description(mbti_results),
      career_suggestions: suggest_careers(mbti_results),
      compatibility: analyze_compatibility(mbti_results)
    }
  end

  def behavioral_insights
    interaction_data = params[:interactions] || []
    time_range = params[:time_range] || '30days'

    behavioral_analysis = analyze_behavioral_patterns(interaction_data, time_range)

    render json: {
      success: true,
      patterns: behavioral_analysis,
      growth_areas: identify_growth_opportunities(behavioral_analysis),
      strengths: highlight_personality_strengths(behavioral_analysis)
    }
  end

  def relationship_compatibility
    person_a_traits = params[:person_a] || {}
    person_b_traits = params[:person_b] || {}
    relationship_type = params[:relationship_type] || 'general'

    compatibility_results = assess_compatibility(person_a_traits, person_b_traits, relationship_type)

    render json: {
      success: true,
      compatibility: compatibility_results,
      communication_tips: generate_communication_advice(compatibility_results),
      potential_challenges: identify_relationship_challenges(compatibility_results)
    }
  end

  def personal_development
    current_traits = params[:traits] || {}
    goals = params[:goals] || []

    development_plan = create_development_roadmap(current_traits, goals)

    render json: {
      success: true,
      development_plan:,
      action_steps: generate_action_steps(development_plan),
      progress_tracking: setup_personality_tracking(goals)
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

  def initialize_agent_data
    @agent = OpenStruct.new(
      name: 'PersonaX',
      agent_type: 'personax',
      status: 'active',
      total_conversations: rand(2200..4100),
      average_rating: rand(4.4..4.9),
      specializations: ['Personality Analysis', 'MBTI Assessment', 'Behavioral Insights', 'Relationship Compatibility',
                        'Personal Development'],
      capabilities: ['Psychological Profiling', 'Personality Assessment', 'Behavioral Analysis',
                     'Compatibility Testing', 'Development Coaching', 'Pattern Recognition'],
      configuration: { 'response_style' => 'personality_focused_insightful' },
      last_active_at: Time.current,
      update!: ->(attrs) { attrs.each { |k, v| @agent.send("#{k}=", v) } },
      agent_interactions: OpenStruct.new(
        where: lambda { |conditions|
          OpenStruct.new(
            order: lambda { |sort|
              OpenStruct.new(
                limit: lambda { |num|
                  OpenStruct.new(
                    pluck: ->(*fields) { [] }
                  )
                }
              )
            }
          )
        }
      )
    )
  end

  def find_personax_agent
    # Legacy method - now handled by initialize_agent_data
    @agent
  end

  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid

    @user = OpenStruct.new(
      id: session_id,
      email: "demo_#{session_id}@personax.onelastai.com",
      name: "Personax User #{rand(1000..9999)}",
      preferences: {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }.to_json
    )

    session[:current_user_id] = @user.id
  end

  def build_chat_context
    {
      interface_mode: 'terminal',
      subdomain: 'personax',
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

  # PersonaX specialized processing methods
  def process_personax_request(message)
    personality_intent = detect_personality_intent(message)

    case personality_intent
    when :analyze
      handle_personality_analysis_request(message)
    when :mbti
      handle_mbti_request(message)
    when :compatibility
      handle_compatibility_request(message)
    when :development
      handle_development_request(message)
    when :behavioral
      handle_behavioral_request(message)
    else
      handle_general_personality_query(message)
    end
  end

  def detect_personality_intent(message)
    message_lower = message.downcase

    return :analyze if message_lower.match?(/analy[sz]e|personality|traits|character/)
    return :mbti if message_lower.match?(/mbti|myers.?briggs|personality type|introvert|extrovert/)
    return :compatibility if message_lower.match?(/compatibility|relationship|match|partner/)
    return :development if message_lower.match?(/develop|improve|grow|change|better/)
    return :behavioral if message_lower.match?(/behavior|pattern|habit|tendency/)

    :general
  end

  def handle_personality_analysis_request(_message)
    {
      text: "🌌 **PersonaX Personality Analysis Engine**\n\n" \
            "Advanced psychological profiling and personality insights:\n\n" \
            "🎯 **Analysis Framework:**\n" \
            "• Big Five personality traits (OCEAN)\n" \
            "• Myers-Briggs Type Indicator (MBTI)\n" \
            "• Emotional intelligence assessment\n" \
            "• Communication style analysis\n" \
            "• Behavioral pattern recognition\n\n" \
            "📊 **Assessment Methods:**\n" \
            "• Text analysis & linguistic patterns\n" \
            "• Behavioral observation metrics\n" \
            "• Psychometric questionnaires\n" \
            "• Interaction style evaluation\n" \
            "• Decision-making preference mapping\n\n" \
            "🎨 **Personality Dimensions:**\n" \
            "• Openness to experience\n" \
            "• Conscientiousness & organization\n" \
            "• Extraversion & social energy\n" \
            "• Agreeableness & cooperation\n" \
            "• Neuroticism & emotional stability\n\n" \
            'Share some text or describe yourself for comprehensive personality analysis!',
      processing_time: rand(1.8..3.5).round(2),
      personality_insights: generate_sample_personality_insights,
      behavioral_patterns: generate_behavioral_patterns,
      communication_style: 'analytical_detailed',
      recommendations: generate_personality_recommendations
    }
  end

  def handle_mbti_request(_message)
    {
      text: "🎭 **PersonaX MBTI Assessment Center**\n\n" \
            "Discover your Myers-Briggs personality type:\n\n" \
            "🔤 **16 Personality Types:**\n" \
            "• **Analysts:** NT types (Architect, Logician, Commander, Debater)\n" \
            "• **Diplomats:** NF types (Advocate, Mediator, Protagonist, Campaigner)\n" \
            "• **Sentinels:** SJ types (Logistician, Defender, Executive, Consul)\n" \
            "• **Explorers:** SP types (Virtuoso, Adventurer, Entrepreneur, Entertainer)\n\n" \
            "⚖️ **Four Key Dimensions:**\n" \
            "• **E/I:** Extraversion vs Introversion\n" \
            "• **S/N:** Sensing vs Intuition\n" \
            "• **T/F:** Thinking vs Feeling\n" \
            "• **J/P:** Judging vs Perceiving\n\n" \
            "🎯 **Assessment Features:**\n" \
            "• Comprehensive questionnaire\n" \
            "• Detailed type description\n" \
            "• Career compatibility analysis\n" \
            "• Relationship insights\n" \
            "• Personal development tips\n\n" \
            'Ready to discover your MBTI type?',
      processing_time: rand(1.5..2.9).round(2),
      personality_insights: generate_mbti_insights,
      behavioral_patterns: generate_mbti_patterns,
      communication_style: 'type_focused',
      recommendations: generate_mbti_recommendations
    }
  end

  def handle_compatibility_request(_message)
    {
      text: "💕 **PersonaX Compatibility Analysis System**\n\n" \
            "Understanding relationship dynamics through personality science:\n\n" \
            "🔄 **Compatibility Factors:**\n" \
            "• Personality trait alignment\n" \
            "• Communication style matching\n" \
            "• Values & life goals compatibility\n" \
            "• Conflict resolution approaches\n" \
            "• Emotional support patterns\n\n" \
            "💡 **Relationship Types:**\n" \
            "• Romantic partnerships\n" \
            "• Friendship dynamics\n" \
            "• Professional collaborations\n" \
            "• Family relationships\n" \
            "• Team compatibility\n\n" \
            "📈 **Analysis Output:**\n" \
            "• Compatibility percentage\n" \
            "• Strength areas identification\n" \
            "• Potential challenge areas\n" \
            "• Communication improvement tips\n" \
            "• Relationship growth strategies\n\n" \
            "Describe the personalities you'd like me to analyze for compatibility!",
      processing_time: rand(1.7..3.1).round(2),
      personality_insights: generate_compatibility_insights,
      behavioral_patterns: generate_compatibility_patterns,
      communication_style: 'relationship_focused',
      recommendations: generate_compatibility_recommendations
    }
  end

  def handle_development_request(_message)
    {
      text: "🌱 **PersonaX Personal Development Lab**\n\n" \
            "Transform your personality for personal growth and success:\n\n" \
            "🎯 **Development Areas:**\n" \
            "• Emotional intelligence enhancement\n" \
            "• Communication skill building\n" \
            "• Leadership capability development\n" \
            "• Confidence & self-esteem boosting\n" \
            "• Stress management & resilience\n\n" \
            "📋 **Development Process:**\n" \
            "• Current personality assessment\n" \
            "• Goal setting & target identification\n" \
            "• Customized action plan creation\n" \
            "• Progress tracking & monitoring\n" \
            "• Continuous feedback & adjustment\n\n" \
            "🛠️ **Growth Tools:**\n" \
            "• Personality exercises & challenges\n" \
            "• Mindfulness & self-reflection practices\n" \
            "• Behavioral modification techniques\n" \
            "• Social skill enhancement activities\n" \
            "• Performance coaching strategies\n\n" \
            'What aspects of your personality would you like to develop?',
      processing_time: rand(1.9..3.7).round(2),
      personality_insights: generate_development_insights,
      behavioral_patterns: generate_development_patterns,
      communication_style: 'growth_oriented',
      recommendations: generate_development_recommendations
    }
  end

  def handle_behavioral_request(_message)
    {
      text: "📊 **PersonaX Behavioral Pattern Analyzer**\n\n" \
            "Deep insights into your behavioral tendencies and habits:\n\n" \
            "🔍 **Pattern Recognition:**\n" \
            "• Communication frequency & timing\n" \
            "• Decision-making processes\n" \
            "• Stress response patterns\n" \
            "• Social interaction preferences\n" \
            "• Work & productivity habits\n\n" \
            "📈 **Behavioral Analytics:**\n" \
            "• Trend identification over time\n" \
            "• Trigger event analysis\n" \
            "• Consistency & variability metrics\n" \
            "• Adaptive behavior recognition\n" \
            "• Predictive pattern modeling\n\n" \
            "🎯 **Insight Applications:**\n" \
            "• Personal effectiveness optimization\n" \
            "• Habit formation & breaking\n" \
            "• Emotional regulation improvement\n" \
            "• Relationship pattern understanding\n" \
            "• Performance enhancement strategies\n\n" \
            'Share your recent experiences for behavioral pattern analysis!',
      processing_time: rand(1.4..2.8).round(2),
      personality_insights: generate_behavioral_insights,
      behavioral_patterns: generate_detailed_behavioral_patterns,
      communication_style: 'pattern_focused',
      recommendations: generate_behavioral_recommendations
    }
  end

  def handle_general_personality_query(_message)
    {
      text: "🎭 **PersonaX Personality AI Ready**\n\n" \
            "Your expert in personality science and human psychology! Here's what I offer:\n\n" \
            "🌌 **Core Capabilities:**\n" \
            "• Comprehensive personality analysis\n" \
            "• MBTI & Big Five assessments\n" \
            "• Relationship compatibility analysis\n" \
            "• Personal development coaching\n" \
            "• Behavioral pattern recognition\n" \
            "• Communication style optimization\n\n" \
            "⚡ **Quick Commands:**\n" \
            "• 'analyze my personality' - Full assessment\n" \
            "• 'MBTI test' - Personality type discovery\n" \
            "• 'compatibility check' - Relationship analysis\n" \
            "• 'development plan' - Growth roadmap\n" \
            "• 'behavioral patterns' - Habit analysis\n\n" \
            "🎯 **Specialized Services:**\n" \
            "• Career guidance based on personality\n" \
            "• Team dynamics optimization\n" \
            "• Leadership style assessment\n" \
            "• Conflict resolution strategies\n\n" \
            'What aspect of personality science interests you most?',
      processing_time: rand(1.0..2.3).round(2),
      personality_insights: generate_overview_insights,
      behavioral_patterns: generate_overview_patterns,
      communication_style: 'comprehensive_overview',
      recommendations: generate_general_recommendations
    }
  end

  # Helper methods for generating sample data
  def generate_sample_personality_insights
    {
      big_five: {
        openness: 78,
        conscientiousness: 85,
        extraversion: 62,
        agreeableness: 91,
        neuroticism: 34
      },
      dominant_traits: %w[analytical empathetic detail-oriented],
      cognitive_style: 'systematic_thinker'
    }
  end

  def generate_behavioral_patterns
    {
      communication_frequency: 'high_interactive',
      decision_making: 'analytical_deliberate',
      stress_response: 'problem_solving_focused',
      social_preference: 'small_group_oriented'
    }
  end

  def generate_personality_recommendations
    [
      'Leverage analytical strengths in problem-solving',
      'Practice active listening in conversations',
      'Set structured goals for personal projects',
      'Balance work with social activities'
    ]
  end

  def generate_mbti_insights
    {
      predicted_type: 'INFJ',
      confidence: 87,
      type_nickname: 'The Advocate',
      cognitive_functions: %w[Ni Fe Ti Se]
    }
  end

  def generate_mbti_patterns
    {
      introversion_indicators: ['deep thinking', 'energy from solitude'],
      intuition_signs: ['big picture focus', 'pattern recognition'],
      feeling_traits: ['value-driven decisions', 'empathy priority'],
      judging_preferences: ['structured approach', 'closure seeking']
    }
  end

  def generate_mbti_recommendations
    [
      'Create quiet spaces for reflection and planning',
      'Focus on meaningful projects aligned with values',
      'Practice expressing ideas clearly to others',
      'Balance idealism with practical implementation'
    ]
  end

  def generate_compatibility_insights
    {
      compatibility_score: 84,
      strength_areas: ['shared values', 'complementary skills'],
      challenge_areas: ['communication styles', 'decision timing'],
      relationship_dynamic: 'supportive_growth'
    }
  end

  def generate_compatibility_patterns
    {
      communication_synergy: 'high_potential',
      conflict_style: 'collaborative_resolution',
      support_exchange: 'balanced_mutual',
      growth_catalyst: 'mutual_development'
    }
  end

  def generate_compatibility_recommendations
    [
      'Establish regular communication check-ins',
      'Respect different processing styles',
      'Create shared goals and experiences',
      'Practice patience during disagreements'
    ]
  end

  def generate_development_insights
    {
      current_level: 'intermediate_advanced',
      growth_potential: 'high',
      priority_areas: ['emotional regulation', 'leadership presence'],
      timeline: '6_12_months'
    }
  end

  def generate_development_patterns
    {
      learning_style: 'reflective_experiential',
      motivation_drivers: %w[personal_mastery impact_on_others],
      change_readiness: 'high_commitment',
      support_needs: 'structured_guidance'
    }
  end

  def generate_development_recommendations
    [
      'Set specific, measurable personality goals',
      'Practice new behaviors in low-risk situations',
      'Seek feedback from trusted colleagues',
      'Maintain consistency in development efforts'
    ]
  end

  def generate_behavioral_insights
    {
      pattern_consistency: 'high',
      adaptability_level: 'moderate_flexible',
      habit_strength: 'well_established',
      change_indicators: 'gradual_evolution'
    }
  end

  def generate_detailed_behavioral_patterns
    {
      daily_rhythms: 'morning_peak_performance',
      social_cycles: 'weekly_recharge_needed',
      stress_patterns: 'deadline_responsive',
      creativity_flow: 'afternoon_evening_optimal'
    }
  end

  def generate_behavioral_recommendations
    [
      'Optimize schedule around natural energy patterns',
      'Implement stress-management techniques',
      'Create systems for consistent positive habits',
      'Monitor and adjust behavioral triggers'
    ]
  end

  def generate_overview_insights
    {
      assessment_readiness: 'high_engagement',
      personality_awareness: 'developing',
      growth_orientation: 'actively_seeking',
      application_focus: 'personal_professional'
    }
  end

  def generate_overview_patterns
    {
      inquiry_style: 'comprehensive_curious',
      learning_approach: 'structured_systematic',
      application_preference: 'practical_actionable',
      feedback_receptivity: 'open_constructive'
    }
  end

  def generate_general_recommendations
    [
      'Start with a comprehensive personality assessment',
      'Identify specific areas for development',
      'Create actionable improvement plans',
      'Track progress and celebrate growth'
    ]
  end
end
