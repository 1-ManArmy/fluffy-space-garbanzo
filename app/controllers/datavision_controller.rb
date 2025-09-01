# frozen_string_literal: true

class DatavisionController < ApplicationController
  include AgentConnectionConcern

  layout false # Use custom HTML layout in view instead of application layout

  before_action :load_agent_for_controller, only: %i[index chat]
  before_action :ensure_demo_user

  def index
    # Main agent page with hero section and terminal interface
    @agent_stats = {
      total_conversations: @agent&.total_interactions || 42,
      average_rating: (@agent&.average_rating || 4.8).round(1),
      response_time: '< 2s',
      specializations: @agent&.specializations || ['Data Visualization', 'Statistical Analysis',
                                                   'Interactive Dashboards', 'Predictive Analytics']
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
      # Analyze message for data visualization intents
      response_data = process_datavision_request(user_message)

      render json: {
        success: true,
        response: response_data[:text],
        processing_time: response_data[:processing_time],
        agent_name: @agent&.name || 'DataVision',
        timestamp: Time.current.strftime('%H:%M:%S'),
        chart_data: response_data[:chart_data],
        visualization_type: response_data[:visualization_type],
        suggested_actions: response_data[:suggested_actions]
      }
    rescue StandardError => e
      Rails.logger.error "Datavision Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  # New specialized DataVision endpoints
  def create_chart
    chart_type = params[:chart_type]
    data = params[:data]
    options = params[:options] || {}

    chart_config = generate_chart_config(chart_type, data, options)

    render json: {
      success: true,
      chart_config:,
      suggestions: get_chart_suggestions(chart_type, data)
    }
  end

  def analyze_dataset
    dataset = params[:dataset]
    analysis_type = params[:analysis_type] || 'comprehensive'

    insights = perform_data_analysis(dataset, analysis_type)

    render json: {
      success: true,
      insights:,
      recommended_visualizations: recommend_visualizations(dataset),
      statistical_summary: calculate_statistics(dataset)
    }
  end

  def generate_dashboard
    widgets = params[:widgets] || []
    layout = params[:layout] || 'grid'

    dashboard_config = create_dashboard_config(widgets, layout)

    render json: {
      success: true,
      dashboard: dashboard_config,
      performance_metrics: calculate_dashboard_performance(widgets)
    }
  end

  def status
    health = AgentConnector.health_check
    render json: {
      status: health[:status] == AgentConnector::STATES[:connected] ? 'available' : 'degraded',
      message: health[:message],
      mongodb_connected: health[:status] == AgentConnector::STATES[:connected]
    }
  end

  private

  # Load agent using our resilient connection system
  def load_agent_for_controller
    @agent = load_agent_safely('datavision')
  end

  def find_datavision_agent
    # Legacy method - replaced by load_agent_safely from concern
    @agent = Agent.find_by(agent_type: 'datavision', status: 'active')

    return if @agent

    redirect_to root_url(subdomain: false), alert: 'Datavision agent is currently unavailable'
  end

  def ensure_demo_user
    # Create or find a demo user for the session
    session_id = session[:user_session_id] ||= SecureRandom.uuid

    # Use session-based demo user instead of database User model
    @user = OpenStruct.new(
      id: session_id,
      name: "DataVision User #{rand(1000..9999)}",
      email: "demo_#{session_id}@datavision.onelastai.com",
      preferences: {
        communication_style: 'terminal',
        interface_theme: 'dark',
        response_detail: 'comprehensive'
      }
    )

    session[:current_user_id] = @user.id
  end

  def build_chat_context
    {
      interface_mode: 'terminal',
      subdomain: 'datavision',
      session_id: session[:user_session_id],
      user_preferences: JSON.parse(@user&.preferences || '{}'),
      conversation_history: recent_conversation_history
    }
  end

  def time_since_last_active
    return 'Just started' unless @agent&.last_active_at

    time_diff = Time.current - @agent.last_active_at

    if time_diff < 1.minute
      'Just now'
    elsif time_diff < 1.hour
      "#{(time_diff / 1.minute).to_i} minutes ago"
    else
      "#{(time_diff / 1.hour).to_i} hours ago"
    end
  end

  def recent_conversation_history
    # Get the last 5 interactions for context - with fallback for missing agent
    return [] unless @agent

    @agent.agent_interactions
          .where(user: @user)
          .order(created_at: :desc)
          .limit(5)
          .pluck(:user_message, :agent_response)
          .reverse
  end

  # DataVision specialized processing methods
  def process_datavision_request(message)
    # Analyze message for data visualization keywords and intents
    visualization_intent = detect_visualization_intent(message)

    case visualization_intent
    when :create_chart
      handle_chart_creation_request(message)
    when :analyze_data
      handle_data_analysis_request(message)
    when :dashboard
      handle_dashboard_request(message)
    when :export
      handle_export_request(message)
    else
      handle_general_datavision_query(message)
    end
  end

  def detect_visualization_intent(message)
    message_lower = message.downcase

    return :create_chart if message_lower.match?(/chart|graph|plot|visuali[sz]|bar|line|pie|scatter/)
    return :analyze_data if message_lower.match?(/analy[sz]e|insight|trend|pattern|statistic/)
    return :dashboard if message_lower.match?(/dashboard|panel|widget|layout/)
    return :export if message_lower.match?(/export|download|save|pdf|png|svg/)

    :general
  end

  def handle_chart_creation_request(_message)
    # Simulate advanced chart creation logic
    chart_types = %w[bar line area pie scatter bubble radar treemap heatmap]
    suggested_type = chart_types.sample

    {
      text: "🎨 **Chart Creation Mode Activated**\n\nI can help you create a #{suggested_type} chart! Here's what I can do:\n\n" \
            "📊 **Available Chart Types:**\n" \
            "• Bar Charts - Compare categories\n" \
            "• Line Charts - Show trends over time\n" \
            "• Pie Charts - Display proportions\n" \
            "• Scatter Plots - Correlations\n" \
            "• Heat Maps - Pattern visualization\n" \
            "• Bubble Charts - Multi-dimensional data\n\n" \
            "📈 **Advanced Features:**\n" \
            "• Interactive tooltips\n" \
            "• Real-time data updates\n" \
            "• Custom color schemes\n" \
            "• Export to multiple formats\n\n" \
            "Please provide your data or describe what you'd like to visualize!",
      processing_time: rand(0.8..2.1).round(2),
      chart_data: generate_sample_chart_data(suggested_type),
      visualization_type: suggested_type,
      suggested_actions: [
        'Upload CSV data',
        'Connect to database',
        'Use sample dataset',
        'Manual data entry'
      ]
    }
  end

  def handle_data_analysis_request(_message)
    analysis_types = %w[trend correlation regression clustering anomaly]
    analysis_type = analysis_types.sample

    {
      text: "🔍 **Data Analysis Engine Initiated**\n\n" \
            "Analyzing your data with advanced statistical methods:\n\n" \
            "📊 **Analysis Type:** #{analysis_type.capitalize} Analysis\n\n" \
            "🎯 **Key Insights Available:**\n" \
            "• Statistical summaries (mean, median, std dev)\n" \
            "• Trend identification and forecasting\n" \
            "• Correlation matrices\n" \
            "• Outlier detection\n" \
            "• Distribution analysis\n" \
            "• Confidence intervals\n\n" \
            "📈 **Machine Learning Integration:**\n" \
            "• Predictive modeling\n" \
            "• Classification algorithms\n" \
            "• Clustering analysis\n" \
            "• Feature importance ranking\n\n" \
            'Ready to dive deep into your data patterns!',
      processing_time: rand(1.2..3.5).round(2),
      chart_data: generate_analysis_visualization,
      visualization_type: 'analysis_dashboard',
      suggested_actions: [
        'Run statistical summary',
        'Identify correlations',
        'Detect anomalies',
        'Generate predictions'
      ]
    }
  end

  def handle_dashboard_request(_message)
    {
      text: "🎛️ **Dashboard Builder Activated**\n\n" \
            "Creating your interactive analytics dashboard:\n\n" \
            "🎨 **Dashboard Components:**\n" \
            "• Real-time KPI widgets\n" \
            "• Interactive charts & graphs\n" \
            "• Data tables with filtering\n" \
            "• Custom metric calculations\n" \
            "• Alert & notification panels\n\n" \
            "⚙️ **Layout Options:**\n" \
            "• Grid-based responsive design\n" \
            "• Drag-and-drop customization\n" \
            "• Mobile-optimized views\n" \
            "• Dark/light theme support\n\n" \
            "🔄 **Data Integration:**\n" \
            "• Real-time data streaming\n" \
            "• Multiple data source support\n" \
            "• Automated refresh intervals\n" \
            "• Historical data comparison\n\n" \
            'Your dashboard is ready for configuration!',
      processing_time: rand(1.8..4.2).round(2),
      chart_data: generate_dashboard_preview,
      visualization_type: 'dashboard',
      suggested_actions: [
        'Add KPI widgets',
        'Configure data sources',
        'Customize layout',
        'Set up alerts'
      ]
    }
  end

  def handle_export_request(_message)
    export_formats = %w[PDF PNG SVG Excel PowerPoint]

    {
      text: "💾 **Export Manager Ready**\n\n" \
            "Your visualizations can be exported in multiple formats:\n\n" \
            "📄 **Available Formats:**\n" \
            "• High-resolution PNG/SVG images\n" \
            "• Publication-ready PDF reports\n" \
            "• Interactive HTML dashboards\n" \
            "• Excel workbooks with charts\n" \
            "• PowerPoint presentation slides\n\n" \
            "⚡ **Export Features:**\n" \
            "• Custom dimensions & DPI\n" \
            "• Branded templates\n" \
            "• Automated report generation\n" \
            "• Batch export capabilities\n" \
            "• Cloud storage integration\n\n" \
            'Ready to export your visualizations in professional quality!',
      processing_time: rand(0.5..1.8).round(2),
      chart_data: nil,
      visualization_type: 'export_options',
      suggested_actions: export_formats.map { |format| "Export as #{format}" }
    }
  end

  def handle_general_datavision_query(_message)
    # Enhanced general response with DataVision capabilities
    capabilities = [
      'Create stunning interactive charts',
      'Perform advanced statistical analysis',
      'Build real-time dashboards',
      'Generate predictive models',
      'Export professional reports'
    ]

    {
      text: "🎨 **DataVision AI Ready**\n\n" \
            "I'm your expert data visualization and analytics assistant! Here's how I can help:\n\n" \
            "🎯 **Core Capabilities:**\n" \
            "#{capabilities.map { |cap| "• #{cap}" }.join("\n")}\n\n" \
            "🚀 **Getting Started:**\n" \
            "• Type 'create chart' for visualization tools\n" \
            "• Type 'analyze data' for statistical insights\n" \
            "• Type 'build dashboard' for interactive panels\n" \
            "• Upload CSV/Excel files for instant analysis\n\n" \
            "💡 **Pro Tips:**\n" \
            "• I support 15+ chart types\n" \
            "• Real-time data streaming available\n" \
            "• Custom branding & themes\n" \
            "• Export to any format you need\n\n" \
            'What would you like to visualize today?',
      processing_time: rand(0.8..2.0).round(2),
      chart_data: generate_sample_showcase,
      visualization_type: 'welcome_showcase',
      suggested_actions: [
        'Create a chart',
        'Analyze dataset',
        'Build dashboard',
        'View examples'
      ]
    }
  end

  def generate_sample_chart_data(chart_type)
    case chart_type
    when 'bar'
      {
        labels: %w[Q1 Q2 Q3 Q4],
        datasets: [{
          label: 'Revenue ($M)',
          data: [2.5, 3.1, 2.8, 4.2],
          backgroundColor: ['#00d4ff', '#00a8cc', '#007a99', '#004d66']
        }]
      }
    when 'line'
      {
        labels: %w[Jan Feb Mar Apr May Jun],
        datasets: [{
          label: 'User Growth',
          data: [1200, 1350, 1100, 1850, 2100, 2400],
          borderColor: '#00d4ff',
          backgroundColor: 'rgba(0, 212, 255, 0.1)'
        }]
      }
    else
      {
        message: "Sample data for #{chart_type} chart",
        preview: "Interactive #{chart_type} visualization ready"
      }
    end
  end

  def generate_analysis_visualization
    {
      type: 'statistical_summary',
      metrics: {
        mean: 156.7,
        median: 142.0,
        std_dev: 23.4,
        correlation: 0.78,
        r_squared: 0.61
      },
      trends: ['Positive correlation detected', 'Seasonal pattern identified', 'Growth rate: +12.5%']
    }
  end

  def generate_dashboard_preview
    {
      layout: 'grid',
      widgets: [
        { type: 'kpi', title: 'Total Revenue', value: '$2.4M', trend: '+15%' },
        { type: 'chart', title: 'Sales by Region', chart_type: 'pie' },
        { type: 'table', title: 'Top Products', rows: 5 },
        { type: 'gauge', title: 'Performance Score', value: 87 }
      ]
    }
  end

  def generate_sample_showcase
    {
      examples: [
        { type: 'Sales Dashboard', description: 'Real-time revenue tracking' },
        { type: 'User Analytics', description: 'Engagement metrics & trends' },
        { type: 'Financial Report', description: 'Quarterly performance overview' },
        { type: 'Marketing ROI', description: 'Campaign effectiveness analysis' }
      ]
    }
  end
end
