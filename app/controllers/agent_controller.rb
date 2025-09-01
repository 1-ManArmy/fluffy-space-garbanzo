# frozen_string_literal: true

# Base Agent Controller - Shared functionality for all AI agent controllers
class AgentController < ApplicationController
  before_action :initialize_session
  before_action :track_page_view

  protected

  # Initialize user session for agent interactions
  def initialize_session
    session[:user_id] ||= SecureRandom.uuid
    session[:session_id] ||= SecureRandom.uuid
  end

  # Track page views for analytics
  def track_page_view
    return unless @agent

    AgentInteraction.create_interaction(
      @agent,
      session[:user_id],
      'page_view',
      {
        controller: controller_name,
        action: action_name,
        path: request.path,
        timestamp: Time.current
      },
      {
        session_id: session[:session_id],
        ip_address: request.remote_ip,
        user_agent: request.user_agent,
        metadata: {
          referrer: request.referer,
          user_agent: request.user_agent
        }
      }
    ).mark_completed!
  end

  # Create interaction record for agent actions
  def create_interaction(interaction_type, input_data, output_data = {})
    return unless @agent

    interaction = AgentInteraction.create_interaction(
      @agent,
      session[:user_id],
      interaction_type,
      input_data,
      {
        session_id: session[:session_id],
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      }
    )

    interaction.mark_completed!(output_data) if output_data.present?

    interaction
  end

  # Handle errors gracefully
  def handle_agent_error(error, interaction = nil)
    Rails.logger.error "Agent Error in #{controller_name}: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")

    interaction&.mark_failed!(error.message)

    flash[:error] = 'Sorry, there was an issue processing your request. Please try again.'
    redirect_back(fallback_location: root_path)
  end

  # Get agent configuration value
  def agent_config(key, default = nil)
    @agent&.configuration&.dig(key) || default
  end

  # Check if agent is active and available
  def ensure_agent_active
    return if @agent&.active?

    flash[:warning] = 'This agent is currently unavailable. Please try again later.'
    redirect_to root_path
  end

  # Store agent memory
  def store_memory(memory_type, memory_key, data, options = {})
    return unless @agent

    AgentMemory.store_memory(@agent, memory_type, memory_key, data, options)
  end

  # Retrieve agent memory
  def retrieve_memory(memory_type, memory_key)
    return unless @agent

    AgentMemory.retrieve_memory(@agent, memory_type, memory_key)&.memory_data
  end

  # Agent analytics helper
  def agent_analytics(date_range = nil)
    return {} unless @agent

    AgentInteraction.analytics_summary(@agent, date_range)
  end
end
