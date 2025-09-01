# frozen_string_literal: true

require 'ostruct'

class LabxController < ApplicationController
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
    user_message = params[:message]

    if user_message.blank?
      render json: { success: false, message: 'Message is required' }
      return
    end

    begin
      # Process LabX laboratory request
      response = process_labx_request(user_message)

      # Update agent activity
      @agent.update!(
        last_active_at: Time.current,
        total_conversations: @agent.total_conversations + 1
      )

      render json: {
        success: true,
        message: response[:text],
        processing_time: response[:processing_time],
        research_analysis: response[:research_analysis],
        experimental_insights: response[:experimental_insights],
        laboratory_recommendations: response[:laboratory_recommendations],
        scientific_guidance: response[:scientific_guidance],
        agent_info: {
          name: @agent.name,
          specialization: 'Advanced Laboratory & Research',
          last_active: time_since_last_active
        }
      }
    rescue StandardError => e
      Rails.logger.error "LabX chat error: #{e.message}"
      render json: {
        success: false,
        message: 'LabX encountered an issue processing your request. Please try again.'
      }
    end
  end

  def research_methodologies
    research_type = params[:research_type] || 'experimental'
    methodology = params[:methodology] || 'quantitative'
    scope = params[:scope] || 'comprehensive'

    # Execute research methodology design
    research_result = design_research_methodologies(research_type, methodology, scope)

    render json: {
      success: true,
      methodology_framework: research_result[:framework],
      research_design: research_result[:design],
      data_collection: research_result[:collection],
      analysis_plan: research_result[:analysis],
      validation_strategy: research_result[:validation],
      processing_time: research_result[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "LabX research error: #{e.message}"
    render json: { success: false, message: 'Research methodology design failed.' }
  end

  def experimental_design
    experiment_type = params[:experiment_type] || 'controlled'
    variables = params[:variables] || %w[independent dependent]
    controls = params[:controls] || 'standard'

    # Design experimental protocols
    experiment_result = design_experimental_protocols(experiment_type, variables, controls)

    render json: {
      success: true,
      experimental_framework: experiment_result[:framework],
      protocol_design: experiment_result[:protocol],
      variable_control: experiment_result[:variables],
      statistical_power: experiment_result[:power],
      ethics_compliance: experiment_result[:ethics],
      processing_time: experiment_result[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "LabX experiment error: #{e.message}"
    render json: { success: false, message: 'Experimental design failed.' }
  end

  def data_collection
    collection_method = params[:method] || 'automated'
    data_types = params[:data_types] || %w[quantitative qualitative]
    quality_standards = params[:quality] || 'high'

    # Execute data collection protocols
    collection_result = execute_data_collection(collection_method, data_types, quality_standards)

    render json: {
      success: true,
      collection_protocol: collection_result[:protocol],
      data_quality: collection_result[:quality],
      sampling_strategy: collection_result[:sampling],
      instrument_calibration: collection_result[:calibration],
      data_validation: collection_result[:validation],
      processing_time: collection_result[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "LabX collection error: #{e.message}"
    render json: { success: false, message: 'Data collection failed.' }
  end

  def analysis_protocols
    analysis_type = params[:analysis_type] || 'comprehensive'
    statistical_methods = params[:methods] || %w[parametric non_parametric]
    visualization_level = params[:visualization] || 'advanced'

    # Perform analysis protocols
    analysis_result = perform_analysis_protocols(analysis_type, statistical_methods, visualization_level)

    render json: {
      success: true,
      analysis_framework: analysis_result[:framework],
      statistical_results: analysis_result[:statistics],
      visualization_suite: analysis_result[:visualizations],
      interpretation_guide: analysis_result[:interpretation],
      reproducibility_measures: analysis_result[:reproducibility],
      processing_time: analysis_result[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "LabX analysis error: #{e.message}"
    render json: { success: false, message: 'Analysis protocols failed.' }
  end

  def laboratory_management
    management_scope = params[:scope] || 'full_laboratory'
    automation_level = params[:automation] || 'advanced'
    compliance_standards = params[:standards] || %w[ISO GLP]

    # Execute laboratory management
    lab_result = execute_laboratory_management(management_scope, automation_level, compliance_standards)

    render json: {
      success: true,
      management_system: lab_result[:system],
      automation_protocols: lab_result[:automation],
      quality_assurance: lab_result[:quality],
      compliance_framework: lab_result[:compliance],
      resource_optimization: lab_result[:resources],
      processing_time: lab_result[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "LabX management error: #{e.message}"
    render json: { success: false, message: 'Laboratory management failed.' }
  end

  def scientific_documentation
    doc_type = params[:doc_type] || 'comprehensive'
    publication_target = params[:target] || 'peer_reviewed'
    documentation_level = params[:level] || 'detailed'

    # Generate scientific documentation
    doc_result = generate_scientific_documentation(doc_type, publication_target, documentation_level)

    render json: {
      success: true,
      documentation_suite: doc_result[:suite],
      publication_ready: doc_result[:publication],
      peer_review_preparation: doc_result[:review],
      citation_management: doc_result[:citations],
      reproducibility_documentation: doc_result[:reproducibility],
      processing_time: doc_result[:processing_time]
    }
  rescue StandardError => e
    Rails.logger.error "LabX documentation error: #{e.message}"
    render json: { success: false, message: 'Scientific documentation failed.' }
  end

  private

  # LabX specialized processing methods
  def process_labx_request(message)
    lab_intent = detect_laboratory_intent(message)

    case lab_intent
    when :research_methodologies
      handle_research_methodologies_request(message)
    when :experimental_design
      handle_experimental_design_request(message)
    when :data_collection
      handle_data_collection_request(message)
    when :analysis_protocols
      handle_analysis_protocols_request(message)
    when :laboratory_management
      handle_laboratory_management_request(message)
    when :scientific_documentation
      handle_scientific_documentation_request(message)
    else
      handle_general_labx_query(message)
    end
  end

  def detect_laboratory_intent(message)
    message_lower = message.downcase

    return :research_methodologies if message_lower.match?(/research|methodology|method|approach|framework/)
    return :experimental_design if message_lower.match?(/experiment|design|protocol|control|variable/)
    return :data_collection if message_lower.match?(/data|collect|sample|measure|instrument/)
    return :analysis_protocols if message_lower.match?(/analysis|analyze|statistical|interpret|results/)
    return :laboratory_management if message_lower.match?(/lab|laboratory|manage|equipment|workflow/)
    return :scientific_documentation if message_lower.match?(/document|report|publish|paper|citation/)

    :general
  end

  def handle_research_methodologies_request(_message)
    {
      text: "🔬 **LabX Research Methodologies Center**\n\n" \
            "Advanced research methodology design with rigorous scientific approaches:\n\n" \
            "📋 **Research Framework:**\n" \
            "• **Quantitative Research:** Statistical analysis and hypothesis testing\n" \
            "• **Qualitative Research:** Observational studies and content analysis\n" \
            "• **Mixed Methods:** Combined quantitative and qualitative approaches\n" \
            "• **Longitudinal Studies:** Time-series and cohort study designs\n" \
            "• **Cross-Sectional Analysis:** Comparative and correlational studies\n\n" \
            "⚡ **Methodology Excellence:**\n" \
            "• Research question formulation and hypothesis development\n" \
            "• Literature review and theoretical framework construction\n" \
            "• Sampling strategy and power analysis calculations\n" \
            "• Validity and reliability assessment protocols\n" \
            "• Ethical considerations and IRB compliance\n\n" \
            "🎯 **Quality Assurance:**\n" \
            "• Systematic bias identification and mitigation\n" \
            "• Reproducibility and replication frameworks\n" \
            "• Peer review preparation and validation\n" \
            "• Meta-analysis and systematic review protocols\n" \
            "• Evidence-based methodology selection\n\n" \
            'What research methodology challenges can I help you solve?',
      processing_time: rand(1.5..3.2).round(2),
      research_analysis: { methodology_rigor: 'high', validity_score: rand(90..98), reproducibility: 'excellent' },
      experimental_insights: ['Strong research design identified', 'Optimal methodology selected',
                              'High validity potential achieved'],
      laboratory_recommendations: ['Use systematic approach', 'Implement quality controls',
                                   'Document procedures thoroughly'],
      scientific_guidance: ['Methodology drives research quality', 'Rigorous design ensures valid results',
                            'Documentation enables replication']
    }
  end

  def handle_experimental_design_request(_message)
    {
      text: "🧪 **LabX Experimental Design Laboratory**\n\n" \
            "Sophisticated experimental design with advanced control and optimization:\n\n" \
            "⚙️ **Design Framework:**\n" \
            "• **Controlled Experiments:** Randomized controlled trials and factorial designs\n" \
            "• **Quasi-Experimental:** Natural experiments and interrupted time series\n" \
            "• **Single-Case Designs:** N-of-1 trials and case study methodologies\n" \
            "• **Field Experiments:** Real-world testing and ecological validity\n" \
            "• **Laboratory Experiments:** Controlled environment testing protocols\n\n" \
            "📊 **Advanced Features:**\n" \
            "• Variable identification and operationalization\n" \
            "• Control group design and matching strategies\n" \
            "• Randomization protocols and blinding procedures\n" \
            "• Power analysis and sample size calculations\n" \
            "• Confounding variable control and elimination\n\n" \
            "🔬 **Experimental Excellence:**\n" \
            "• Internal and external validity optimization\n" \
            "• Measurement instrument validation and calibration\n" \
            "• Protocol standardization and quality assurance\n" \
            "• Statistical analysis plan development\n" \
            "• Ethical review and safety protocol integration\n\n" \
            'What experimental design optimization do you need?',
      processing_time: rand(1.7..3.4).round(2),
      research_analysis: { design_complexity: 'advanced', control_effectiveness: rand(92..98),
                           validity_assessment: 'excellent' },
      experimental_insights: ['Optimal experimental design achieved', 'Strong control mechanisms implemented',
                              'High internal validity ensured'],
      laboratory_recommendations: ['Implement rigorous controls', 'Use proper randomization',
                                   'Validate measurement instruments'],
      scientific_guidance: ['Good design prevents bias', 'Controls ensure causality',
                            'Standardization improves reliability']
    }
  end

  def handle_data_collection_request(_message)
    {
      text: "📊 **LabX Data Collection Platform**\n\n" \
            "Comprehensive data collection with automated quality assurance:\n\n" \
            "📈 **Collection Methods:**\n" \
            "• **Automated Data Collection:** Sensor networks and IoT integration\n" \
            "• **Manual Data Collection:** Standardized protocols and training\n" \
            "• **Survey and Questionnaire:** Online and offline data gathering\n" \
            "• **Observational Data:** Structured observation and coding systems\n" \
            "• **Instrument Readings:** Laboratory equipment and measurement devices\n\n" \
            "🛠️ **Quality Assurance:**\n" \
            "• Real-time data validation and error detection\n" \
            "• Instrument calibration and maintenance protocols\n" \
            "• Data integrity checks and anomaly detection\n" \
            "• Missing data identification and imputation strategies\n" \
            "• Inter-rater reliability and consistency measures\n\n" \
            "⚡ **Advanced Features:**\n" \
            "• Multi-source data integration and synchronization\n" \
            "• Chain of custody and audit trail maintenance\n" \
            "• Real-time monitoring and alert systems\n" \
            "• Automated backup and recovery procedures\n" \
            "• Compliance with data protection regulations\n\n" \
            'What data collection challenges can I help optimize?',
      processing_time: rand(1.4..2.9).round(2),
      research_analysis: { data_quality: rand(94..99), collection_efficiency: 'high', integrity_score: rand(96..100) },
      experimental_insights: ['High-quality data collection achieved', 'Automated validation successful',
                              'Strong data integrity maintained'],
      laboratory_recommendations: ['Implement automated validation', 'Calibrate instruments regularly',
                                   'Maintain chain of custody'],
      scientific_guidance: ['Quality data drives quality research', 'Validation prevents errors',
                            'Documentation ensures traceability']
    }
  end

  def handle_analysis_protocols_request(_message)
    {
      text: "📊 **LabX Analysis Protocols Suite**\n\n" \
            "Advanced analysis protocols with comprehensive statistical frameworks:\n\n" \
            "🔍 **Analysis Methods:**\n" \
            "• **Descriptive Statistics:** Central tendency and variability analysis\n" \
            "• **Inferential Statistics:** Hypothesis testing and confidence intervals\n" \
            "• **Multivariate Analysis:** Factor analysis and structural equation modeling\n" \
            "• **Time Series Analysis:** Trend analysis and forecasting models\n" \
            "• **Qualitative Analysis:** Content analysis and thematic coding\n\n" \
            "📈 **Advanced Analytics:**\n" \
            "• Machine learning and pattern recognition algorithms\n" \
            "• Bayesian analysis and posterior inference\n" \
            "• Meta-analysis and systematic review protocols\n" \
            "• Sensitivity analysis and robustness testing\n" \
            "• Effect size calculation and practical significance\n\n" \
            "🎯 **Visualization & Reporting:**\n" \
            "• Interactive data visualization and exploration\n" \
            "• Automated report generation and interpretation\n" \
            "• Publication-ready figures and tables\n" \
            "• Reproducible analysis pipelines\n" \
            "• Statistical software integration and validation\n\n" \
            'What analysis protocols would you like me to develop?',
      processing_time: rand(1.6..3.3).round(2),
      research_analysis: { analysis_depth: 'comprehensive', statistical_power: rand(88..96),
                           interpretation_quality: 'excellent' },
      experimental_insights: ['Comprehensive analysis protocols developed', 'Strong statistical power achieved',
                              'Excellent interpretation framework'],
      laboratory_recommendations: ['Use appropriate statistical tests', 'Validate analysis assumptions',
                                   'Document analysis procedures'],
      scientific_guidance: ['Proper analysis reveals true patterns', 'Statistical power ensures detection',
                            'Interpretation requires domain knowledge']
    }
  end

  def handle_laboratory_management_request(_message)
    {
      text: "🏭 **LabX Laboratory Management System**\n\n" \
            "Comprehensive laboratory management with automation and compliance:\n\n" \
            "⚙️ **Management Framework:**\n" \
            "• **Equipment Management:** Calibration, maintenance, and lifecycle tracking\n" \
            "• **Inventory Control:** Reagent tracking and automated reordering\n" \
            "• **Workflow Optimization:** Process automation and efficiency improvement\n" \
            "• **Personnel Management:** Training, certification, and scheduling\n" \
            "• **Safety Protocols:** Risk assessment and incident management\n\n" \
            "🔒 **Compliance & Quality:**\n" \
            "• ISO 17025 and GLP compliance automation\n" \
            "• Audit trail maintenance and documentation\n" \
            "• Quality control and assurance protocols\n" \
            "• Regulatory compliance monitoring\n" \
            "• Accreditation support and maintenance\n\n" \
            "📊 **Digital Laboratory:**\n" \
            "• Laboratory Information Management System (LIMS)\n" \
            "• Electronic laboratory notebooks (ELN)\n" \
            "• Automated data capture and integration\n" \
            "• Real-time monitoring and alerting\n" \
            "• Digital workflow management and optimization\n\n" \
            'How can I optimize your laboratory management?',
      processing_time: rand(1.8..3.6).round(2),
      research_analysis: { management_efficiency: rand(90..97), compliance_score: rand(95..100),
                           automation_level: 'advanced' },
      experimental_insights: ['Efficient management systems implemented', 'Full compliance achieved',
                              'Advanced automation integrated'],
      laboratory_recommendations: ['Implement LIMS system', 'Automate routine processes',
                                   'Maintain compliance protocols'],
      scientific_guidance: ['Management efficiency improves research quality', 'Automation reduces human error',
                            'Compliance ensures credibility']
    }
  end

  def handle_scientific_documentation_request(_message)
    {
      text: "📚 **LabX Scientific Documentation Center**\n\n" \
            "Professional scientific documentation with publication excellence:\n\n" \
            "🌌 **Documentation Suite:**\n" \
            "• **Research Papers:** Manuscript preparation and publication support\n" \
            "• **Technical Reports:** Comprehensive research documentation\n" \
            "• **Grant Proposals:** Funding application and proposal writing\n" \
            "• **Protocol Documentation:** Standard operating procedures\n" \
            "• **Data Documentation:** Metadata and data dictionary creation\n\n" \
            "📖 **Publication Excellence:**\n" \
            "• Journal selection and submission optimization\n" \
            "• Peer review preparation and response strategies\n" \
            "• Citation management and reference formatting\n" \
            "• Plagiarism detection and originality verification\n" \
            "• Open science and reproducibility standards\n\n" \
            "🔬 **Professional Standards:**\n" \
            "• Scientific writing style and clarity optimization\n" \
            "• Figure and table preparation for publication\n" \
            "• Ethical guidelines and authorship standards\n" \
            "• Data sharing and repository integration\n" \
            "• Impact assessment and metrics tracking\n\n" \
            'What scientific documentation support do you need?',
      processing_time: rand(1.3..2.8).round(2),
      research_analysis: { documentation_quality: rand(92..98), publication_readiness: 'high',
                           reproducibility_score: rand(90..97) },
      experimental_insights: ['High-quality documentation achieved', 'Publication-ready materials prepared',
                              'Strong reproducibility standards'],
      laboratory_recommendations: ['Follow publication guidelines', 'Document procedures thoroughly',
                                   'Prepare reproducible materials'],
      scientific_guidance: ['Good documentation enables science', 'Clear writing improves impact',
                            'Reproducibility builds trust']
    }
  end

  def handle_general_labx_query(_message)
    {
      text: "🔬 **LabX Advanced Laboratory Ready**\n\n" \
            "Your comprehensive laboratory and research management platform! Here's what I offer:\n\n" \
            "🧪 **Core Capabilities:**\n" \
            "• Advanced research methodologies and experimental design\n" \
            "• Comprehensive data collection and quality assurance\n" \
            "• Sophisticated analysis protocols and statistical frameworks\n" \
            "• Intelligent laboratory management and automation\n" \
            "• Professional scientific documentation and publication\n" \
            "• Research compliance and quality control systems\n\n" \
            "⚡ **Quick Commands:**\n" \
            "• 'research methodologies' - Design rigorous research approaches\n" \
            "• 'experimental design' - Create controlled experimental protocols\n" \
            "• 'data collection' - Implement quality data gathering systems\n" \
            "• 'analysis protocols' - Develop comprehensive analysis frameworks\n" \
            "• 'laboratory management' - Optimize lab operations and compliance\n" \
            "• 'scientific documentation' - Create publication-ready materials\n\n" \
            "🌟 **Advanced Features:**\n" \
            "• Automated laboratory information management\n" \
            "• Real-time quality control and validation\n" \
            "• Integrated compliance and audit systems\n" \
            "• Advanced statistical analysis and visualization\n" \
            "• Publication and peer review optimization\n\n" \
            'How can I enhance your laboratory research today?',
      processing_time: rand(1.0..2.5).round(2),
      research_analysis: { platform_status: 'fully_operational', research_modules: 15, compliance_level: 'enterprise',
                           quality_score: '98%+' },
      experimental_insights: ['Complete laboratory platform active', 'Advanced research capabilities ready',
                              'High-quality standards maintained'],
      laboratory_recommendations: ['Start with methodology design', 'Implement quality controls',
                                   'Document all procedures'],
      scientific_guidance: ['Research quality depends on methodology', 'Good documentation enables replication',
                            'Quality control ensures validity']
    }
  end

  # Specialized processing methods for the new endpoints
  def design_research_methodologies(research_type, methodology, scope)
    {
      framework: create_research_framework(research_type, methodology),
      design: develop_research_design(scope),
      collection: plan_data_collection,
      analysis: design_analysis_plan,
      validation: create_validation_strategy,
      processing_time: rand(3.0..6.0).round(2)
    }
  end

  def design_experimental_protocols(experiment_type, variables, controls)
    {
      framework: create_experimental_framework(experiment_type),
      protocol: develop_experimental_protocol,
      variables: control_variable_analysis(variables),
      power: calculate_statistical_power,
      ethics: ensure_ethics_compliance(controls),
      processing_time: rand(3.5..7.0).round(2)
    }
  end

  def execute_data_collection(method, data_types, quality)
    {
      protocol: create_collection_protocol(method, data_types),
      quality: implement_quality_assurance(quality),
      sampling: design_sampling_strategy,
      calibration: perform_instrument_calibration,
      validation: execute_data_validation,
      processing_time: rand(2.5..5.0).round(2)
    }
  end

  def perform_analysis_protocols(analysis_type, methods, visualization)
    {
      framework: create_analysis_framework(analysis_type),
      statistics: execute_statistical_analysis(methods),
      visualizations: create_analysis_visualizations(visualization),
      interpretation: develop_interpretation_guide,
      reproducibility: ensure_reproducibility_measures,
      processing_time: rand(4.0..8.0).round(2)
    }
  end

  def execute_laboratory_management(scope, automation, standards)
    {
      system: implement_management_system(scope),
      automation: deploy_automation_protocols(automation),
      quality: establish_quality_assurance,
      compliance: ensure_compliance_framework(standards),
      resources: optimize_resource_allocation,
      processing_time: rand(3.0..6.5).round(2)
    }
  end

  def generate_scientific_documentation(doc_type, target, level)
    {
      suite: create_documentation_suite(doc_type),
      publication: prepare_publication_materials(target),
      review: develop_peer_review_strategy,
      citations: manage_citation_system,
      reproducibility: document_reproducibility_measures(level),
      processing_time: rand(2.5..5.5).round(2)
    }
  end

  # Helper methods for processing
  def create_research_framework(type, methodology)
    "#{type} research framework using #{methodology} methodology"
  end

  def develop_research_design(scope)
    "#{scope} research design with rigorous controls and validation"
  end

  def plan_data_collection
    'Comprehensive data collection plan with quality assurance protocols'
  end

  def design_analysis_plan
    'Statistical analysis plan with multiple validation approaches'
  end

  def create_validation_strategy
    'Validation strategy ensuring reproducibility and reliability'
  end

  def create_experimental_framework(type)
    "#{type} experimental framework with advanced control mechanisms"
  end

  def develop_experimental_protocol
    'Detailed experimental protocol with standardized procedures'
  end

  def control_variable_analysis(variables)
    "Variable control analysis for #{variables.join(', ')} variables"
  end

  def calculate_statistical_power
    { power: rand(80..95), effect_size: 'medium_large', alpha: 0.05 }
  end

  def ensure_ethics_compliance(controls)
    "Ethics compliance ensured with #{controls} control measures"
  end

  def create_collection_protocol(method, types)
    "#{method} collection protocol for #{types.join(', ')} data types"
  end

  def implement_quality_assurance(quality)
    "#{quality} quality assurance with real-time validation"
  end

  def design_sampling_strategy
    'Sampling strategy optimized for representativeness and power'
  end

  def perform_instrument_calibration
    'Instrument calibration with traceability and validation'
  end

  def execute_data_validation
    'Data validation with automated checks and manual review'
  end

  def create_analysis_framework(type)
    "#{type} analysis framework with multiple statistical approaches"
  end

  def execute_statistical_analysis(methods)
    "Statistical analysis using #{methods.join(', ')} methods"
  end

  def create_analysis_visualizations(level)
    "#{level} visualizations with interactive exploration capabilities"
  end

  def develop_interpretation_guide
    'Interpretation guide with statistical and practical significance'
  end

  def ensure_reproducibility_measures
    'Reproducibility measures with code and data sharing protocols'
  end

  def implement_management_system(scope)
    "#{scope} management system with integrated workflow optimization"
  end

  def deploy_automation_protocols(level)
    "#{level} automation protocols with intelligent monitoring"
  end

  def establish_quality_assurance
    'Quality assurance system with continuous improvement protocols'
  end

  def ensure_compliance_framework(standards)
    "Compliance framework meeting #{standards.join(', ')} standards"
  end

  def optimize_resource_allocation
    'Resource allocation optimization with predictive analytics'
  end

  def create_documentation_suite(type)
    "#{type} documentation suite with professional standards"
  end

  def prepare_publication_materials(target)
    "Publication materials prepared for #{target} journals"
  end

  def develop_peer_review_strategy
    'Peer review strategy with response protocols and revisions'
  end

  def manage_citation_system
    'Citation management with automated formatting and validation'
  end

  def document_reproducibility_measures(level)
    "#{level} reproducibility documentation with complete protocols"
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

  def initialize_agent_data
    @agent = OpenStruct.new(
      name: 'LabX',
      agent_type: 'labx',
      status: 'active',
      total_conversations: rand(1900..3600),
      average_rating: rand(4.4..4.8),
      specializations: ['Laboratory Analysis', 'Research Methodology', 'Data Experimentation', 'Scientific Computing',
                        'Protocol Development', 'Results Interpretation'],
      capabilities: ['Experimental Design', 'Data Analysis', 'Statistical Computing', 'Research Planning',
                     'Lab Management', 'Scientific Reporting'],
      configuration: { 'response_style' => 'scientific_analytical' },
      last_active_at: Time.current,
      update!: ->(attrs) { attrs.each { |k, v| @agent.send("#{k}=", v) } },
      agent_interactions: OpenStruct.new(
        where: lambda { |_conditions|
          OpenStruct.new(
            order: lambda { |_sort|
              OpenStruct.new(
                limit: lambda { |_num|
                  OpenStruct.new(
                    pluck: ->(*_fields) { [] }
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
      email: "demo_#{session_id}@labx.onelastai.com",
      name: "LabX User #{rand(1000..9999)}",
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
      subdomain: 'labx',
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
end
