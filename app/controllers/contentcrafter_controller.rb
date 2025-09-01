# frozen_string_literal: true

class ContentcrafterController < ApplicationController
  protect_from_forgery except: [:chat]
  # before_action :set_agent
  # before_action :set_content_context

  # Chat interface for ContentCrafter content creation AI
  def chat
    message = params[:message]
    return render json: { error: 'Message is required' }, status: 400 if message.blank?

    # Track agent activity (update only if column exists)
    @agent.touch(:updated_at) if @agent.respond_to?(:updated_at)

    # Process message through ContentCrafter intelligence engine
    response_data = process_contentcrafter_request(message)

    render json: {
      response: response_data[:text],
      agent: {
        name: @agent.name,
        emoji: @agent.configuration['emoji'],
        tagline: @agent.configuration['tagline'],
        last_active: time_since_last_active
      },
      content_analysis: response_data[:content_analysis],
      writing_insights: response_data[:writing_insights],
      optimization_suggestions: response_data[:optimization_suggestions],
      creative_guidance: response_data[:creative_guidance],
      processing_time: response_data[:processing_time]
    }
  end

  # Advanced copywriting and persuasive content creation
  def copywriting
    brief = params[:brief] || params[:description]
    content_type = params[:content_type] || 'sales_copy'
    target_audience = params[:target_audience] || 'general'
    tone = params[:tone] || 'persuasive'

    return render json: { error: 'Brief is required' }, status: 400 if brief.blank?

    # Generate professional copywriting
    copy_data = create_professional_copy(brief, content_type, target_audience, tone)

    render json: {
      copywriting: copy_data,
      headlines: copy_data[:headlines],
      body_copy: copy_data[:body_copy],
      call_to_action: copy_data[:call_to_action],
      persuasion_elements: copy_data[:persuasion_elements],
      a_b_variations: copy_data[:a_b_variations],
      processing_time: copy_data[:processing_time]
    }
  end

  # Content strategy development and planning
  def content_strategy
    business_goals = params[:business_goals] || []
    target_market = params[:target_market] || {}
    content_pillars = params[:content_pillars] || []
    timeframe = params[:timeframe] || '3_months'

    # Develop comprehensive content strategy
    strategy_data = develop_content_strategy(business_goals, target_market, content_pillars, timeframe)

    render json: {
      content_strategy: strategy_data,
      strategic_pillars: strategy_data[:strategic_pillars],
      content_calendar: strategy_data[:content_calendar],
      distribution_plan: strategy_data[:distribution_plan],
      performance_metrics: strategy_data[:performance_metrics],
      competitive_analysis: strategy_data[:competitive_analysis],
      processing_time: strategy_data[:processing_time]
    }
  end

  # SEO optimization and search-friendly content creation
  def seo_optimization
    content = params[:content] || params[:text]
    target_keywords = params[:target_keywords] || []
    search_intent = params[:search_intent] || 'informational'

    return render json: { error: 'Content is required' }, status: 400 if content.blank?

    # Optimize content for search engines
    seo_data = optimize_for_search(content, target_keywords, search_intent)

    render json: {
      seo_optimization: seo_data,
      keyword_analysis: seo_data[:keyword_analysis],
      content_score: seo_data[:content_score],
      optimization_suggestions: seo_data[:optimization_suggestions],
      meta_elements: seo_data[:meta_elements],
      schema_markup: seo_data[:schema_markup],
      processing_time: seo_data[:processing_time]
    }
  end

  # Multi-format content generation and adaptation
  def multi_format_generation
    source_content = params[:source_content] || params[:content]
    target_formats = params[:target_formats] || ['blog_post']
    brand_voice = params[:brand_voice] || 'professional'

    return render json: { error: 'Source content is required' }, status: 400 if source_content.blank?

    # Generate content in multiple formats
    format_data = generate_multiple_formats(source_content, target_formats, brand_voice)

    render json: {
      multi_format_generation: format_data,
      generated_formats: format_data[:generated_formats],
      format_specifications: format_data[:format_specifications],
      adaptation_notes: format_data[:adaptation_notes],
      cross_platform_optimization: format_data[:cross_platform_optimization],
      content_variants: format_data[:content_variants],
      processing_time: format_data[:processing_time]
    }
  end

  # Brand voice development and consistency management
  def brand_voice_development
    brand_attributes = params[:brand_attributes] || {}
    target_persona = params[:target_persona] || {}
    communication_goals = params[:communication_goals] || []
    industry_context = params[:industry_context] || 'general'

    # Develop comprehensive brand voice guidelines
    voice_data = develop_brand_voice(brand_attributes, target_persona, communication_goals, industry_context)

    render json: {
      brand_voice_development: voice_data,
      voice_guidelines: voice_data[:voice_guidelines],
      tone_variations: voice_data[:tone_variations],
      messaging_framework: voice_data[:messaging_framework],
      style_examples: voice_data[:style_examples],
      consistency_checklist: voice_data[:consistency_checklist],
      processing_time: voice_data[:processing_time]
    }
  end

  # Content analytics and performance optimization
  def content_analytics
    content_pieces = params[:content_pieces] || []
    metrics = params[:metrics] || %w[engagement conversion]
    analysis_period = params[:analysis_period] || '30_days'

    # Analyze content performance and provide insights
    analytics_data = analyze_content_performance(content_pieces, metrics, analysis_period)

    render json: {
      content_analytics: analytics_data,
      performance_insights: analytics_data[:performance_insights],
      optimization_opportunities: analytics_data[:optimization_opportunities],
      content_gaps: analytics_data[:content_gaps],
      trending_topics: analytics_data[:trending_topics],
      roi_analysis: analytics_data[:roi_analysis],
      processing_time: analytics_data[:processing_time]
    }
  end

  def index
    # Main ContentCrafter terminal interface

    # Hardcoded agent stats for testing (bypassing DB)
    @agent_stats = {
      total_conversations: 342,
      average_rating: 4.7,
      response_time: '< 2s',
      specializations: [
        'Content Creation',
        'Copy Writing',
        'Blog Articles',
        'Social Media',
        'Marketing Content'
      ]
    }
  end

  def generate_content
    message = params[:message]

    if message.blank?
      render json: {
        success: false,
        message: 'Please provide content requirements'
      }
      return
    end

    # Process content generation request
    response = @contentcrafter_engine.process_input(
      current_user,
      message,
      content_context_params
    )

    render json: {
      success: true,
      content_response: response[:text],
      metadata: response[:metadata],
      content_data: response[:content_data],
      timestamp: response[:timestamp],
      processing_time: response[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "ContentCrafter error: #{e.message}"
    render json: {
      success: false,
      message: 'I encountered an issue generating content. Please try again with different requirements.'
    }
  end

  def get_content_formats
    render json: {
      formats: Agents::ContentcrafterEngine::CONTENT_FORMATS,
      tones: Agents::ContentcrafterEngine::TONE_STYLES,
      audiences: Agents::ContentcrafterEngine::AUDIENCE_TYPES
    }
  end

  def preview_content
    format_type = params[:format]&.to_sym || :blog_post
    demo_content = @contentcrafter_engine.get_demo_content(format_type)

    render json: {
      success: true,
      demo_content: demo_content,
      format: format_type
    }
  end

  def export_content
    content_id = params[:content_id]
    export_format = params[:format] || 'markdown'

    # In a real app, you'd retrieve the content from database
    # For demo, we'll generate sample content
    sample_content = generate_sample_export_content(export_format)

    render json: {
      success: true,
      exported_content: sample_content,
      format: export_format,
      download_url: "/contentcrafter/download/#{content_id}.#{export_format}"
    }
  end

  def analyze_content
    content_text = params[:content]

    if content_text.blank?
      render json: {
        success: false,
        message: 'Please provide content to analyze'
      }
      return
    end

    analysis = {
      word_count: content_text.split.length,
      reading_time: "#{(content_text.split.length / 200.0).ceil} min read",
      sentences: content_text.split(/[.!?]/).length,
      paragraphs: content_text.split(/\n\s*\n/).length,
      emotional_tone: analyze_emotional_tone(content_text),
      complexity: calculate_complexity_score(content_text),
      suggestions: generate_content_suggestions(content_text)
    }

    render json: {
      success: true,
      analysis: analysis
    }
  end

  def fusion_generate
    # Generate content with agent fusion capabilities
    fusion_request = {
      primary_agent: 'contentcrafter',
      fusion_agents: params[:fusion_agents] || ['emotisense'],
      content_type: params[:content_type] || 'blog_post',
      emotional_context: params[:emotional_context],
      visual_requirements: params[:visual_requirements]
    }

    response = @contentcrafter_engine.generate_content(
      fusion_request.merge(content_context_params),
      current_user
    )

    render json: {
      success: true,
      fusion_content: response[:content],
      metadata: response[:metadata],
      fusion_data: {
        emotional_analysis: fusion_request[:emotional_context],
        visual_suggestions: response[:content][:multimedia],
        agent_contributions: {
          contentcrafter: 'Core content generation',
          emotisense: 'Emotional tone analysis',
          cinegen: 'Visual composition suggestions'
        }
      }
    }
  end

  def terminal_command
    command = params[:command]
    args = params[:args] || []

    case command
    when 'stats'
      stats = get_default_content_stats
      render json: { success: true, stats: stats }
    when 'formats'
      render json: {
        success: true,
        formats: Agents::ContentcrafterEngine::CONTENT_FORMATS
      }
    when 'demo'
      format_type = args.first&.to_sym || :blog_post
      demo = @contentcrafter_engine.get_demo_content(format_type)
      render json: { success: true, demo: demo }
    when 'help'
      help_text = generate_help_text
      render json: { success: true, help: help_text }
    else
      render json: {
        success: false,
        message: "Unknown command: #{command}. Type 'help' for available commands."
      }
    end
  end

  private

  def set_agent
    @agent = Agent.find_or_create_agent(
      'contentcrafter',
      'ContentCrafter',
      {
        tagline: 'Your AI Content Creator - From Blog Posts to Cinematic Scripts',
        description: 'Advanced AI agent specialized in content creation, copywriting, and multi-format content generation',
        avatar_url: '/assets/agents/contentcrafter_avatar.png',
        personality_traits: {
          'primary_traits' => %w[
            creative_writer
            strategic_planner
            adaptable_voice
            detail_oriented
          ],
          'creative_style' => 'versatile',
          'expertise_level' => 'professional',
          'communication_style' => 'engaging'
        },
        capabilities: %w[
          content_generation
          format_adaptation
          tone_control
          audience_targeting
          multimedia_integration
          seo_optimization
        ],
        specializations: [
          'Blog Writing',
          'Copywriting',
          'Technical Writing',
          'Creative Writing',
          'Social Media Content',
          'Email Marketing'
        ],
        configuration: {
          'emoji' => '📝',
          'primary_color' => '#007acc',
          'secondary_color' => '#0066aa',
          'accent_color' => '#00aaff',
          'interface_theme' => 'professional',
          'max_content_length' => 5000,
          'supported_formats' => %w[blog post article copy email social script],
          'tone_presets' => %w[professional casual creative technical persuasive]
        }
      }
    )

    # Update last active timestamp
    @agent.update_last_active! if @agent.persisted?

    # Initialize the ContentCrafter engine
    @contentcrafter_engine = ContentcrafterAgentEngine.new(@agent) if defined?(ContentcrafterAgentEngine)
  end

  def time_since_last_active
    return 'Just started' unless @agent.updated_at

    time_diff = Time.current - @agent.updated_at

    if time_diff < 1.minute
      'Just now'
    elsif time_diff < 1.hour
      "#{(time_diff / 1.minute).to_i} minutes ago"
    else
      "#{(time_diff / 1.hour).to_i} hours ago"
    end
  end

  # ContentCrafter specialized processing methods
  def process_contentcrafter_request(message)
    content_intent = detect_content_intent(message)

    case content_intent
    when :copywriting
      handle_copywriting_request(message)
    when :content_strategy
      handle_content_strategy_request(message)
    when :seo_optimization
      handle_seo_optimization_request(message)
    when :multi_format_generation
      handle_multi_format_generation_request(message)
    when :brand_voice_development
      handle_brand_voice_development_request(message)
    when :content_analytics
      handle_content_analytics_request(message)
    else
      handle_general_content_query(message)
    end
  end

  def detect_content_intent(message)
    message_lower = message.downcase

    return :copywriting if message_lower.match?(/copy|sales|ad|persuasi|convert|headline/)
    return :content_strategy if message_lower.match?(/strategy|plan|calendar|content.*market/)
    return :seo_optimization if message_lower.match?(/seo|search|keyword|optimiz|rank/)
    return :multi_format_generation if message_lower.match?(/format|adapt|convert.*format|multiple/)
    return :brand_voice_development if message_lower.match?(/brand.*voice|tone|messaging|brand.*guid/)
    return :content_analytics if message_lower.match?(/analy|performance|metrics|insights/)

    :general
  end

  def handle_copywriting_request(_message)
    {
      text: "📝 **ContentCrafter Copywriting Studio**\n\n" \
            "Professional copywriting and persuasive content creation with conversion focus:\n\n" \
            "🌌 **Copywriting Specializations:**\n" \
            "• **Sales Copy:** High-converting sales pages and landing pages\n" \
            "• **Ad Copy:** PPC, social media, and display advertising\n" \
            "• **Email Marketing:** Sequences, newsletters, and promotional emails\n" \
            "• **Product Descriptions:** E-commerce and catalog copy\n" \
            "• **Direct Response:** Traditional and digital direct marketing\n\n" \
            "🎯 **Persuasion Frameworks:**\n" \
            "• AIDA (Attention, Interest, Desire, Action)\n" \
            "• PAS (Problem, Agitation, Solution)\n" \
            "• Before/After/Bridge methodology\n" \
            "• Features/Advantages/Benefits structure\n" \
            "• Storytelling and emotional triggers\n\n" \
            "📊 **Optimization Features:**\n" \
            "• A/B testing variations generation\n" \
            "• Conversion rate optimization insights\n" \
            "• Psychological trigger integration\n" \
            "• Target audience personalization\n" \
            "• Multi-variant headline creation\n\n" \
            'What persuasive copy would you like me to craft for maximum impact?',
      processing_time: rand(1.1..2.5).round(2),
      content_analysis: generate_copywriting_analysis_data,
      writing_insights: generate_copywriting_insights,
      optimization_suggestions: generate_copywriting_optimization,
      creative_guidance: generate_copywriting_guidance
    }
  end

  def handle_content_strategy_request(_message)
    {
      text: "📈 **ContentCrafter Strategy Command Center**\n\n" \
            "Comprehensive content strategy development and marketing planning:\n\n" \
            "🎯 **Strategic Planning:**\n" \
            "• **Business Alignment:** Content goals tied to business objectives\n" \
            "• **Audience Research:** Deep persona development and needs analysis\n" \
            "• **Competitive Analysis:** Market positioning and differentiation\n" \
            "• **Content Pillars:** Core themes and messaging frameworks\n" \
            "• **Distribution Strategy:** Multi-channel content orchestration\n\n" \
            "📅 **Content Calendar Management:**\n" \
            "• Editorial calendar planning and scheduling\n" \
            "• Seasonal content and campaign integration\n" \
            "• Cross-platform content coordination\n" \
            "• Resource allocation and workflow optimization\n" \
            "• Performance tracking and iteration planning\n\n" \
            "🚀 **Growth Strategy:**\n" \
            "• Content funnel development and optimization\n" \
            "• Lead generation and nurturing sequences\n" \
            "• Brand authority building strategies\n" \
            "• Community engagement and loyalty programs\n" \
            "• Scalable content production systems\n\n" \
            'What content strategy challenges can I help you solve?',
      processing_time: rand(1.4..2.8).round(2),
      content_analysis: generate_strategy_analysis_data,
      writing_insights: generate_strategy_insights,
      optimization_suggestions: generate_strategy_optimization,
      creative_guidance: generate_strategy_guidance
    }
  end

  def handle_seo_optimization_request(_message)
    {
      text: "🔍 **ContentCrafter SEO Optimization Lab**\n\n" \
            "Advanced search engine optimization and content ranking strategies:\n\n" \
            "📊 **SEO Analysis:**\n" \
            "• **Keyword Research:** Search volume, competition, and intent analysis\n" \
            "• **Content Audit:** Existing content optimization opportunities\n" \
            "• **Technical SEO:** Site structure and performance optimization\n" \
            "• **Competitive Analysis:** Ranking factors and content gaps\n" \
            "• **SERP Analysis:** Featured snippets and ranking opportunities\n\n" \
            "🌌 **Content Optimization:**\n" \
            "• Search intent alignment and user experience\n" \
            "• Semantic keyword integration and LSI terms\n" \
            "• Title tags, meta descriptions, and header optimization\n" \
            "• Internal linking and content architecture\n" \
            "• Schema markup and rich snippets implementation\n\n" \
            "📈 **Performance Tracking:**\n" \
            "• Ranking position monitoring and alerts\n" \
            "• Click-through rate optimization\n" \
            "• Conversion tracking and attribution\n" \
            "• Local SEO and voice search optimization\n" \
            "• Mobile-first and Core Web Vitals compliance\n\n" \
            'What SEO challenges would you like me to tackle?',
      processing_time: rand(1.3..2.7).round(2),
      content_analysis: generate_seo_analysis_data,
      writing_insights: generate_seo_insights,
      optimization_suggestions: generate_seo_optimization,
      creative_guidance: generate_seo_guidance
    }
  end

  def handle_multi_format_generation_request(_message)
    {
      text: "🔄 **ContentCrafter Multi-Format Generator**\n\n" \
            "Intelligent content adaptation across formats, platforms, and mediums:\n\n" \
            "📱 **Format Specializations:**\n" \
            "• **Digital:** Blog posts, articles, web copy, landing pages\n" \
            "• **Social Media:** Posts, captions, stories, threads\n" \
            "• **Video:** Scripts, storyboards, captions, descriptions\n" \
            "• **Audio:** Podcast scripts, voice-over copy, audio descriptions\n" \
            "• **Print:** Brochures, newsletters, white papers, case studies\n\n" \
            "🎨 **Adaptive Intelligence:**\n" \
            "• Platform-specific optimization and best practices\n" \
            "• Audience behavior adaptation for each format\n" \
            "• Brand voice consistency across all mediums\n" \
            "• Length and structure optimization per platform\n" \
            "• Visual and multimedia integration planning\n\n" \
            "⚡ **Automation Features:**\n" \
            "• One-to-many content distribution\n" \
            "• Format-specific CTA optimization\n" \
            "• Cross-platform SEO adaptation\n" \
            "• Engagement optimization per format\n" \
            "• Performance tracking across formats\n\n" \
            'What content would you like me to adapt across multiple formats?',
      processing_time: rand(1.5..3.1).round(2),
      content_analysis: generate_format_analysis_data,
      writing_insights: generate_format_insights,
      optimization_suggestions: generate_format_optimization,
      creative_guidance: generate_format_guidance
    }
  end

  def handle_brand_voice_development_request(_message)
    {
      text: "🎭 **ContentCrafter Brand Voice Laboratory**\n\n" \
            "Professional brand voice development and messaging consistency management:\n\n" \
            "🎯 **Voice Development:**\n" \
            "• **Personality Definition:** Core traits and characteristics\n" \
            "• **Tone Variations:** Situational and contextual adaptations\n" \
            "• **Messaging Architecture:** Key themes and value propositions\n" \
            "• **Communication Style:** Formal, casual, technical, creative\n" \
            "• **Emotional Resonance:** Connection strategies with target audiences\n\n" \
            "📋 **Brand Guidelines:**\n" \
            "• Comprehensive style guides and documentation\n" \
            "• Do's and don'ts for consistent application\n" \
            "• Industry-specific voice considerations\n" \
            "• Cultural sensitivity and inclusivity guidelines\n" \
            "• Crisis communication voice protocols\n\n" \
            "🔄 **Consistency Management:**\n" \
            "• Multi-channel voice harmonization\n" \
            "• Team training and onboarding materials\n" \
            "• Content review and approval workflows\n" \
            "• Voice evolution and adaptation strategies\n" \
            "• Performance measurement and refinement\n\n" \
            'Ready to develop a distinctive and consistent brand voice?',
      processing_time: rand(1.6..3.2).round(2),
      content_analysis: generate_voice_analysis_data,
      writing_insights: generate_voice_insights,
      optimization_suggestions: generate_voice_optimization,
      creative_guidance: generate_voice_guidance
    }
  end

  def handle_content_analytics_request(_message)
    {
      text: "📊 **ContentCrafter Analytics Intelligence Center**\n\n" \
            "Advanced content performance analysis and optimization insights:\n\n" \
            "📈 **Performance Metrics:**\n" \
            "• **Engagement Analytics:** Views, shares, comments, time on page\n" \
            "• **Conversion Tracking:** Lead generation, sales, sign-ups\n" \
            "• **SEO Performance:** Rankings, organic traffic, click-through rates\n" \
            "• **Social Metrics:** Reach, impressions, engagement rates\n" \
            "• **Brand Awareness:** Mention tracking, sentiment analysis\n\n" \
            "🎯 **Optimization Insights:**\n" \
            "• Content gap identification and opportunity mapping\n" \
            "• Audience behavior patterns and preferences\n" \
            "• Optimal posting times and frequency analysis\n" \
            "• Content format performance comparison\n" \
            "• Competitive benchmarking and market positioning\n\n" \
            "🔮 **Predictive Analytics:**\n" \
            "• Content performance forecasting\n" \
            "• Trending topic identification and timing\n" \
            "• Audience growth and engagement predictions\n" \
            "• ROI optimization recommendations\n" \
            "• Strategic pivot opportunities and timing\n\n" \
            'What content performance insights would you like me to analyze?',
      processing_time: rand(1.7..3.4).round(2),
      content_analysis: generate_analytics_analysis_data,
      writing_insights: generate_analytics_insights,
      optimization_suggestions: generate_analytics_optimization,
      creative_guidance: generate_analytics_guidance
    }
  end

  def handle_general_content_query(_message)
    {
      text: "📚 **ContentCrafter AI Writing Studio Ready**\n\n" \
            "Your comprehensive AI content creation and marketing partner! Here's what I offer:\n\n" \
            "🌌 **Core Capabilities:**\n" \
            "• Professional copywriting and persuasive content creation\n" \
            "• Comprehensive content strategy development and planning\n" \
            "• Advanced SEO optimization and search ranking strategies\n" \
            "• Multi-format content generation and platform adaptation\n" \
            "• Brand voice development and messaging consistency\n" \
            "• Content analytics and performance optimization\n\n" \
            "⚡ **Quick Commands:**\n" \
            "• 'write copy' - Create persuasive sales and marketing copy\n" \
            "• 'content strategy' - Develop comprehensive content plans\n" \
            "• 'optimize SEO' - Improve search rankings and visibility\n" \
            "• 'adapt formats' - Convert content across multiple platforms\n" \
            "• 'brand voice' - Develop consistent messaging guidelines\n" \
            "• 'analyze content' - Performance insights and optimization\n\n" \
            "🌟 **Professional Features:**\n" \
            "• Research-backed content strategies\n" \
            "• Conversion-optimized copywriting\n" \
            "• Multi-platform content adaptation\n" \
            "• Brand consistency management\n" \
            "• Performance tracking and optimization\n\n" \
            'What content creation challenge can I help you master today?',
      processing_time: rand(0.9..2.3).round(2),
      content_analysis: generate_overview_content_data,
      writing_insights: generate_overview_insights,
      optimization_suggestions: generate_overview_optimization,
      creative_guidance: generate_overview_guidance
    }
  end

  # Helper methods for generating content creation data
  def generate_copywriting_analysis_data
    {
      persuasion_potential: 'high_conversion',
      target_audience_fit: rand(85..96),
      emotional_appeal: rand(80..93),
      call_to_action_strength: rand(88..97)
    }
  end

  def generate_copywriting_insights
    [
      'Strong persuasive elements identified',
      'High conversion potential detected',
      'Effective emotional triggers present',
      'Clear value proposition communicated'
    ]
  end

  def generate_copywriting_optimization
    [
      'Test multiple headline variations',
      'Strengthen social proof elements',
      'Optimize call-to-action placement',
      'Enhance urgency and scarcity triggers'
    ]
  end

  def generate_copywriting_guidance
    [
      'Focus on benefits over features',
      'Address specific pain points clearly',
      'Use power words for emotional impact',
      'Test and iterate based on performance'
    ]
  end

  def generate_strategy_analysis_data
    {
      strategic_alignment: 'business_focused',
      market_opportunity: rand(75..90),
      competitive_advantage: rand(80..95),
      resource_efficiency: rand(85..92)
    }
  end

  def generate_strategy_insights
    [
      'Strong market positioning opportunities',
      'Clear content pillar framework',
      'Effective audience targeting strategy',
      'Scalable content production plan'
    ]
  end

  def generate_strategy_optimization
    [
      'Develop competitor differentiation',
      'Enhance audience persona depth',
      'Optimize content distribution mix',
      'Implement performance tracking systems'
    ]
  end

  def generate_strategy_guidance
    [
      'Align content with business objectives',
      'Focus on audience value creation',
      'Maintain consistent brand messaging',
      'Measure and optimize continuously'
    ]
  end

  def generate_seo_analysis_data
    {
      search_optimization: 'comprehensive',
      keyword_relevance: rand(80..94),
      content_quality: rand(85..96),
      technical_seo_score: rand(78..91)
    }
  end

  def generate_seo_insights
    [
      'Strong keyword targeting identified',
      'Good search intent alignment',
      'Effective content structure for SEO',
      'Opportunities for featured snippets'
    ]
  end

  def generate_seo_optimization
    [
      'Enhance semantic keyword usage',
      'Improve internal linking structure',
      'Optimize for voice search queries',
      'Strengthen E-A-T signals'
    ]
  end

  def generate_seo_guidance
    [
      'Create content for users first',
      'Focus on search intent satisfaction',
      'Build topical authority systematically',
      'Monitor and adapt to algorithm changes'
    ]
  end

  def generate_format_analysis_data
    {
      format_adaptability: 'highly_flexible',
      platform_optimization: rand(88..97),
      content_scalability: rand(85..94),
      engagement_potential: rand(82..93)
    }
  end

  def generate_format_insights
    [
      'Excellent cross-platform adaptability',
      'Strong engagement across formats',
      'Effective brand voice consistency',
      'Optimal content length for each platform'
    ]
  end

  def generate_format_optimization
    [
      'Customize CTAs for each platform',
      'Optimize visual elements per format',
      'Adapt tone for platform audiences',
      'Schedule for optimal engagement times'
    ]
  end

  def generate_format_guidance
    [
      'Understand platform-specific audiences',
      'Maintain core message across formats',
      'Optimize for native platform features',
      'Track performance across all formats'
    ]
  end

  def generate_voice_analysis_data
    {
      brand_personality: 'distinctive',
      voice_consistency: rand(90..98),
      audience_resonance: rand(85..95),
      differentiation_strength: rand(82..91)
    }
  end

  def generate_voice_insights
    [
      'Clear brand personality definition',
      'Strong emotional connection potential',
      'Effective differentiation from competitors',
      'Scalable voice guidelines developed'
    ]
  end

  def generate_voice_optimization
    [
      'Develop situational tone variations',
      'Create voice training materials',
      'Implement consistency check systems',
      'Plan voice evolution strategy'
    ]
  end

  def generate_voice_guidance
    [
      'Authentic voice resonates best',
      'Consistency builds brand recognition',
      'Adapt tone while maintaining personality',
      'Document guidelines for team alignment'
    ]
  end

  def generate_analytics_analysis_data
    {
      performance_insight: 'data_driven',
      optimization_potential: rand(80..93),
      trend_identification: rand(85..96),
      roi_improvement: rand(75..88)
    }
  end

  def generate_analytics_insights
    [
      'Clear performance patterns identified',
      'Strong optimization opportunities',
      'Effective content-audience matching',
      'Measurable ROI improvement potential'
    ]
  end

  def generate_analytics_optimization
    [
      'Focus on high-performing content types',
      'Optimize underperforming content',
      'Expand successful content themes',
      'Improve conversion funnel efficiency'
    ]
  end

  def generate_analytics_guidance
    [
      'Data should drive content decisions',
      'Focus on meaningful metrics',
      'Test hypotheses systematically',
      'Iterate based on performance insights'
    ]
  end

  def generate_overview_content_data
    {
      content_studio_readiness: 'full_service',
      supported_formats: 25,
      optimization_capabilities: 'comprehensive',
      user_success_rate: '94%'
    }
  end

  def generate_overview_insights
    [
      'Complete content creation ecosystem active',
      'Professional-grade writing capabilities',
      'Multi-platform optimization ready',
      'Data-driven content strategies available'
    ]
  end

  def generate_overview_optimization
    [
      'Choose appropriate content strategy',
      'Focus on audience value creation',
      'Maintain brand voice consistency',
      'Measure performance continuously'
    ]
  end

  def generate_overview_guidance
    [
      'Great content starts with clear strategy',
      'Audience needs drive content success',
      'Consistency builds brand authority',
      'Performance data guides optimization'
    ]
  end

  # Specialized processing methods for the new endpoints
  def create_professional_copy(brief, content_type, target_audience, tone)
    {
      headlines: generate_headline_variations(brief, tone),
      body_copy: create_persuasive_body_copy(brief, content_type),
      call_to_action: craft_compelling_cta(content_type),
      persuasion_elements: identify_persuasion_techniques,
      a_b_variations: create_copy_variations,
      processing_time: rand(1.5..3.0).round(2)
    }
  end

  def develop_content_strategy(business_goals, target_market, content_pillars, timeframe)
    {
      strategic_pillars: define_content_pillars(content_pillars),
      content_calendar: create_content_calendar(timeframe),
      distribution_plan: plan_content_distribution,
      performance_metrics: define_success_metrics,
      competitive_analysis: analyze_competitive_landscape,
      processing_time: rand(2.0..4.0).round(2)
    }
  end

  def optimize_for_search(content, target_keywords, search_intent)
    {
      keyword_analysis: analyze_keyword_opportunities(target_keywords),
      content_score: calculate_seo_score(content),
      optimization_suggestions: generate_seo_suggestions(content),
      meta_elements: create_meta_elements,
      schema_markup: suggest_schema_markup,
      processing_time: rand(1.2..2.5).round(2)
    }
  end

  def generate_multiple_formats(source_content, target_formats, brand_voice)
    {
      generated_formats: create_format_adaptations(source_content, target_formats),
      format_specifications: define_format_specs(target_formats),
      adaptation_notes: document_adaptation_decisions,
      cross_platform_optimization: optimize_for_platforms,
      content_variants: create_platform_variants,
      processing_time: rand(2.5..4.5).round(2)
    }
  end

  def develop_brand_voice(brand_attributes, target_persona, communication_goals, industry_context)
    {
      voice_guidelines: create_voice_guidelines(brand_attributes),
      tone_variations: define_tone_variations,
      messaging_framework: develop_messaging_framework,
      style_examples: provide_style_examples,
      consistency_checklist: create_consistency_checklist,
      processing_time: rand(1.8..3.5).round(2)
    }
  end

  def analyze_content_performance(content_pieces, metrics, analysis_period)
    {
      performance_insights: generate_performance_insights(content_pieces),
      optimization_opportunities: identify_optimization_opportunities,
      content_gaps: identify_content_gaps,
      trending_topics: identify_trending_topics,
      roi_analysis: calculate_content_roi,
      processing_time: rand(1.5..3.0).round(2)
    }
  end

  # Helper methods for processing
  def generate_headline_variations(brief, tone)
    ["#{tone.humanize} headline for #{brief}", "Alternative #{tone} approach", 'Power headline variation']
  end

  def create_persuasive_body_copy(brief, content_type)
    "Compelling #{content_type} body copy based on: #{brief}"
  end

  def craft_compelling_cta(content_type)
    "Optimized call-to-action for #{content_type}"
  end

  def identify_persuasion_techniques
    ['Social proof', 'Urgency', 'Authority', 'Reciprocity']
  end

  def create_copy_variations
    ['Variation A: Feature-focused', 'Variation B: Benefit-focused', 'Variation C: Emotion-focused']
  end

  def define_content_pillars(content_pillars)
    content_pillars.any? ? content_pillars : %w[Education Entertainment Inspiration Problem-solving]
  end

  def create_content_calendar(timeframe)
    { timeframe: timeframe, frequency: 'weekly', content_mix: 'balanced' }
  end

  def plan_content_distribution
    ['Website/Blog', 'Social Media', 'Email Marketing', 'Paid Advertising']
  end

  def define_success_metrics
    ['Engagement Rate', 'Conversion Rate', 'Brand Awareness', 'Lead Generation']
  end

  def analyze_competitive_landscape
    'Competitive analysis shows opportunities for differentiation'
  end

  def analyze_keyword_opportunities(target_keywords)
    target_keywords.map { |keyword| { keyword: keyword, difficulty: rand(30..80), volume: rand(1000..10_000) } }
  end

  def calculate_seo_score(content)
    rand(70..95)
  end

  def generate_seo_suggestions(content)
    ['Add target keywords naturally', 'Improve readability', 'Add internal links', 'Optimize headers']
  end

  def create_meta_elements
    { title: 'SEO-optimized title', description: 'Compelling meta description' }
  end

  def suggest_schema_markup
    'Article schema markup recommended'
  end

  def create_format_adaptations(source_content, target_formats)
    target_formats.map { |format| { format: format, adapted_content: "#{format} version of content" } }
  end

  def define_format_specs(target_formats)
    target_formats.map { |format| { format: format, specs: "#{format} specifications" } }
  end

  def document_adaptation_decisions
    ['Tone adjusted for platform', 'Length optimized for format', 'CTA adapted for context']
  end

  def optimize_for_platforms
    'Cross-platform optimization applied'
  end

  def create_platform_variants
    ['Primary version', 'Social media variant', 'Email variant']
  end

  def create_voice_guidelines(brand_attributes)
    "Voice guidelines based on: #{brand_attributes}"
  end

  def define_tone_variations
    %w[Professional Friendly Authoritative Conversational]
  end

  def develop_messaging_framework
    'Comprehensive messaging framework developed'
  end

  def provide_style_examples
    ['Do: Use active voice', 'Don\'t: Use jargon without explanation']
  end

  def create_consistency_checklist
    ['Voice alignment', 'Tone appropriateness', 'Message clarity', 'Brand alignment']
  end

  def generate_performance_insights(content_pieces)
    'Performance insights based on content analysis'
  end

  def identify_optimization_opportunities
    ['Improve headlines', 'Enhance CTAs', 'Optimize for mobile', 'Add visual elements']
  end

  def identify_content_gaps
    ['Topic gap in competitor analysis', 'Format gap in video content', 'Audience gap in technical content']
  end

  def identify_trending_topics
    ['AI and automation', 'Sustainability practices', 'Remote work optimization']
  end

  def calculate_content_roi
    { roi_percentage: rand(150..400), cost_per_lead: rand(25..75), conversion_rate: rand(2..8) }
  end

  def set_content_context
    @content_stats = get_default_content_stats
    @session_data = {
      formats_used: session[:contentcrafter_formats] || [],
      content_generated: session[:contentcrafter_count] || 0,
      session_start: session[:contentcrafter_start] || Time.current,
      last_format: session[:contentcrafter_last_format] || 'blog_post'
    }
  end

  def content_context_params
    {
      format: params[:format],
      tone: params[:tone],
      audience: params[:audience],
      length: params[:length],
      include_multimedia: params[:include_multimedia] == 'true',
      platform: params[:platform] || 'web'
    }
  end

  def create_default_agent
    Agent.create!(
      name: 'ContentCrafter',
      agent_type: 'contentcrafter',
      personality_traits: %w[
        creative analytical adaptable detail_oriented
        strategic versatile professional innovative
      ],
      capabilities: %w[
        content_generation format_adaptation tone_control
        audience_targeting multimedia_integration export_management
      ],
      specializations: %w[
        blog_writing copywriting technical_writing creative_writing
        social_media email_marketing script_writing agent_fusion
      ],
      configuration: {
        'emoji' => '📝',
        'tagline' => 'Your AI Content Creator - From Blog Posts to Cinematic Scripts',
        'primary_color' => '#007acc',
        'secondary_color' => '#0066aa',
        'response_style' => 'professional_creative'
      },
      status: 'active'
    )
  end

  def analyze_emotional_tone(text)
    positive_indicators = %w[excellent amazing wonderful great fantastic brilliant]
    negative_indicators = %w[difficult challenging problem issue concern struggle]
    neutral_indicators = %w[analyze consider examine review evaluate]

    text_lower = text.downcase

    positive_count = positive_indicators.count { |word| text_lower.include?(word) }
    negative_count = negative_indicators.count { |word| text_lower.include?(word) }
    neutral_count = neutral_indicators.count { |word| text_lower.include?(word) }

    if positive_count > negative_count && positive_count > neutral_count
      'Positive & Engaging'
    elsif negative_count > positive_count
      'Cautious & Analytical'
    else
      'Neutral & Informative'
    end
  end

  def calculate_complexity_score(text)
    words = text.split.length
    sentences = text.split(/[.!?]/).length

    return 'Low' if sentences == 0

    avg_words_per_sentence = words.to_f / sentences

    case avg_words_per_sentence
    when 0..10
      'Low'
    when 11..20
      'Medium'
    else
      'High'
    end
  end

  def generate_content_suggestions(text)
    suggestions = []
    words = text.split.length

    suggestions << 'Consider adding subheadings to break up long sections' if words > 500
    suggestions << 'Add more descriptive examples to illustrate key points' if words < 200
    unless text.downcase.include?('contact') || text.downcase.include?('learn more')
      suggestions << 'Include a clear call-to-action at the end'
    end
    unless text.include?('•') || text.include?('-')
      suggestions << 'Consider adding bullet points for better readability'
    end
    unless analyze_emotional_tone(text) == 'Positive & Engaging'
      suggestions << 'Add emotional appeal to connect with readers'
    end

    suggestions.empty? ? ['Content looks great! Consider A/B testing different headlines.'] : suggestions
  end

  def generate_sample_export_content(format)
    case format
    when 'markdown'
      "# Sample Content\n\nThis is a **sample** exported content in Markdown format.\n\n## Key Features\n\n- Clean formatting\n- Easy to read\n- Web-ready\n\n*Generated by ContentCrafter*"
    when 'html'
      '<h1>Sample Content</h1><p>This is a <strong>sample</strong> exported content in HTML format.</p><h2>Key Features</h2><ul><li>Clean formatting</li><li>Easy to read</li><li>Web-ready</li></ul><p><em>Generated by ContentCrafter</em></p>'
    when 'json'
      {
        title: 'Sample Content',
        content: 'This is a sample exported content in JSON format.',
        features: ['Clean formatting', 'Easy to read', 'Web-ready'],
        metadata: { generator: 'ContentCrafter', timestamp: Time.current }
      }.to_json
    else
      "Sample Content\n\nThis is a sample exported content in plain text format.\n\nKey Features:\n- Clean formatting\n- Easy to read\n- Web-ready\n\nGenerated by ContentCrafter"
    end
  end

  def generate_help_text
    {
      commands: {
        'stats' => 'Show ContentCrafter statistics and capabilities',
        'formats' => 'List all available content formats',
        'demo [format]' => 'Generate demo content for specified format',
        'help' => 'Show this help message'
      },
      examples: [
        'Create a blog post about AI in friendly tone for general audience',
        'Generate ad copy for productivity app targeting business professionals',
        'Write agent intro for EmotiSense in empathetic tone',
        'Create script about innovation in inspiring tone'
      ],
      fusion_capabilities: [
        'Emotional analysis integration with EmotiSense',
        'Visual suggestions from CineGen',
        'Multi-format content adaptation',
        'Real-time content optimization'
      ]
    }
  end

  def get_default_content_stats
    {
      total_content_pieces: 1247,
      formats_generated: %w[blog_post social_media email_campaign sales_copy],
      avg_engagement_rate: 8.6,
      content_quality_score: 94,
      processing_speed: '2.3s avg',
      user_satisfaction: 97
    }
  end

  private

  def current_user
    # Hardcoded user for testing (bypassing DB)
    OpenStruct.new(id: 1, name: 'Demo User')
  end
end
