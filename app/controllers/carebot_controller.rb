# frozen_string_literal: true

require 'ostruct'

class CarebotController < ApplicationController
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
      # Process CareBot healthcare assistance request
      response_data = process_carebot_request(user_message)

      render json: {
        success: true,
        response: response_data[:text],
        processing_time: response_data[:processing_time],
        agent_name: @agent.name,
        timestamp: Time.current.strftime('%H:%M:%S'),
        health_assessment: response_data[:health_assessment],
        recommendations: response_data[:recommendations],
        urgency_level: response_data[:urgency_level],
        disclaimer: response_data[:disclaimer]
      }
    rescue StandardError => e
      Rails.logger.error "Carebot Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  # New specialized CareBot endpoints
  def symptom_checker
    symptoms = params[:symptoms]
    duration = params[:duration]
    severity = params[:severity]

    assessment_results = assess_symptoms(symptoms, duration, severity)

    render json: {
      success: true,
      assessment: assessment_results,
      recommendations: generate_health_recommendations(assessment_results),
      when_to_see_doctor: determine_medical_urgency(assessment_results),
      disclaimer: health_disclaimer
    }
  end

  def wellness_plan
    goals = params[:goals] || []
    current_health = params[:current_health] || {}
    preferences = params[:preferences] || {}

    plan_results = create_wellness_plan(goals, current_health, preferences)

    render json: {
      success: true,
      plan: plan_results,
      daily_activities: generate_daily_activities(plan_results),
      progress_tracking: setup_progress_tracking(goals),
      disclaimer: wellness_disclaimer
    }
  end

  def medication_reminder
    medications = params[:medications] || []
    schedule_preferences = params[:schedule] || {}

    reminder_system = setup_medication_reminders(medications, schedule_preferences)

    render json: {
      success: true,
      reminders: reminder_system,
      interaction_warnings: check_drug_interactions(medications),
      adherence_tips: generate_adherence_tips(medications),
      disclaimer: medication_disclaimer
    }
  end

  def mental_health_support
    mood_data = params[:mood] || {}
    stress_level = params[:stress_level]
    support_type = params[:support_type] || 'general'

    support_results = provide_mental_health_support(mood_data, stress_level, support_type)

    render json: {
      success: true,
      support: support_results,
      coping_strategies: suggest_coping_strategies(mood_data),
      professional_resources: mental_health_resources,
      crisis_support: crisis_support_info
    }
  end

  def fitness_tracker
    activity_data = params[:activity] || {}
    fitness_goals = params[:goals] || []

    tracking_results = analyze_fitness_data(activity_data, fitness_goals)

    render json: {
      success: true,
      analysis: tracking_results,
      workout_suggestions: generate_workout_plans(fitness_goals),
      nutrition_advice: provide_nutrition_guidance(activity_data),
      progress_metrics: calculate_fitness_metrics(activity_data)
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
      name: 'CareBot',
      agent_type: 'carebot',
      status: 'active',
      total_conversations: rand(3000..5500),
      average_rating: rand(4.5..4.9),
      specializations: ['Health Assessment', 'Medical Information', 'Wellness Coaching', 'Mental Health Support',
                        'Emergency Response', 'Symptom Analysis'],
      capabilities: ['Health Monitoring', 'Medical Consultation', 'Wellness Planning', 'Emergency Assistance',
                     'Mental Health Care', 'Preventive Care'],
      configuration: { 'response_style' => 'healthcare_compassionate' },
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

  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid

    @user = OpenStruct.new(
      id: session_id.hash,
      email: "demo_#{session_id}@carebot.onelastai.com",
      name: "CareBot User #{rand(1000..9999)}",
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
      subdomain: 'carebot',
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

  # CareBot specialized processing methods
  def process_carebot_request(message)
    health_intent = detect_health_intent(message)

    case health_intent
    when :symptoms
      handle_symptom_assessment(message)
    when :wellness
      handle_wellness_planning(message)
    when :medication
      handle_medication_assistance(message)
    when :mental_health
      handle_mental_health_support(message)
    when :fitness
      handle_fitness_tracking(message)
    else
      handle_general_health_query(message)
    end
  end

  def detect_health_intent(message)
    message_lower = message.downcase

    return :symptoms if message_lower.match?(/pain|hurt|ache|symptom|feel|sick|fever/)
    return :wellness if message_lower.match?(/wellness|health plan|diet|nutrition|exercise/)
    return :medication if message_lower.match?(/medication|medicine|pill|drug|prescription/)
    return :mental_health if message_lower.match?(/stress|anxiety|depression|mental|mood/)
    return :fitness if message_lower.match?(/fitness|workout|training|activity|steps/)

    :general
  end

  def handle_symptom_assessment(_message)
    {
      text: "🏥 **CareBot Health Assessment System**\n\n" \
            '⚠️ **IMPORTANT DISCLAIMER:** I provide general health information only. ' \
            "For medical emergencies, call emergency services immediately.\n\n" \
            "🔍 **Symptom Assessment Features:**\n" \
            "• Comprehensive symptom analysis\n" \
            "• Risk level evaluation (Low/Medium/High)\n" \
            "• When to seek medical attention guidance\n" \
            "• Home care recommendations\n" \
            "• Follow-up monitoring suggestions\n\n" \
            "📋 **Assessment Process:**\n" \
            "• Detailed symptom description\n" \
            "• Duration and severity tracking\n" \
            "• Associated symptoms identification\n" \
            "• Medical history consideration\n" \
            "• Professional consultation advice\n\n" \
            "🎯 **Next Steps:**\n" \
            'Please describe your symptoms in detail for a comprehensive assessment.',
      processing_time: rand(1.2..2.5).round(2),
      health_assessment: generate_sample_assessment,
      recommendations: generate_health_recommendations,
      urgency_level: 'low_moderate',
      disclaimer: health_disclaimer
    }
  end

  def handle_wellness_planning(_message)
    {
      text: "🌟 **CareBot Wellness Planning System**\n\n" \
            "Your personalized path to optimal health and wellness:\n\n" \
            "🎯 **Wellness Areas:**\n" \
            "• Nutrition & dietary planning\n" \
            "• Physical activity & exercise\n" \
            "• Sleep optimization\n" \
            "• Stress management\n" \
            "• Preventive health measures\n\n" \
            "📊 **Planning Features:**\n" \
            "• Goal setting & tracking\n" \
            "• Progress monitoring\n" \
            "• Habit formation support\n" \
            "• Personalized recommendations\n" \
            "• Science-based strategies\n\n" \
            "🔄 **Continuous Support:**\n" \
            "• Weekly check-ins\n" \
            "• Plan adjustments\n" \
            "• Motivation & encouragement\n" \
            "• Educational resources\n\n" \
            'What wellness goals would you like to focus on?',
      processing_time: rand(1.5..3.1).round(2),
      health_assessment: { plan_type: 'comprehensive_wellness' },
      recommendations: generate_wellness_recommendations,
      urgency_level: 'lifestyle_optimization',
      disclaimer: wellness_disclaimer
    }
  end

  def handle_medication_assistance(_message)
    {
      text: "💊 **CareBot Medication Management System**\n\n" \
            "⚠️ **IMPORTANT:** Always consult healthcare providers for medication decisions.\n\n" \
            "📋 **Medication Support:**\n" \
            "• Medication reminders & scheduling\n" \
            "• Drug interaction checking\n" \
            "• Side effect monitoring\n" \
            "• Adherence tracking\n" \
            "• Pharmacy coordination\n\n" \
            "⏰ **Smart Reminders:**\n" \
            "• Customizable alert times\n" \
            "• Multiple notification methods\n" \
            "• Dosage tracking\n" \
            "• Refill reminders\n" \
            "• Missed dose management\n\n" \
            "🔍 **Safety Features:**\n" \
            "• Drug interaction alerts\n" \
            "• Allergy warnings\n" \
            "• Dosage verification\n" \
            "• Healthcare provider coordination\n\n" \
            'How can I help with your medication management?',
      processing_time: rand(1.0..2.3).round(2),
      health_assessment: { service_type: 'medication_management' },
      recommendations: generate_medication_recommendations,
      urgency_level: 'monitoring_required',
      disclaimer: medication_disclaimer
    }
  end

  def handle_mental_health_support(_message)
    {
      text: "🌌 **CareBot Mental Health Support System**\n\n" \
            "🤗 **Compassionate Care:** Your mental health matters. I'm here to support you.\n\n" \
            "💚 **Support Services:**\n" \
            "• Mood tracking & analysis\n" \
            "• Stress management techniques\n" \
            "• Coping strategy recommendations\n" \
            "• Mindfulness & relaxation guidance\n" \
            "• Crisis resource information\n\n" \
            "🔧 **Mental Wellness Tools:**\n" \
            "• Daily mood journaling\n" \
            "• Breathing exercises\n" \
            "• Progressive muscle relaxation\n" \
            "• Cognitive behavioral techniques\n" \
            "• Sleep hygiene guidance\n\n" \
            "🆘 **Crisis Support:**\n" \
            "• National Suicide Prevention Lifeline: 988\n" \
            "• Crisis Text Line: Text HOME to 741741\n" \
            "• Emergency services: 911\n\n" \
            "How are you feeling today? I'm here to listen and support you.",
      processing_time: rand(1.8..3.2).round(2),
      health_assessment: { support_type: 'mental_health' },
      recommendations: generate_mental_health_resources,
      urgency_level: 'supportive_care',
      disclaimer: mental_health_disclaimer
    }
  end

  def handle_fitness_tracking(_message)
    {
      text: "💪 **CareBot Fitness & Activity Tracker**\n\n" \
            "Your personal fitness companion for a healthier lifestyle:\n\n" \
            "🏃 **Activity Tracking:**\n" \
            "• Daily steps & distance\n" \
            "• Exercise duration & intensity\n" \
            "• Calorie burn estimation\n" \
            "• Heart rate monitoring\n" \
            "• Sleep quality tracking\n\n" \
            "🎯 **Fitness Planning:**\n" \
            "• Personalized workout routines\n" \
            "• Progressive training programs\n" \
            "• Goal setting & achievement\n" \
            "• Injury prevention tips\n" \
            "• Recovery optimization\n\n" \
            "📊 **Progress Analytics:**\n" \
            "• Weekly/monthly summaries\n" \
            "• Trend analysis\n" \
            "• Achievement milestones\n" \
            "• Performance improvements\n" \
            "• Motivation insights\n\n" \
            "What are your fitness goals? Let's create a plan together!",
      processing_time: rand(1.3..2.7).round(2),
      health_assessment: { tracking_type: 'fitness_activity' },
      recommendations: generate_fitness_recommendations,
      urgency_level: 'lifestyle_enhancement',
      disclaimer: fitness_disclaimer
    }
  end

  def handle_general_health_query(_message)
    {
      text: "🏥 **CareBot Health Assistant Ready**\n\n" \
            "Your trusted AI health companion! Here's how I can support your wellbeing:\n\n" \
            "🎯 **Core Health Services:**\n" \
            "• Symptom assessment & guidance\n" \
            "• Wellness planning & goal setting\n" \
            "• Medication management support\n" \
            "• Mental health & stress support\n" \
            "• Fitness tracking & motivation\n" \
            "• Health education & resources\n\n" \
            "⚡ **Quick Commands:**\n" \
            "• 'I have symptoms' - Health assessment\n" \
            "• 'wellness plan' - Personalized health goals\n" \
            "• 'medication help' - Medication management\n" \
            "• 'feeling stressed' - Mental health support\n" \
            "• 'fitness goals' - Activity tracking\n\n" \
            "⚠️ **Important Reminders:**\n" \
            "• I provide general health information only\n" \
            "• Always consult healthcare professionals\n" \
            "• Call emergency services for urgent situations\n" \
            "• Your privacy and confidentiality are protected\n\n" \
            'How can I support your health journey today?',
      processing_time: rand(0.9..2.0).round(2),
      health_assessment: { service_overview: 'comprehensive_health_support' },
      recommendations: generate_general_recommendations,
      urgency_level: 'informational',
      disclaimer: general_health_disclaimer
    }
  end

  # Helper methods for generating sample data
  def generate_sample_assessment
    {
      symptoms_identified: ['mild headache', 'fatigue'],
      risk_level: 'low_moderate',
      recommended_action: 'monitor_symptoms',
      follow_up: '24_hours'
    }
  end

  def generate_health_recommendations
    [
      'Stay hydrated (8-10 glasses of water daily)',
      'Get adequate rest (7-9 hours of sleep)',
      'Monitor symptoms for 24-48 hours',
      'Consult healthcare provider if symptoms worsen'
    ]
  end

  def generate_wellness_recommendations
    [
      'Set SMART health goals',
      'Focus on balanced nutrition',
      'Incorporate 30 minutes of daily activity',
      'Practice stress management techniques'
    ]
  end

  def generate_medication_recommendations
    [
      'Set consistent medication times',
      'Use pill organizers for complex regimens',
      'Keep medication list updated',
      'Store medications properly'
    ]
  end

  def generate_mental_health_resources
    [
      'Practice daily mindfulness (5-10 minutes)',
      'Maintain social connections',
      'Consider professional counseling',
      'Use crisis resources if needed'
    ]
  end

  def generate_fitness_recommendations
    [
      'Start with manageable exercise goals',
      'Mix cardio and strength training',
      'Track progress regularly',
      'Listen to your body and rest when needed'
    ]
  end

  def generate_general_recommendations
    [
      'Regular health check-ups',
      'Balanced diet and exercise',
      'Stress management',
      'Adequate sleep and hydration'
    ]
  end

  # Disclaimer methods
  def health_disclaimer
    'This information is for educational purposes only and does not replace professional medical advice.'
  end

  def wellness_disclaimer
    'Wellness plans should complement, not replace, professional healthcare guidance.'
  end

  def medication_disclaimer
    'Always consult your healthcare provider or pharmacist for medication-related decisions.'
  end

  def mental_health_disclaimer
    'For mental health emergencies, contact crisis services immediately. This support is educational only.'
  end

  def fitness_disclaimer
    'Consult your doctor before starting new exercise programs, especially with health conditions.'
  end

  def general_health_disclaimer
    'All health information provided is general and educational. Consult healthcare professionals for personal medical advice.'
  end
end
