# frozen_string_literal: true

# Agents Controller - Main API endpoint for AI agent interactions
# This controller handles all communication with the AI multiverse platform

class AgentsController < AgentController
  before_action :set_agent, only: %i[show chat status]
  before_action :authenticate_user!, only: %i[chat personal_stats]

  # GET /agents
  # List all available agents in the multiverse
  def index
    @agents = Agent.active.includes(:agent_interactions)

    agents_data = @agents.map do |agent|
      {
        id: agent.id,
        name: agent.name,
        agent_type: agent.agent_type,
        tagline: agent.tagline,
        avatar_url: agent.avatar_url,
        status: agent.status,
        personality_traits: agent.personality_traits,
        capabilities: agent.capabilities,
        total_interactions: agent.agent_interactions.count,
        average_rating: agent.satisfaction_rate,
        last_active: agent.last_active_at,
        preview_message: generate_preview_message(agent)
      }
    end

    respond_to do |format|
      format.html { render :index } # Render HTML view for browser requests
      format.json do
        render json: {
          success: true,
          agents: agents_data,
          total_count: @agents.count,
          featured_agent: get_featured_agent
        }
      end
    end
  end

  # GET /agents/:id
  # Get detailed information about a specific agent
  def show
    agent_data = {
      id: @agent.id,
      name: @agent.name,
      agent_type: @agent.agent_type,
      tagline: @agent.tagline,
      description: @agent.description,
      avatar_url: @agent.avatar_url,
      status: @agent.status,
      personality_traits: @agent.personality_traits,
      capabilities: @agent.capabilities,
      specializations: @agent.specializations,
      interaction_stats: get_agent_stats(@agent),
      sample_conversations: get_sample_conversations(@agent),
      personality_description: PersonalityEngine.get_personality_description(@agent.personality_traits),
      getting_started_tips: get_getting_started_tips(@agent)
    }

    render json: {
      success: true,
      agent: agent_data
    }
  end

  # POST /agents/:id/chat
  # Main chat endpoint for agent interactions
  def chat
    unless params[:message].present?
      return render json: {
        success: false,
        error: 'Message is required'
      }, status: :bad_request
    end

    begin
      # Process the user's message through the agent
      response_data = process_agent_interaction(
        agent: @agent,
        user: current_user,
        message: params[:message],
        context: build_interaction_context
      )

      # Store the interaction
      interaction = create_interaction_record(response_data)

      render json: {
        success: true,
        response: response_data[:response],
        agent_suggestions: response_data[:suggestions],
        emotional_context: response_data[:emotional_analysis],
        interaction_id: interaction.id,
        agent_status: @agent.status,
        personality_adaptation: response_data[:personality_adaptation]
      }
    rescue StandardError => e
      Rails.logger.error "Agent interaction error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      render json: {
        success: false,
        error: 'Something went wrong processing your message. Please try again.',
        fallback_response: get_fallback_response(@agent)
      }, status: :internal_server_error
    end
  end

  # GET /agents/:id/status
  # Check agent availability and status
  def status
    render json: {
      success: true,
      agent_id: @agent.id,
      status: @agent.status,
      last_active: @agent.last_active_at,
      current_load: calculate_current_load(@agent),
      estimated_response_time: estimate_response_time(@agent),
      capabilities_online: @agent.capabilities,
      maintenance_mode: @agent.status == 'maintenance'
    }
  end

  # POST /agents/:id/feedback
  # Submit feedback for an interaction
  def feedback
    interaction = AgentInteraction.find_by(id: params[:interaction_id])

    unless interaction&.user == current_user
      return render json: {
        success: false,
        error: 'Interaction not found'
      }, status: :not_found
    end

    # Update interaction with feedback
    interaction.update!(
      rating: params[:rating]&.to_i,
      feedback: params[:feedback],
      feedback_categories: params[:feedback_categories] || []
    )

    # Update agent's learning from feedback
    update_agent_learning(@agent, interaction, params[:rating].to_i) if params[:rating].present?

    render json: {
      success: true,
      message: 'Thank you for your feedback!',
      updated_rating: interaction.rating
    }
  end

  # GET /agents/personal_stats
  # Get user's personal interaction statistics
  def personal_stats
    stats = calculate_personal_stats(current_user)

    render json: {
      success: true,
      stats:
    }
  end

  # GET /agents/recommendations
  # Get personalized agent recommendations
  def recommendations
    recommended_agents = get_agent_recommendations(current_user)

    render json: {
      success: true,
      recommendations: recommended_agents
    }
  end

  private

  def set_agent
    @agent = Agent.find_by(id: params[:id])

    return if @agent

    render json: {
      success: false,
      error: 'Agent not found'
    }, status: :not_found
  end

  def authenticate_user!
    # Placeholder for authentication
    # In a real app, this would verify JWT tokens or session authentication
    @current_user ||= User.first # Temporary for demo
  end

  attr_reader :current_user

  def process_agent_interaction(agent:, user:, message:, context:)
    # Get the appropriate engine class for this agent
    engine_class = agent.engine_class

    # Initialize the engine
    engine = engine_class.new

    # Process the interaction
    engine.process_input(
      user_input: message,
      user:,
      context:
    )
  end

  def build_interaction_context
    context = {
      session_id: session[:session_id] || SecureRandom.uuid,
      user_agent: request.user_agent,
      time_of_day: Time.current.strftime('%H:%M'),
      conversation_history: get_recent_conversation_history,
      user_preferences: get_user_preferences,
      emotional_state: get_last_emotional_state
    }

    # Store session ID for continuity
    session[:session_id] = context[:session_id]

    context
  end

  def create_interaction_record(response_data)
    AgentInteraction.create!(
      agent: @agent,
      user: current_user,
      user_message: params[:message],
      agent_response: response_data[:response],
      emotional_context: response_data[:emotional_analysis][:primary_emotion],
      response_time: response_data[:processing_time] || 0,
      session_id: session[:session_id],
      metadata: {
        suggestions_provided: response_data[:suggestions],
        personality_adaptation: response_data[:personality_adaptation],
        confidence_score: response_data[:emotional_analysis][:confidence]
      }
    )
  end

  def get_recent_conversation_history
    return [] unless current_user

    AgentInteraction.where(user: current_user, agent: @agent)
                    .where('created_at > ?', 24.hours.ago)
                    .order(:created_at)
                    .limit(10)
                    .pluck(:user_message, :agent_response, :emotional_context, :created_at)
                    .map do |message, response, emotion, timestamp|
      {
        user_message: message,
        agent_response: response,
        emotion:,
        timestamp:
      }
    end
  end

  def get_user_preferences
    return {} unless current_user

    # Get user preferences from their memory/profile
    memories = AgentMemory.where(user: current_user, memory_type: 'preference')
                          .limit(10)
                          .pluck(:content)

    preferences = {}
    memories.each do |memory_content|
      preferences.merge!(memory_content) if memory_content.is_a?(Hash)
    end

    preferences
  end

  def get_last_emotional_state
    return 'neutral' unless current_user

    last_interaction = AgentInteraction.where(user: current_user)
                                       .where('created_at > ?', 1.hour.ago)
                                       .order(:created_at)
                                       .last

    last_interaction&.emotional_context || 'neutral'
  end

  def generate_preview_message(agent)
    case agent.agent_type
    when 'mood_engine'
      'I can sense your energy and adapt to support exactly what you need right now. How are you feeling? 🌌✨'
    when 'rapstar_ai'
      "Yo! Ready to drop some bars or work on your flow? Let's create something fire together! 🎤🔥"
    when 'storyteller'
      'Let me weave you a tale that captures your imagination. What story shall we bring to life today? 📚✨'
    when 'zen_agent'
      "In this moment of presence, I'm here to guide you toward inner peace. What would serve your wellbeing? 🧘‍♀️🕊️"
    else
      "Hello! I'm here to help you with whatever you need. How can I assist you today?"
    end
  end

  def get_featured_agent
    # Return the agent with highest satisfaction rate
    featured = Agent.active
                    .joins(:agent_interactions)
                    .group('agents.id')
                    .having('COUNT(agent_interactions.id) > 5')
                    .order('AVG(agent_interactions.rating) DESC NULLS LAST')
                    .first

    return nil unless featured

    {
      id: featured.id,
      name: featured.name,
      agent_type: featured.agent_type,
      tagline: featured.tagline,
      reason: "Highest user satisfaction with #{featured.satisfaction_rate}% positive ratings"
    }
  end

  def get_agent_stats(agent)
    interactions = agent.agent_interactions

    {
      total_interactions: interactions.count,
      average_rating: interactions.average(:rating)&.round(2),
      satisfaction_rate: agent.satisfaction_rate,
      response_time_avg: interactions.average(:response_time)&.round(2),
      most_active_hours: get_most_active_hours(interactions),
      emotional_distribution: get_emotional_distribution(interactions),
      user_retention_rate: calculate_user_retention(agent)
    }
  end

  def get_sample_conversations(agent)
    # Get highly rated sample conversations
    sample_interactions = agent.agent_interactions
                               .where('rating >= ?', 4)
                               .where('LENGTH(user_message) > 10')
                               .order('rating DESC, created_at DESC')
                               .limit(3)

    sample_interactions.map do |interaction|
      {
        user_message: interaction.user_message,
        agent_response: interaction.agent_response.truncate(200),
        rating: interaction.rating,
        emotional_context: interaction.emotional_context
      }
    end
  end

  def get_getting_started_tips(agent)
    case agent.agent_type
    when 'mood_engine'
      [
        "Share how you're feeling - I adapt to your emotional needs",
        "Try asking: 'I'm feeling anxious about work'",
        'I can suggest activities based on your current mood',
        "Let me know your stress levels and I'll help you find balance"
      ]
    when 'rapstar_ai'
      [
        "Tell me a topic and I'll write some bars about it",
        'Share your lyrics for feedback and improvement tips',
        'Ask about different rap styles or hip-hop history',
        "Try: 'Write a verse about overcoming challenges'"
      ]
    when 'storyteller'
      [
        "Give me any prompt and I'll craft an original story",
        'Ask for help developing characters or plot ideas',
        'Request different genres: fantasy, sci-fi, mystery, etc.',
        "Try: 'Tell me a story about a magical library'"
      ]
    when 'zen_agent'
      [
        'Ask me to guide you through meditation practices',
        "Share what's stressing you for personalized mindfulness advice",
        'Request breathing exercises for any situation',
        "Try: 'I need help finding inner peace'"
      ]
    else
      [
        'Feel free to ask me anything!',
        "I'm here to help with whatever you need",
        'Try different types of questions to see what I can do'
      ]
    end
  end

  def calculate_current_load(agent)
    # Calculate current system load for the agent
    recent_interactions = agent.agent_interactions
                               .where('created_at > ?', 1.hour.ago)
                               .count

    # Simple load calculation - would be more sophisticated in production
    load_percentage = [recent_interactions * 2, 100].min

    {
      percentage: load_percentage,
      status: if load_percentage > 80
                'high'
              else
                load_percentage > 50 ? 'medium' : 'low'
              end,
      interactions_last_hour: recent_interactions
    }
  end

  def estimate_response_time(agent)
    avg_response_time = agent.agent_interactions
                             .where('created_at > ?', 24.hours.ago)
                             .average(:response_time) || 1.5

    current_load = calculate_current_load(agent)

    # Adjust estimate based on current load
    load_multiplier = case current_load[:status]
                      when 'high' then 1.5
                      when 'medium' then 1.2
                      else 1.0
                      end

    (avg_response_time * load_multiplier).round(1)
  end

  def get_fallback_response(agent)
    fallback_responses = {
      'mood_engine' => "I'm here to support you emotionally. Please try again and let me know how you're feeling. 🌌🌌💙",
      'rapstar_ai' => "Yo, looks like I hit a technical snag! Drop that message again and let's get back to creating fire! 🎤",
      'storyteller' => 'Apologies, dear reader - the narrative thread was momentarily lost. Please share your request again! 📚',
      'zen_agent' => 'In this moment of technical impermanence, please breathe and try your message again. Peace. 🧘‍♀️',
      'default' => "I'm experiencing some technical difficulties. Please try your message again!"
    }

    fallback_responses[agent.agent_type] || fallback_responses['default']
  end

  def update_agent_learning(agent, interaction, rating)
    # Simple learning mechanism - would be more sophisticated in production
    if rating >= 4
      # Positive feedback - reinforce successful patterns
      MemoryService.store_memory(
        agent,
        interaction.user,
        {
          type: 'achievement',
          content: {
            interaction_id: interaction.id,
            successful_response: interaction.agent_response,
            user_satisfaction: rating,
            context: 'positive_feedback'
          },
          emotional_context: interaction.emotional_context
        }
      )
    elsif rating <= 2
      # Negative feedback - learn from mistakes
      MemoryService.store_memory(
        agent,
        interaction.user,
        {
          type: 'conversation',
          content: {
            interaction_id: interaction.id,
            improvement_needed: interaction.agent_response,
            user_dissatisfaction: rating,
            context: 'negative_feedback'
          },
          emotional_context: interaction.emotional_context
        }
      )
    end
  end

  def calculate_personal_stats(user)
    interactions = AgentInteraction.where(user:)

    {
      total_conversations: interactions.count,
      favorite_agents: get_favorite_agents(user),
      emotional_insights: get_emotional_insights(user),
      interaction_patterns: get_interaction_patterns(user),
      achievements: get_user_achievements(user),
      growth_metrics: calculate_growth_metrics(user)
    }
  end

  def get_agent_recommendations(user)
    return Agent.active.limit(3) unless user

    # Get user's interaction patterns
    user_interactions = AgentInteraction.where(user:)

    # Simple recommendation logic
    if user_interactions.empty?
      # New user - recommend diverse agents
      Agent.active.order(:created_at).limit(3)
    else
      # Existing user - recommend based on patterns
      highly_rated_types = user_interactions.where('rating >= ?', 4)
                                            .joins(:agent)
                                            .group('agents.agent_type')
                                            .count

      # Recommend agents of types they've enjoyed
      recommended_types = highly_rated_types.keys.first(2)
      Agent.active.where(agent_type: recommended_types).limit(3)
    end
  end

  def get_most_active_hours(interactions)
    hours_count = interactions.group('EXTRACT(hour FROM created_at)').count
    hours_count.max_by { |_hour, count| count }&.first || 12
  end

  def get_emotional_distribution(interactions)
    interactions.group(:emotional_context).count
  end

  def calculate_user_retention(agent)
    # Calculate what percentage of users return for multiple conversations
    users_with_multiple = agent.agent_interactions
                               .group(:user_id)
                               .having('COUNT(*) > 1')
                               .count
                               .keys
                               .length

    total_users = agent.agent_interactions.distinct.count(:user_id)

    return 0 if total_users == 0

    ((users_with_multiple.to_f / total_users) * 100).round(1)
  end

  def get_favorite_agents(user)
    AgentInteraction.joins(:agent)
                    .where(user:)
                    .group('agents.name', 'agents.agent_type')
                    .average(:rating)
                    .sort_by { |_agent, rating| -rating }
                    .first(3)
                    .map { |agent_info, rating| { name: agent_info[0], type: agent_info[1], rating: rating.round(2) } }
  end

  def get_emotional_insights(user)
    emotion_distribution = AgentInteraction.where(user:)
                                           .group(:emotional_context)
                                           .count

    total_interactions = emotion_distribution.values.sum
    return {} if total_interactions == 0

    emotion_distribution.transform_values do |count|
      ((count.to_f / total_interactions) * 100).round(1)
    end
  end

  def get_interaction_patterns(user)
    interactions = AgentInteraction.where(user:)

    {
      most_active_time: get_most_active_hours(interactions),
      average_session_length: calculate_average_session_length(user),
      preferred_conversation_style: determine_conversation_style(user)
    }
  end

  def get_user_achievements(user)
    achievements = []
    interaction_count = AgentInteraction.where(user:).count

    achievements << { name: 'Conversationalist', description: 'Had 10+ AI conversations' } if interaction_count >= 10

    achievements << { name: 'AI Enthusiast', description: 'Had 50+ AI conversations' } if interaction_count >= 50

    # Check for high ratings
    high_rated_count = AgentInteraction.where(user:, rating: 4..5).count
    achievements << { name: 'AI Whisperer', description: '20+ highly rated conversations' } if high_rated_count >= 20

    achievements
  end

  def calculate_growth_metrics(user)
    interactions = AgentInteraction.where(user:).order(:created_at)
    return {} if interactions.count < 5

    recent_ratings = interactions.last(10).pluck(:rating).compact
    early_ratings = interactions.first(10).pluck(:rating).compact

    return {} if recent_ratings.empty? || early_ratings.empty?

    {
      satisfaction_trend: recent_ratings.sum.to_f / recent_ratings.length - early_ratings.sum.to_f / early_ratings.length,
      total_growth: interactions.count,
      engagement_consistency: calculate_engagement_consistency(user)
    }
  end

  def calculate_average_session_length(user)
    # Group interactions by session and calculate average
    sessions = AgentInteraction.where(user:)
                               .where.not(session_id: nil)
                               .group(:session_id)
                               .count

    return 0 if sessions.empty?

    sessions.values.sum.to_f / sessions.length
  end

  def determine_conversation_style(user)
    interactions = AgentInteraction.where(user:)
    avg_message_length = interactions.average('LENGTH(user_message)') || 0

    case avg_message_length
    when 0..50 then 'concise'
    when 50..150 then 'balanced'
    else 'detailed'
    end
  end

  def calculate_engagement_consistency(user)
    # Measure how consistently the user engages over time
    interactions_by_week = AgentInteraction.where(user:)
                                           .where('created_at > ?', 8.weeks.ago)
                                           .group("DATE_TRUNC('week', created_at)")
                                           .count

    return 0 if interactions_by_week.empty?

    # Calculate coefficient of variation (lower = more consistent)
    values = interactions_by_week.values
    mean = values.sum.to_f / values.length
    variance = values.sum { |x| (x - mean)**2 } / values.length
    std_dev = Math.sqrt(variance)

    # Return consistency score (higher = more consistent)
    return 100 if mean == 0

    [100 - ((std_dev / mean) * 100), 0].max.round(1)
  end
end
