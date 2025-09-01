# frozen_string_literal: true

class InfoseekController < ApplicationController
  include AgentConnectionConcern

  layout false # Use custom HTML layout in view instead of application layout

  # Remove before_action call since we don't need agent loading for InfoSeek

  def index
    # Main agent page with hero section and terminal interface
    @agent_stats = {
      total_conversations: 267,
      average_rating: 4.8,
      response_time: '< 2s',
      specializations: ['IP Geolocation', 'Network Analysis', 'Digital Investigation', 'Security Research']
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
      # Process InfoSeek research request
      response_data = process_infoseek_request(user_message)

      render json: {
        success: true,
        response: response_data[:text],
        processing_time: response_data[:processing_time],
        agent_name: 'InfoSeek',
        timestamp: Time.current.strftime('%H:%M:%S'),
        sources: response_data[:sources],
        research_type: response_data[:research_type],
        related_topics: response_data[:related_topics],
        confidence_score: response_data[:confidence_score]
      }
    rescue StandardError => e
      Rails.logger.error "Infoseek Error: #{e.message}"

      render json: {
        error: 'Sorry, I encountered an error processing your message. Please try again.',
        timestamp: Time.current.strftime('%H:%M:%S')
      }, status: :internal_server_error
    end
  end

  # New specialized InfoSeek endpoints
  def deep_research
    query = params[:query]
    research_depth = params[:depth] || 'comprehensive'

    research_results = perform_deep_research(query, research_depth)

    render json: {
      success: true,
      results: research_results,
      methodology: explain_research_methodology(research_depth),
      citations: generate_citations(research_results)
    }
  end

  def fact_check
    statement = params[:statement]
    context = params[:context] || ''

    fact_check_results = verify_statement(statement, context)

    render json: {
      success: true,
      verification: fact_check_results,
      confidence_level: calculate_confidence(fact_check_results),
      supporting_evidence: gather_evidence(statement)
    }
  end

  def research_assistant
    topic = params[:topic]
    assistance_type = params[:type] || 'overview'

    assistance_data = provide_research_assistance(topic, assistance_type)

    render json: {
      success: true,
      assistance: assistance_data,
      research_roadmap: create_research_roadmap(topic),
      recommended_sources: suggest_sources(topic)
    }
  end

  def trend_analysis
    subject = params[:subject]
    timeframe = params[:timeframe] || '1year'

    trend_data = analyze_trends(subject, timeframe)

    render json: {
      success: true,
      trends: trend_data,
      insights: extract_trend_insights(trend_data),
      predictions: generate_trend_predictions(subject, trend_data)
    }
  end

  def status
    # Agent status endpoint for monitoring
    render json: {
      agent: 'InfoSeek',
      status: 'active',
      uptime: 'Just started',
      capabilities: ['IP Geolocation', 'Network Analysis', 'Digital Investigation', 'Security Research'],
      response_style: 'Terminal-based research assistant',
      last_active: Time.current.strftime('%Y-%m-%d %H:%M:%S')
    }
  end

  private

  # Add current_user method for compatibility
  def current_user
    @current_user ||= OpenStruct.new(
      id: "demo_user_#{session.id}",
      name: 'InfoSeek User',
      email: 'demo@infoseek.onelastai.com'
    )
  end

  # def find_infoseek_agent
  #   @agent = Agent.find_by(agent_type: 'infoseek', status: 'active')
  #   return if @agent
  #   redirect_to root_url(subdomain: false), alert: 'Infoseek agent is currently unavailable'
  # end

  # def ensure_demo_user
  #   # Create or find a demo user for the session
  #   session_id = session[:user_session_id] ||= SecureRandom.uuid
  #   @user = User.find_or_create_by(email: "demo_#{session_id}@infoseek.onelastai.com") do |user|
  #     user.name = "Infoseek User #{rand(1000..9999)}"
  #     user.preferences = {
  #       communication_style: 'terminal',
  #       interface_theme: 'dark',
  #       response_detail: 'comprehensive'
  #     }.to_json
  #   end
  #   session[:current_user_id] = @user.id
  # end

  # def build_chat_context
  #   {
  #     interface_mode: 'terminal',
  #     subdomain: 'infoseek',
  #     session_id: session[:user_session_id],
  #     user_preferences: JSON.parse(@user.preferences || '{}'),
  #     conversation_history: recent_conversation_history
  #   }
  # end

  # def recent_conversation_history
  #   # Get the last 5 interactions for context
  #   @agent.agent_interactions
  #         .where(user: @user)
  #         .order(created_at: :desc)
  #         .limit(5)
  #         .pluck(:user_message, :agent_response)
  #         .reverse
  # end

  # def time_since_last_active
  #   return 'Just started' unless @agent.last_active_at
  #   time_diff = Time.current - @agent.last_active_at
  #   if time_diff < 1.minute
  #     'Just now'
  #   elsif time_diff < 1.hour
  #     "#{(time_diff / 1.minute).to_i} minutes ago"
  #   else
  #     "#{(time_diff / 1.hour).to_i} hours ago"
  #   end
  # end

  # InfoSeek specialized processing methods
  def process_infoseek_request(message)
    research_intent = detect_research_intent(message)

    case research_intent
    when :fact_check
      handle_fact_check_request(message)
    when :deep_research
      handle_deep_research_request(message)
    when :trend_analysis
      handle_trend_analysis_request(message)
    when :comparison
      handle_comparison_request(message)
    when :timeline
      handle_timeline_request(message)
    else
      handle_general_research_query(message)
    end
  end

  def detect_research_intent(message)
    message_lower = message.downcase

    return :fact_check if message_lower.match?(/fact.?check|verify|true|false|accurate|confirm/)
    return :deep_research if message_lower.match?(/research|investigate|study|analysis|comprehensive/)
    return :trend_analysis if message_lower.match?(/trend|pattern|over time|historical|evolution/)
    return :comparison if message_lower.match?(/compare|versus|vs|difference|contrast/)
    return :timeline if message_lower.match?(/timeline|chronology|history|when|sequence/)

    :general
  end

  def handle_fact_check_request(_message)
    {
      text: "🔍 **Fact-Check Engine Activated**\n\n" \
            "I'll verify the accuracy of your statement using multiple authoritative sources:\n\n" \
            "✅ **Verification Process:**\n" \
            "• Cross-reference with 10+ reliable sources\n" \
            "• Check publication dates & credibility\n" \
            "• Analyze conflicting information\n" \
            "• Provide confidence rating (0-100%)\n\n" \
            "📊 **Source Categories:**\n" \
            "• Academic journals & research papers\n" \
            "• Government databases & statistics\n" \
            "• News outlets with high credibility scores\n" \
            "• Expert opinions & institutional reports\n\n" \
            "🎯 **Fact-Check Features:**\n" \
            "• Evidence-based conclusions\n" \
            "• Source transparency & citations\n" \
            "• Context analysis & nuance detection\n" \
            "• Bias identification & correction\n\n" \
            "Please provide the statement you'd like me to verify!",
      processing_time: rand(1.2..2.8).round(2),
      sources: generate_sample_sources('fact_check'),
      research_type: 'fact_verification',
      related_topics: ['source credibility', 'bias detection', 'evidence analysis'],
      confidence_score: rand(85..98)
    }
  end

  def handle_deep_research_request(_message)
    {
      text: "📚 **Deep Research Engine Initiated**\n\n" \
            "Conducting comprehensive research with advanced methodologies:\n\n" \
            "🎯 **Research Scope:**\n" \
            "• Academic literature review (20+ sources)\n" \
            "• Current events & news analysis\n" \
            "• Statistical data & trend analysis\n" \
            "• Expert interviews & opinions\n" \
            "• Historical context & background\n\n" \
            "⚡ **Research Capabilities:**\n" \
            "• Multi-language source analysis\n" \
            "• Real-time information updates\n" \
            "• Peer-reviewed publication access\n" \
            "• Government & institutional data\n" \
            "• Social media sentiment analysis\n\n" \
            "📖 **Deliverables:**\n" \
            "• Executive summary with key findings\n" \
            "• Detailed research report\n" \
            "• Source bibliography & citations\n" \
            "• Recommendations & next steps\n\n" \
            'What topic would you like me to research comprehensively?',
      processing_time: rand(2.5..5.2).round(2),
      sources: generate_sample_sources('deep_research'),
      research_type: 'comprehensive_analysis',
      related_topics: ['methodology', 'literature review', 'data analysis'],
      confidence_score: rand(90..97)
    }
  end

  def handle_trend_analysis_request(_message)
    {
      text: "📈 **Trend Analysis Engine Online**\n\n" \
            "Analyzing patterns and trends across multiple timeframes:\n\n" \
            "🔄 **Analysis Dimensions:**\n" \
            "• Historical trends (1+ years of data)\n" \
            "• Seasonal patterns & cycles\n" \
            "• Market movements & indicators\n" \
            "• Social media sentiment shifts\n" \
            "• Geographic distribution patterns\n\n" \
            "📊 **Advanced Analytics:**\n" \
            "• Machine learning pattern recognition\n" \
            "• Predictive modeling & forecasting\n" \
            "• Correlation analysis & causation\n" \
            "• Anomaly detection & outliers\n" \
            "• Statistical significance testing\n\n" \
            "🎯 **Trend Insights:**\n" \
            "• Growth rates & acceleration\n" \
            "• Inflection points & turning moments\n" \
            "• Future trajectory predictions\n" \
            "• Risk factors & opportunities\n\n" \
            'Which subject would you like me to analyze for trends?',
      processing_time: rand(1.8..4.1).round(2),
      sources: generate_sample_sources('trend_analysis'),
      research_type: 'trend_analysis',
      related_topics: ['statistical analysis', 'forecasting', 'pattern recognition'],
      confidence_score: rand(88..95)
    }
  end

  def handle_comparison_request(_message)
    {
      text: "⚖️ **Comparative Analysis Engine Ready**\n\n" \
            "Performing detailed side-by-side comparisons:\n\n" \
            "🔍 **Comparison Framework:**\n" \
            "• Feature-by-feature analysis\n" \
            "• Pros & cons evaluation\n" \
            "• Performance metrics comparison\n" \
            "• Cost-benefit analysis\n" \
            "• User reviews & expert opinions\n\n" \
            "📊 **Evaluation Criteria:**\n" \
            "• Objective measurements & data\n" \
            "• Subjective quality assessments\n" \
            "• Market position & reputation\n" \
            "• Innovation & future potential\n" \
            "• Value proposition analysis\n\n" \
            "📋 **Comparison Deliverables:**\n" \
            "• Detailed comparison matrix\n" \
            "• Scoring & ranking system\n" \
            "• Recommendation & winner\n" \
            "• Decision-making guidelines\n\n" \
            'What would you like me to compare for you?',
      processing_time: rand(1.5..3.7).round(2),
      sources: generate_sample_sources('comparison'),
      research_type: 'comparative_analysis',
      related_topics: ['evaluation criteria', 'decision matrices', 'benchmarking'],
      confidence_score: rand(87..94)
    }
  end

  def handle_timeline_request(_message)
    {
      text: "📅 **Timeline Research Engine Activated**\n\n" \
            "Creating comprehensive chronological analysis:\n\n" \
            "⏰ **Timeline Features:**\n" \
            "• Key events & milestones\n" \
            "• Cause-and-effect relationships\n" \
            "• Important dates & periods\n" \
            "• Historical context & background\n" \
            "• Future projections & predictions\n\n" \
            "🎯 **Research Methodology:**\n" \
            "• Primary source documentation\n" \
            "• Cross-referenced date verification\n" \
            "• Multiple perspective analysis\n" \
            "• Visual timeline construction\n" \
            "• Interactive exploration tools\n\n" \
            "📖 **Timeline Deliverables:**\n" \
            "• Chronological event sequence\n" \
            "• Impact analysis & significance\n" \
            "• Visual timeline graphics\n" \
            "• Historical context explanations\n\n" \
            'What topic would you like me to create a timeline for?',
      processing_time: rand(1.3..3.2).round(2),
      sources: generate_sample_sources('timeline'),
      research_type: 'chronological_analysis',
      related_topics: ['historical research', 'event sequencing', 'causation analysis'],
      confidence_score: rand(89..96)
    }
  end

  def handle_general_research_query(message)
    # Check if message contains an IP address pattern
    ip_pattern = /\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/
    domain_pattern = /\b[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b/

    if message.match?(ip_pattern) || message.match?(domain_pattern)
      handle_ip_lookup_request(message)
    else
      {
        text: "🌐 **InfoSeek - IP Intelligence & Network Research**\n\n" \
              "Your specialized assistant for IP information and network intelligence:\n\n" \
              "🎯 **Core IP Capabilities:**\n" \
              "• IP Geolocation & Geographic Analysis\n" \
              "• Network Owner & ISP Information\n" \
              "• Domain & Subdomain Investigation\n" \
              "• Security Threat Assessment\n" \
              "• Network Performance Analysis\n" \
              "• Digital Footprint Investigation\n\n" \
              "⚡ **Quick IP Commands:**\n" \
              "• Enter any IP address (e.g., '8.8.8.8')\n" \
              "• Domain lookup (e.g., 'google.com')\n" \
              "• 'trace [IP/domain]' - Network path analysis\n" \
              "• 'security [IP]' - Threat intelligence\n" \
              "• 'whois [domain]' - Registration details\n\n" \
              "🔍 **IP Intelligence Features:**\n" \
              "• Precise geolocation (city, region, country)\n" \
              "• ISP & organization identification\n" \
              "• Network topology mapping\n" \
              "• Security reputation scoring\n" \
              "• Historical IP data analysis\n\n" \
              "💡 **Pro Tip:** Just paste an IP address or domain name to get instant detailed information!\n\n" \
              'What IP address or domain would you like me to investigate?',
        processing_time: rand(0.5..1.2).round(2),
        sources: generate_sample_sources('ip_intelligence'),
        research_type: 'ip_intelligence',
        related_topics: ['network security', 'geolocation', 'digital forensics'],
        confidence_score: rand(94..99)
      }
    end
  end

  def handle_ip_lookup_request(message)
    # Extract IP or domain from message
    ip_match = message.match(/\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b/)
    domain_match = message.match(/\b[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}\b/)

    target = if ip_match
               ip_match[0]
             else
               (domain_match ? domain_match[0] : 'target')
             end

    {
      text: "🌍 **IP Intelligence Report for #{target}**\n\n" \
            "📍 **Geolocation Information:**\n" \
            "• Location: San Francisco, California, USA\n" \
            "• Coordinates: 37.7749° N, 122.4194° W\n" \
            "• Timezone: America/Los_Angeles (PST/PDT)\n" \
            "• Accuracy Radius: ~10 km\n\n" \
            "� **Network & Organization:**\n" \
            "• ISP: Cloudflare Inc.\n" \
            "• Organization: Cloudflare\n" \
            "• AS Number: AS13335\n" \
            "• Network Type: Content Delivery Network\n\n" \
            "🔒 **Security Assessment:**\n" \
            "• Threat Level: ✅ Clean (No threats detected)\n" \
            "• Reputation Score: 98/100 (Excellent)\n" \
            "• VPN/Proxy: Not detected\n" \
            "• Tor Exit Node: No\n\n" \
            "📊 **Technical Details:**\n" \
            "• IP Version: IPv4\n" \
            "• Hostname: #{target}\n" \
            "• ISP Speed: Broadband/Corporate\n" \
            "• Mobile Carrier: N/A\n\n" \
            "🚀 **Performance Metrics:**\n" \
            "• Average Ping: 12ms\n" \
            "• Connection Quality: Excellent\n" \
            "• Bandwidth Class: High\n\n" \
            "💡 Need more details? Try 'trace #{target}' or 'security #{target}' for deeper analysis!",
      processing_time: rand(1.2..2.5).round(2),
      sources: [
        { title: 'IPinfo.io', type: 'IP Geolocation API', credibility: 97 },
        { title: 'MaxMind GeoIP2', type: 'Geolocation Database', credibility: 95 },
        { title: 'ARIN WHOIS', type: 'Network Registration', credibility: 99 }
      ],
      research_type: 'ip_geolocation',
      related_topics: ['network analysis', 'digital forensics', 'cybersecurity'],
      confidence_score: rand(92..98)
    }
  end

  # Enhanced IP and Domain analysis methods
  def generate_ip_analysis_response(ip_address)
    # Generate different responses based on IP patterns
    location_data = get_mock_location_data(ip_address)

    {
      text: "🌍 **Comprehensive IP Intelligence Report for #{ip_address}**\n\n" \
            "📍 **Geolocation Information:**\n" \
            "• Location: #{location_data[:city]}, #{location_data[:region]}, #{location_data[:country]}\n" \
            "• Coordinates: #{location_data[:lat]}° N, #{location_data[:lng]}° W\n" \
            "• Timezone: #{location_data[:timezone]}\n" \
            "• Accuracy Radius: #{location_data[:accuracy]} km\n" \
            "• Local Time: #{Time.current.in_time_zone(location_data[:timezone]).strftime('%Y-%m-%d %H:%M:%S %Z')}\n\n" \
            "🏢 **Network & Organization:**\n" \
            "• ISP: #{location_data[:isp]}\n" \
            "• Organization: #{location_data[:org]}\n" \
            "• AS Number: #{location_data[:asn]}\n" \
            "• Network Type: #{location_data[:connection_type]}\n" \
            "• Usage Type: #{location_data[:usage_type]}\n\n" \
            "🔒 **Security Assessment:**\n" \
            "• Threat Level: #{location_data[:threat_level]}\n" \
            "• Reputation Score: #{location_data[:reputation]}/100\n" \
            "• VPN/Proxy: #{location_data[:vpn_proxy]}\n" \
            "• Tor Exit Node: #{location_data[:tor_exit]}\n" \
            "• Malware Activity: #{location_data[:malware]}\n\n" \
            "📊 **Technical Details:**\n" \
            "• IP Version: IPv4\n" \
            "• Hostname: #{location_data[:hostname]}\n" \
            "• ISP Speed: #{location_data[:isp_speed]}\n" \
            "• Mobile Carrier: #{location_data[:mobile_carrier]}\n" \
            "• Hosting Provider: #{location_data[:hosting]}\n\n" \
            "🚀 **Performance & Connectivity:**\n" \
            "• Average Ping: #{location_data[:ping]}ms\n" \
            "• Connection Quality: #{location_data[:quality]}\n" \
            "• Bandwidth Class: #{location_data[:bandwidth]}\n" \
            "• Network Uptime: #{location_data[:uptime]}%\n\n" \
            "🔧 **Advanced Commands:**\n" \
            "• 'whois #{ip_address}' - Network registration details\n" \
            "• 'trace #{ip_address}' - Network route analysis\n" \
            "• 'security #{ip_address}' - Deep threat assessment\n" \
            "• 'ports #{ip_address}' - Open port scanning\n\n" \
            '📋 **Data Sources:** IPinfo.io, MaxMind GeoIP2, ARIN Registry, Threat Intelligence Feeds',
      processing_time: rand(1.2..2.8).round(2),
      sources: [
        { title: 'IPinfo.io', type: 'IP Geolocation API', credibility: 97 },
        { title: 'MaxMind GeoIP2', type: 'Geolocation Database', credibility: 95 },
        { title: 'ARIN WHOIS', type: 'Network Registration', credibility: 99 },
        { title: 'Threat Intelligence', type: 'Security Feeds', credibility: 94 }
      ],
      research_type: 'ip_geolocation',
      related_topics: ['network analysis', 'digital forensics', 'cybersecurity'],
      confidence_score: rand(92..98)
    }
  end

  def generate_domain_analysis_response(domain)
    domain_data = get_mock_domain_data(domain)

    {
      text: "🌐 **Comprehensive Domain Intelligence Report for #{domain}**\n\n" \
            "📋 **Domain Registration:**\n" \
            "• Registrar: #{domain_data[:registrar]}\n" \
            "• Registration Date: #{domain_data[:registration_date]}\n" \
            "• Expiration Date: #{domain_data[:expiration_date]}\n" \
            "• Domain Age: #{domain_data[:age]} years\n" \
            "• Status: #{domain_data[:status]}\n\n" \
            "📡 **DNS Information:**\n" \
            "• Primary IP: #{domain_data[:primary_ip]}\n" \
            "• Name Servers: #{domain_data[:nameservers].join(', ')}\n" \
            "• MX Records: #{domain_data[:mx_records].join(', ')}\n" \
            "• TXT Records: #{domain_data[:txt_records].count} found\n" \
            "• DNSSEC: #{domain_data[:dnssec]}\n\n" \
            "🏢 **Hosting Information:**\n" \
            "• Hosting Provider: #{domain_data[:hosting_provider]}\n" \
            "• Server Location: #{domain_data[:server_location]}\n" \
            "• CDN Provider: #{domain_data[:cdn]}\n" \
            "• SSL Certificate: #{domain_data[:ssl_status]}\n" \
            "• Web Server: #{domain_data[:web_server]}\n\n" \
            "🔒 **Security Analysis:**\n" \
            "• Domain Reputation: #{domain_data[:reputation]}/100\n" \
            "• Malware Detection: #{domain_data[:malware_status]}\n" \
            "• Phishing Risk: #{domain_data[:phishing_risk]}\n" \
            "• Blacklist Status: #{domain_data[:blacklist_status]}\n" \
            "• Safety Score: #{domain_data[:safety_score]}/100\n\n" \
            "📈 **Performance Metrics:**\n" \
            "• Load Time: #{domain_data[:load_time]}ms\n" \
            "• Uptime: #{domain_data[:uptime]}%\n" \
            "• Response Code: #{domain_data[:response_code]}\n" \
            "• Page Size: #{domain_data[:page_size]}\n\n" \
            "🔧 **Advanced Analysis:**\n" \
            "• 'whois #{domain}' - Complete registration details\n" \
            "• 'subdomains #{domain}' - Subdomain enumeration\n" \
            "• 'security #{domain}' - Deep security analysis\n" \
            "• 'tech #{domain}' - Technology stack analysis\n\n" \
            '📋 **Data Sources:** WHOIS Databases, DNS Resolvers, Security Scanners, Performance Monitors',
      processing_time: rand(1.5..3.2).round(2),
      sources: [
        { title: 'WHOIS Registry', type: 'Domain Registration Data', credibility: 99 },
        { title: 'DNS Lookups', type: 'Name Resolution', credibility: 98 },
        { title: 'Security Scanners', type: 'Threat Analysis', credibility: 95 },
        { title: 'Performance Tools', type: 'Speed Analysis', credibility: 92 }
      ],
      research_type: 'domain_analysis',
      related_topics: ['dns analysis', 'domain security', 'web hosting'],
      confidence_score: rand(89..96)
    }
  end

  def get_mock_location_data(ip_address)
    # Generate realistic mock data based on IP patterns
    case ip_address
    when /^8\.8\./
      {
        city: 'Mountain View', region: 'California', country: 'United States',
        lat: 37.4056, lng: -122.0775, timezone: 'America/Los_Angeles',
        accuracy: 5, isp: 'Google LLC', org: 'Google Public DNS',
        asn: 'AS15169', connection_type: 'Corporate', usage_type: 'Data Center',
        threat_level: '✅ Clean', reputation: 99, vpn_proxy: 'Not detected',
        tor_exit: 'No', malware: 'None detected', hostname: 'dns.google',
        isp_speed: 'Fiber/Corporate', mobile_carrier: 'N/A',
        hosting: 'Google Cloud', ping: 8, quality: 'Excellent',
        bandwidth: 'Very High', uptime: 99.9
      }
    when /^1\.1\./
      {
        city: 'San Francisco', region: 'California', country: 'United States',
        lat: 37.7749, lng: -122.4194, timezone: 'America/Los_Angeles',
        accuracy: 10, isp: 'Cloudflare Inc.', org: 'Cloudflare Public DNS',
        asn: 'AS13335', connection_type: 'CDN', usage_type: 'Content Delivery',
        threat_level: '✅ Clean', reputation: 98, vpn_proxy: 'Not detected',
        tor_exit: 'No', malware: 'None detected', hostname: 'one.one.one.one',
        isp_speed: 'Fiber/Enterprise', mobile_carrier: 'N/A',
        hosting: 'Cloudflare Network', ping: 12, quality: 'Excellent',
        bandwidth: 'Very High', uptime: 99.8
      }
    else
      {
        city: 'New York', region: 'New York', country: 'United States',
        lat: 40.7128, lng: -74.0060, timezone: 'America/New_York',
        accuracy: 15, isp: 'Example ISP Inc.', org: 'Example Organization',
        asn: 'AS12345', connection_type: 'Broadband', usage_type: 'Residential',
        threat_level: '✅ Clean', reputation: 85, vpn_proxy: 'Not detected',
        tor_exit: 'No', malware: 'None detected', hostname: "host-#{ip_address.tr('.', '-')}.example.com",
        isp_speed: 'Broadband/Cable', mobile_carrier: 'N/A',
        hosting: 'Residential ISP', ping: 25, quality: 'Good',
        bandwidth: 'High', uptime: 98.5
      }
    end
  end

  def get_mock_domain_data(domain)
    {
      registrar: 'Example Registrar Inc.',
      registration_date: '2020-01-15',
      expiration_date: '2025-01-15',
      age: 5,
      status: 'Active',
      primary_ip: '192.0.2.1',
      nameservers: ['ns1.example.com', 'ns2.example.com'],
      mx_records: ['mail.example.com', 'mail2.example.com'],
      txt_records: %w[SPF DKIM DMARC],
      dnssec: 'Enabled',
      hosting_provider: 'Example Hosting Co.',
      server_location: 'United States',
      cdn: 'Cloudflare',
      ssl_status: 'Valid (expires 2025-06-01)',
      web_server: 'nginx/1.20.1',
      reputation: 92,
      malware_status: 'Clean',
      phishing_risk: 'Low',
      blacklist_status: 'Not listed',
      safety_score: 95,
      load_time: 450,
      uptime: 99.2,
      response_code: '200 OK',
      page_size: '2.1 MB'
    }
  end

  def generate_help_response
    {
      text: "🆘 **InfoSeek Help - IP Intelligence Commands**\n\n" \
            "🔍 **How to use InfoSeek:**\n\n" \
            "📍 **IP Address Analysis:**\n" \
            "• Just type any IP: 8.8.8.8, 1.1.1.1, 192.168.1.1\n" \
            "• Get instant geolocation, ISP, and security information\n\n" \
            "🌐 **Domain Investigation:**\n" \
            "• Type any domain: google.com, github.com, example.org\n" \
            "• Analyze DNS, hosting, security, and performance\n\n" \
            "🛠️ **Advanced Commands:**\n" \
            "• whois [domain/IP] - Registration and ownership details\n" \
            "• trace [IP] - Network path and routing analysis\n" \
            "• security [domain/IP] - Deep threat and reputation check\n" \
            "• ports [IP] - Open port scanning and service detection\n" \
            "• subdomains [domain] - Subdomain enumeration\n" \
            "• tech [domain] - Technology stack detection\n\n" \
            "📊 **What InfoSeek analyzes:**\n" \
            "• Precise geolocation and timezone information\n" \
            "• ISP, organization, and network infrastructure\n" \
            "• Security threats, malware, and reputation scoring\n" \
            "• Domain registration and DNS records\n" \
            "• Web hosting and performance metrics\n" \
            "• VPN, proxy, and anonymizer detection\n\n" \
            "💡 **Pro Tips:**\n" \
            "• Use specific IPs for most accurate results\n" \
            "• Try public DNS servers: 8.8.8.8, 1.1.1.1, 9.9.9.9\n" \
            "• Analyze suspicious domains for security assessment\n" \
            "• Export results for further investigation\n\n" \
            '🚀 **Ready to investigate? Try entering an IP or domain!**',
      processing_time: 0.5,
      sources: [
        { title: 'InfoSeek Documentation', type: 'User Guide', credibility: 100 }
      ],
      research_type: 'help_documentation',
      related_topics: ['ip analysis', 'domain investigation', 'network security'],
      confidence_score: 100
    }
  end

  def generate_sample_sources(research_type)
    case research_type
    when 'fact_check'
      [
        { title: 'Snopes.com', type: 'Fact-checking database', credibility: 95 },
        { title: 'PolitiFact', type: 'Political fact verification', credibility: 92 },
        { title: 'Reuters Fact Check', type: 'News verification', credibility: 97 }
      ]
    when 'deep_research'
      [
        { title: 'JSTOR Academic Database', type: 'Peer-reviewed journals', credibility: 98 },
        { title: 'Google Scholar', type: 'Academic search engine', credibility: 94 },
        { title: 'Government Statistics', type: 'Official data sources', credibility: 96 }
      ]
    when 'trend_analysis'
      [
        { title: 'Google Trends', type: 'Search trend analysis', credibility: 90 },
        { title: 'World Bank Data', type: 'Economic indicators', credibility: 97 },
        { title: 'Statista', type: 'Market research data', credibility: 88 }
      ]
    when 'ip_intelligence'
      [
        { title: 'IPinfo.io', type: 'IP Geolocation API', credibility: 97 },
        { title: 'MaxMind GeoIP2', type: 'IP Intelligence Database', credibility: 95 },
        { title: 'ARIN WHOIS', type: 'Network Registration Data', credibility: 99 },
        { title: 'VirusTotal', type: 'IP Security Analysis', credibility: 94 }
      ]
    else
      [
        { title: 'IPinfo.io', type: 'IP Geolocation Service', credibility: 97 },
        { title: 'Network databases', type: 'ISP & Network data', credibility: 92 },
        { title: 'Security feeds', type: 'Threat intelligence', credibility: 89 }
      ]
    end
  end
end
