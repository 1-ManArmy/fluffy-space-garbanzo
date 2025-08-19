Rails.application.routes.draw do
  get 'home/index'
  # Agent subdomains
  constraints subdomain: 'neochat' do
    root 'neochat#index', as: :neochat_root
    post '/chat', to: 'neochat#chat'
    get '/status', to: 'neochat#status'
  end

  # EmotiSense subdomain routes
  constraints subdomain: 'emotisense' do
    root 'emotisense#index', as: :emotisense_root
    post '/process_emotion', to: 'emotisense#process_emotion'
    get '/emotion_chat', to: 'emotisense#emotion_chat'
    get '/mood_journal', to: 'emotisense#mood_journal'
    post '/mood_journal', to: 'emotisense#mood_journal'
    get '/emotion_dashboard', to: 'emotisense#emotion_dashboard'
    get '/empathy_training', to: 'emotisense#empathy_training'
    post '/process_empathy_response', to: 'emotisense#process_empathy_response'
    get '/wellness_center', to: 'emotisense#wellness_center'
    post '/analyze_voice', to: 'emotisense#analyze_voice'
    get '/export_data', to: 'emotisense#export_data'
  end

  # CineGen subdomain routes
  constraints subdomain: 'cinegen' do
    root 'cinegen#index', as: :cinegen_root
    post '/generate_video', to: 'cinegen#generate_video'
    post '/compose_scenes', to: 'cinegen#compose_scenes'
    get '/render_progress', to: 'cinegen#render_progress'
    post '/apply_emotion_sync', to: 'cinegen#apply_emotion_sync'
    get '/visual_styles', to: 'cinegen#visual_styles'
    post '/select_soundtrack', to: 'cinegen#select_soundtrack'
    get '/export_video', to: 'cinegen#export_video'
    post '/terminal_command', to: 'cinegen#terminal_command'
  end

  # ContentCrafter subdomain routes
  constraints subdomain: 'contentcrafter' do
    root 'contentcrafter#index', as: :contentcrafter_root
    post '/generate_content', to: 'contentcrafter#generate_content'
    get '/content_formats', to: 'contentcrafter#get_content_formats'
    post '/preview_content', to: 'contentcrafter#preview_content'
    post '/export_content', to: 'contentcrafter#export_content'
    post '/analyze_content', to: 'contentcrafter#analyze_content'
    post '/fusion_generate', to: 'contentcrafter#fusion_generate'
    post '/terminal_command', to: 'contentcrafter#terminal_command'
  end

  # Memora subdomain routes
  constraints subdomain: 'memora' do
    root 'memora#index', as: :memora_root
    post '/store_memory', to: 'memora#store_memory'
    post '/recall_memory', to: 'memora#recall_memory'
    post '/search_memories', to: 'memora#search_memories'
    post '/process_voice', to: 'memora#process_voice'
    post '/voice_input', to: 'memora#voice_input'
    post '/upload_file', to: 'memora#upload_file'
    get '/download_file/:id', to: 'memora#download_file'
    post '/extract_pdf_text', to: 'memora#extract_pdf_text'
    post '/text_to_speech', to: 'memora#text_to_speech'
    post '/search_files', to: 'memora#search_files'
    get '/memory_stats', to: 'memora#get_memory_stats'
    get '/memory_insights', to: 'memora#get_memory_insights'
    post '/export_memories', to: 'memora#export_memories'
    get '/memory_types', to: 'memora#get_memory_types'
    get '/memory_graph', to: 'memora#memory_graph'
    post '/terminal_command', to: 'memora#terminal_command'
  end

  # NetScope subdomain routes
  constraints subdomain: 'netscope' do
    root 'netscope#index', as: :netscope_root
    post '/scan_target', to: 'netscope#scan_target'
    post '/port_scan', to: 'netscope#port_scan'
    post '/whois_lookup', to: 'netscope#whois_lookup'
    post '/dns_lookup', to: 'netscope#dns_lookup'
    post '/threat_check', to: 'netscope#threat_check'
    post '/ssl_analysis', to: 'netscope#ssl_analysis'
    post '/comprehensive_scan', to: 'netscope#comprehensive_scan'
    get '/get_scan_history', to: 'netscope#get_scan_history'
    post '/export_results', to: 'netscope#export_results'
    get '/get_network_tools', to: 'netscope#get_network_tools'
    post '/terminal_command', to: 'netscope#terminal_command'
  end

  # Test route for NeoChat (temporary)
  get '/neochat', to: 'neochat#index'
  post '/neochat/chat', to: 'neochat#chat'
  post '/neochat/clear', to: 'neochat#clear'
  get '/neochat/status', to: 'neochat#status'

  # EmotiSense development routes
  get '/emotisense', to: 'emotisense#index'
  post '/emotisense/chat', to: 'emotisense#chat'
  post '/emotisense/process_emotion', to: 'emotisense#process_emotion'
  get '/emotisense/emotion_chat', to: 'emotisense#emotion_chat'
  get '/emotisense/mood_journal', to: 'emotisense#mood_journal'
  post '/emotisense/mood_journal', to: 'emotisense#mood_journal'
  get '/emotisense/emotion_dashboard', to: 'emotisense#emotion_dashboard'
  get '/emotisense/empathy_training', to: 'emotisense#empathy_training'
  post '/emotisense/process_empathy_response', to: 'emotisense#process_empathy_response'
  get '/emotisense/wellness_center', to: 'emotisense#wellness_center'
  post '/emotisense/analyze_voice', to: 'emotisense#analyze_voice'
  get '/emotisense/export_data', to: 'emotisense#export_data'
  post '/emotisense/emotion_detection', to: 'emotisense#emotion_detection'
  post '/emotisense/sentiment_analysis', to: 'emotisense#sentiment_analysis'
  post '/emotisense/mood_tracking', to: 'emotisense#mood_tracking'
  post '/emotisense/therapeutic_support', to: 'emotisense#therapeutic_support'
  post '/emotisense/emotional_coaching', to: 'emotisense#emotional_coaching'
  post '/emotisense/wellness_assessment', to: 'emotisense#wellness_assessment'
  get '/emotisense/emotion_chat', to: 'emotisense#emotion_chat'
  get '/emotisense/mood_journal', to: 'emotisense#mood_journal'
  post '/emotisense/mood_journal', to: 'emotisense#mood_journal'
  get '/emotisense/emotion_dashboard', to: 'emotisense#emotion_dashboard'
  get '/emotisense/empathy_training', to: 'emotisense#empathy_training'
  post '/emotisense/process_empathy_response', to: 'emotisense#process_empathy_response'
  get '/emotisense/wellness_center', to: 'emotisense#wellness_center'
  post '/emotisense/analyze_voice', to: 'emotisense#analyze_voice'
  get '/emotisense/export_data', to: 'emotisense#export_data'

  # EmotiSense specialized emotional intelligence endpoints
  post '/emotisense/emotion_detection', to: 'emotisense#emotion_detection'
  post '/emotisense/sentiment_analysis', to: 'emotisense#sentiment_analysis'
  post '/emotisense/mood_tracking', to: 'emotisense#mood_tracking'
  post '/emotisense/therapeutic_support', to: 'emotisense#therapeutic_support'
  post '/emotisense/emotional_coaching', to: 'emotisense#emotional_coaching'
  post '/emotisense/wellness_assessment', to: 'emotisense#wellness_assessment'
  get '/emotisense/status', to: 'emotisense#status'

  # CineGen development routes
  get '/cinegen', to: 'cinegen#index'
  post '/cinegen/chat', to: 'cinegen#chat'
  post '/cinegen/generate_video', to: 'cinegen#generate_video'
  post '/cinegen/compose_scenes', to: 'cinegen#compose_scenes'
  get '/cinegen/render_progress', to: 'cinegen#render_progress'
  post '/cinegen/apply_emotion_sync', to: 'cinegen#apply_emotion_sync'
  get '/cinegen/visual_styles', to: 'cinegen#visual_styles'
  post '/cinegen/select_soundtrack', to: 'cinegen#select_soundtrack'
  get '/cinegen/export_video', to: 'cinegen#export_video'
  post '/cinegen/terminal_command', to: 'cinegen#terminal_command'

  # CineGen navigation routes
  get '/cinegen/scene_composer', to: 'cinegen#scene_composer', as: :scene_composer_cinegen
  get '/cinegen/render_dashboard', to: 'cinegen#render_dashboard', as: :render_dashboard_cinegen
  get '/cinegen/video_player', to: 'cinegen#video_player', as: :video_player_cinegen
  get '/cinegen/analytics', to: 'cinegen#analytics', as: :analytics_cinegen

  # CineGen specialized cinematic AI endpoints
  post '/cinegen/video_generation', to: 'cinegen#video_generation'
  post '/cinegen/scene_composition', to: 'cinegen#scene_composition'
  post '/cinegen/visual_effects', to: 'cinegen#visual_effects'
  post '/cinegen/cinematic_storytelling', to: 'cinegen#cinematic_storytelling'
  post '/cinegen/post_production', to: 'cinegen#post_production'
  post '/cinegen/content_optimization', to: 'cinegen#content_optimization'
  get '/cinegen/status', to: 'cinegen#status'

  # ContentCrafter development routes
  get '/contentcrafter', to: 'contentcrafter#index'
  post '/contentcrafter/chat', to: 'contentcrafter#chat'
  post '/contentcrafter/generate_content', to: 'contentcrafter#generate_content'
  get '/contentcrafter/content_formats', to: 'contentcrafter#get_content_formats'
  post '/contentcrafter/preview_content', to: 'contentcrafter#preview_content'
  post '/contentcrafter/export_content', to: 'contentcrafter#export_content'
  post '/contentcrafter/analyze_content', to: 'contentcrafter#analyze_content'
  post '/contentcrafter/fusion_generate', to: 'contentcrafter#fusion_generate'
  post '/contentcrafter/terminal_command', to: 'contentcrafter#terminal_command'

  # ContentCrafter specialized endpoints
  post '/contentcrafter/copywriting', to: 'contentcrafter#copywriting_creation'
  post '/contentcrafter/content_strategy', to: 'contentcrafter#content_strategy_development'
  post '/contentcrafter/seo_optimization', to: 'contentcrafter#seo_optimization'
  post '/contentcrafter/format_generation', to: 'contentcrafter#multi_format_generation'
  post '/contentcrafter/brand_voice', to: 'contentcrafter#brand_voice_development'
  post '/contentcrafter/content_analytics', to: 'contentcrafter#content_analytics'

  # Memora specialized endpoints
  post '/memora/memory_storage', to: 'memora#memory_storage'
  post '/memora/knowledge_retrieval', to: 'memora#knowledge_retrieval'
  post '/memora/graph_analysis', to: 'memora#graph_analysis'
  post '/memora/learning_analytics', to: 'memora#learning_analytics'
  post '/memora/cognitive_enhancement', to: 'memora#cognitive_enhancement'
  post '/memora/memory_optimization', to: 'memora#memory_optimization'

  # NetScope specialized endpoints
  post '/netscope/network_analysis', to: 'netscope#network_analysis'
  post '/netscope/security_monitoring', to: 'netscope#security_monitoring'
  post '/netscope/threat_detection', to: 'netscope#threat_detection'
  post '/netscope/vulnerability_assessment', to: 'netscope#vulnerability_assessment'
  post '/netscope/compliance_auditing', to: 'netscope#compliance_auditing'
  post '/netscope/incident_response', to: 'netscope#incident_response'

  # TaskMaster specialized endpoints
  post '/taskmaster/project_management', to: 'taskmaster#project_management'
  post '/taskmaster/workflow_automation', to: 'taskmaster#workflow_automation'
  post '/taskmaster/resource_optimization', to: 'taskmaster#resource_optimization'
  post '/taskmaster/deadline_tracking', to: 'taskmaster#deadline_tracking'
  post '/taskmaster/team_coordination', to: 'taskmaster#team_coordination'
  post '/taskmaster/productivity_analytics', to: 'taskmaster#productivity_analytics'

  # Reportly specialized endpoints
  post '/reportly/business_intelligence', to: 'reportly#business_intelligence'
  post '/reportly/data_visualization', to: 'reportly#data_visualization'
  post '/reportly/automated_reporting', to: 'reportly#automated_reporting'
  post '/reportly/performance_analytics', to: 'reportly#performance_analytics'
  post '/reportly/executive_dashboards', to: 'reportly#executive_dashboards'
  post '/reportly/predictive_analytics', to: 'reportly#predictive_analytics'
  get '/contentcrafter/status', to: 'contentcrafter#status'

  # Memora development routes
  get '/memora', to: 'memora#index'
  post '/memora/store_memory', to: 'memora#store_memory'
  post '/memora/recall_memory', to: 'memora#recall_memory'
  post '/memora/search_memories', to: 'memora#search_memories'
  post '/memora/process_voice', to: 'memora#process_voice'
  post '/memora/voice_input', to: 'memora#voice_input'
  post '/memora/upload_file', to: 'memora#upload_file'
  get '/memora/download_file/:id', to: 'memora#download_file'
  post '/memora/extract_pdf_text', to: 'memora#extract_pdf_text'
  post '/memora/text_to_speech', to: 'memora#text_to_speech'
  post '/memora/search_files', to: 'memora#search_files'
  get '/memora/memory_stats', to: 'memora#get_memory_stats'
  get '/memora/memory_insights', to: 'memora#get_memory_insights'
  post '/memora/export_memories', to: 'memora#export_memories'
  get '/memora/memory_types', to: 'memora#get_memory_types'
  get '/memora/memory_graph', to: 'memora#memory_graph'
  post '/memora/terminal_command', to: 'memora#terminal_command'

  # NetScope development routes
  get '/netscope', to: 'netscope#index'
  post '/netscope/scan_target', to: 'netscope#scan_target'
  post '/netscope/port_scan', to: 'netscope#port_scan'
  post '/netscope/whois_lookup', to: 'netscope#whois_lookup'
  post '/netscope/dns_lookup', to: 'netscope#dns_lookup'
  post '/netscope/threat_check', to: 'netscope#threat_check'
  post '/netscope/ssl_analysis', to: 'netscope#ssl_analysis'
  post '/netscope/comprehensive_scan', to: 'netscope#comprehensive_scan'
  get '/netscope/get_scan_history', to: 'netscope#get_scan_history'
  post '/netscope/export_results', to: 'netscope#export_results'
  get '/netscope/get_network_tools', to: 'netscope#get_network_tools'
  post '/netscope/terminal_command', to: 'netscope#terminal_command'

  # Additional Agent Routes - Each with their own controller

  # TradeSage routes (NEW Financial AI Agent)
  get '/tradesage', to: 'tradesage#index'
  post '/tradesage/chat', to: 'tradesage#chat'
  post '/tradesage/analyze_stock', to: 'tradesage#analyze_stock'
  post '/tradesage/portfolio_analysis', to: 'tradesage#portfolio_analysis'
  post '/tradesage/market_sentiment', to: 'tradesage#market_sentiment'
  post '/tradesage/risk_assessment', to: 'tradesage#risk_assessment'
  post '/tradesage/generate_strategy', to: 'tradesage#generate_strategy'
  post '/tradesage/market_news', to: 'tradesage#market_news'
  post '/tradesage/technical_analysis', to: 'tradesage#technical_analysis'

  # CodeMaster routes (NEW AI Agent)
  get '/codemaster', to: 'codemaster#index'
  post '/codemaster/chat', to: 'codemaster#chat'
  post '/codemaster/analyze_code', to: 'codemaster#analyze_code'
  post '/codemaster/generate_code', to: 'codemaster#generate_code'
  post '/codemaster/debug_code', to: 'codemaster#debug_code'
  post '/codemaster/optimize_code', to: 'codemaster#optimize_code'
  post '/codemaster/code_review', to: 'codemaster#code_review'
  post '/codemaster/explain_code', to: 'codemaster#explain_code'

  # AIBlogster routes
  get '/aiblogster', to: 'aiblogster#index'
  post '/aiblogster/chat', to: 'aiblogster#chat'
  post '/aiblogster/generate_blog_post', to: 'aiblogster#generate_blog_post'
  post '/aiblogster/analyze_content', to: 'aiblogster#analyze_content'
  post '/aiblogster/optimize_seo', to: 'aiblogster#optimize_seo'
  post '/aiblogster/generate_ideas', to: 'aiblogster#generate_ideas'

  # DataVision routes
  get '/datavision', to: 'datavision#index'
  post '/datavision/chat', to: 'datavision#chat'
  post '/datavision/create_chart', to: 'datavision#create_chart'
  post '/datavision/analyze_dataset', to: 'datavision#analyze_dataset'
  post '/datavision/generate_dashboard', to: 'datavision#generate_dashboard'
  get '/datavision/status', to: 'datavision#status'

  # InfoSeek routes
  get '/infoseek', to: 'infoseek#index'
  post '/infoseek/chat', to: 'infoseek#chat'
  post '/infoseek/deep_research', to: 'infoseek#deep_research'
  post '/infoseek/fact_check', to: 'infoseek#fact_check'
  post '/infoseek/research_assistant', to: 'infoseek#research_assistant'
  post '/infoseek/trend_analysis', to: 'infoseek#trend_analysis'
  get '/infoseek/status', to: 'infoseek#status'

  # DocuMind routes
  get '/documind', to: 'documind#index'
  post '/documind/chat', to: 'documind#chat'
  post '/documind/analyze_document', to: 'documind#analyze_document'
  post '/documind/extract_entities', to: 'documind#extract_entities'
  post '/documind/generate_summary', to: 'documind#generate_summary'
  post '/documind/classify_document', to: 'documind#classify_document'
  post '/documind/translate_document', to: 'documind#translate_document'
  get '/documind/status', to: 'documind#status'

  # CareBot routes
  get '/carebot', to: 'carebot#index'
  post '/carebot/chat', to: 'carebot#chat'
  post '/carebot/symptom_checker', to: 'carebot#symptom_checker'
  post '/carebot/wellness_plan', to: 'carebot#wellness_plan'
  post '/carebot/medication_reminder', to: 'carebot#medication_reminder'
  post '/carebot/mental_health_support', to: 'carebot#mental_health_support'
  post '/carebot/fitness_tracker', to: 'carebot#fitness_tracker'
  get '/carebot/status', to: 'carebot#status'

  # PersonaX routes
  get '/personax', to: 'personax#index'
  post '/personax/chat', to: 'personax#chat'

  # PersonaX specialized personality endpoints
  post '/personax/personality_analysis', to: 'personax#personality_analysis'
  post '/personax/mbti_assessment', to: 'personax#mbti_assessment'
  post '/personax/behavioral_insights', to: 'personax#behavioral_insights'
  post '/personax/compatibility_check', to: 'personax#relationship_compatibility'
  post '/personax/development_plan', to: 'personax#personal_development'
  get '/personax/status', to: 'personax#status'

  # AuthWise routes
  get '/authwise', to: 'authwise#index'
  post '/authwise/chat', to: 'authwise#chat'

  # AuthWise specialized security endpoints
  post '/authwise/vulnerability_assessment', to: 'authwise#vulnerability_assessment'
  post '/authwise/security_audit', to: 'authwise#security_audit'
  post '/authwise/access_control_analysis', to: 'authwise#access_control_analysis'
  post '/authwise/penetration_test_report', to: 'authwise#penetration_test_report'
  get '/authwise/compliance_dashboard', to: 'authwise#compliance_dashboard'
  get '/authwise/status', to: 'authwise#status'

  # IdeaForge routes
  get '/ideaforge', to: 'ideaforge#index'
  post '/ideaforge/chat', to: 'ideaforge#chat'

  # IdeaForge specialized innovation endpoints
  post '/ideaforge/idea_generation', to: 'ideaforge#idea_generation'
  post '/ideaforge/creative_workshop', to: 'ideaforge#creative_workshop'
  post '/ideaforge/innovation_framework', to: 'ideaforge#innovation_framework'
  post '/ideaforge/trend_analysis', to: 'ideaforge#trend_analysis'
  post '/ideaforge/concept_development', to: 'ideaforge#concept_development'
  post '/ideaforge/collaboration_space', to: 'ideaforge#collaboration_space'
  get '/ideaforge/status', to: 'ideaforge#status'

  # VocaMind routes
  get '/vocamind', to: 'vocamind#index'
  post '/vocamind/chat', to: 'vocamind#chat'

  # VocaMind specialized voice and language endpoints
  post '/vocamind/speech_analysis', to: 'vocamind#speech_analysis'
  post '/vocamind/voice_synthesis', to: 'vocamind#voice_synthesis'
  post '/vocamind/accent_training', to: 'vocamind#accent_training'
  post '/vocamind/language_coaching', to: 'vocamind#language_coaching'
  post '/vocamind/phonetic_analysis', to: 'vocamind#phonetic_analysis'
  post '/vocamind/conversation_practice', to: 'vocamind#conversation_practice'
  get '/vocamind/status', to: 'vocamind#status'

  # TaskMaster routes
  get '/taskmaster', to: 'taskmaster#index'
  post '/taskmaster/chat', to: 'taskmaster#chat'

  # Reportly routes
  get '/reportly', to: 'reportly#index'
  post '/reportly/chat', to: 'reportly#chat'

  # DataSphere routes
  get '/datasphere', to: 'datasphere#index'
  post '/datasphere/chat', to: 'datasphere#chat'
  post '/datasphere/machine_learning', to: 'datasphere#machine_learning'
  post '/datasphere/statistical_analysis', to: 'datasphere#statistical_analysis'
  post '/datasphere/data_processing', to: 'datasphere#data_processing'
  post '/datasphere/deep_analytics', to: 'datasphere#deep_analytics'
  post '/datasphere/predictive_modeling', to: 'datasphere#predictive_modeling'
  post '/datasphere/ai_research', to: 'datasphere#ai_research'

  # ConfigAI routes
  get '/configai', to: 'configai#index'
  post '/configai/chat', to: 'configai#chat'
  post '/configai/system_configuration', to: 'configai#system_configuration'
  post '/configai/deployment_automation', to: 'configai#deployment_automation'
  post '/configai/environment_management', to: 'configai#environment_management'
  post '/configai/infrastructure_optimization', to: 'configai#infrastructure_optimization'
  post '/configai/security_configuration', to: 'configai#security_configuration'
  post '/configai/monitoring_setup', to: 'configai#monitoring_setup'

  # LabX routes
  get '/labx', to: 'labx#index'
  post '/labx/chat', to: 'labx#chat'
  post '/labx/research_methodologies', to: 'labx#research_methodologies'
  post '/labx/experimental_design', to: 'labx#experimental_design'
  post '/labx/data_collection', to: 'labx#data_collection'
  post '/labx/analysis_protocols', to: 'labx#analysis_protocols'
  post '/labx/laboratory_management', to: 'labx#laboratory_management'
  post '/labx/scientific_documentation', to: 'labx#scientific_documentation'

  # SpyLens routes
  get '/spylens', to: 'spylens#index'
  post '/spylens/chat', to: 'spylens#chat'
  post '/spylens/threat_intelligence', to: 'spylens#threat_intelligence'
  post '/spylens/data_mining', to: 'spylens#data_mining'
  post '/spylens/pattern_recognition', to: 'spylens#pattern_recognition'
  post '/spylens/surveillance_analytics', to: 'spylens#surveillance_analytics'
  post '/spylens/security_monitoring', to: 'spylens#security_monitoring'
  post '/spylens/intelligence_reporting', to: 'spylens#intelligence_reporting'

  # CallGhost Communication AI routes
  get '/callghost', to: 'callghost#index'
  post '/callghost/chat', to: 'callghost#chat'
  post '/callghost/call_management', to: 'callghost#call_management'
  post '/callghost/voice_processing', to: 'callghost#voice_processing'
  post '/callghost/communication_analysis', to: 'callghost#communication_analysis'
  post '/callghost/contact_optimization', to: 'callghost#contact_optimization'
  post '/callghost/interaction_tracking', to: 'callghost#interaction_tracking'
  post '/callghost/conversation_enhancement', to: 'callghost#conversation_enhancement'

  # DNAForge Genetic Analysis AI routes
  get '/dnaforge', to: 'dnaforge#index'
  post '/dnaforge/chat', to: 'dnaforge#chat'
  post '/dnaforge/dna_sequencing', to: 'dnaforge#dna_sequencing'
  post '/dnaforge/genetic_mapping', to: 'dnaforge#genetic_mapping'
  post '/dnaforge/trait_analysis', to: 'dnaforge#trait_analysis'
  post '/dnaforge/heredity_prediction', to: 'dnaforge#heredity_prediction'
  post '/dnaforge/genomic_insights', to: 'dnaforge#genomic_insights'
  post '/dnaforge/biotechnology_applications', to: 'dnaforge#biotechnology_applications'

  # DreamWeaver Creative AI routes
  get '/dreamweaver', to: 'dreamweaver#index'
  post '/dreamweaver/chat', to: 'dreamweaver#chat'
  post '/dreamweaver/story_generation', to: 'dreamweaver#story_generation'
  post '/dreamweaver/creative_writing', to: 'dreamweaver#creative_writing'
  post '/dreamweaver/artistic_inspiration', to: 'dreamweaver#artistic_inspiration'
  post '/dreamweaver/imagination_enhancement', to: 'dreamweaver#imagination_enhancement'
  post '/dreamweaver/narrative_development', to: 'dreamweaver#narrative_development'
  post '/dreamweaver/creative_collaboration', to: 'dreamweaver#creative_collaboration'

  # NeoChat Conversational AI routes
  get '/neochat', to: 'neochat#index'
  post '/neochat/chat', to: 'neochat#chat'
  post '/neochat/natural_language_processing', to: 'neochat#natural_language_processing'
  post '/neochat/contextual_understanding', to: 'neochat#contextual_understanding'
  post '/neochat/dialogue_management', to: 'neochat#dialogue_management'
  post '/neochat/personality_adaptation', to: 'neochat#personality_adaptation'
  post '/neochat/emotional_intelligence', to: 'neochat#emotional_intelligence'
  post '/neochat/conversational_optimization', to: 'neochat#conversational_optimization'

  # Platform Pages
  get '/about', to: 'pages#about'
  get '/contact', to: 'pages#contact'
  post '/contact', to: 'pages#contact_submit'
  get '/blog', to: 'pages#blog'
  get '/news', to: 'pages#news'
  get '/faq', to: 'pages#faq'
  get '/signup', to: 'pages#signup'
  post '/signup', to: 'pages#signup_submit'
  get '/login', to: 'pages#login'
  post '/login', to: 'pages#login_submit'
  get '/logout', to: 'pages#logout'

  # CTA Section Routes
  get '/get-started', to: 'pages#get_started'
  get '/schedule-demo', to: 'pages#schedule_demo'
  post '/schedule-demo', to: 'pages#schedule_demo_submit'
  get '/start-free', to: 'pages#start_free'

  # User Dashboard & Account
  get '/dashboard', to: 'pages#dashboard'
  get '/my-agents', to: 'pages#my_agents'
  get '/agents', to: 'pages#agents'
  get '/settings', to: 'pages#settings'
  post '/settings', to: 'pages#settings_update'
  get '/billing', to: 'pages#billing'
  get '/subscriptions', to: 'pages#subscriptions'
  post '/billing/update', to: 'pages#billing_update'

  # Platform Features
  get '/api-docs', to: 'pages#api_docs'
  get '/integrations', to: 'pages#integrations'
  get '/templates', to: 'pages#templates'
  get '/support', to: 'pages#support'
  post '/support/ticket', to: 'pages#support_ticket'

  # Community Routes
  namespace :community do
    get '/', to: 'community#index', as: :root
    get '/forum', to: 'community#forum'
    get '/forum/:category', to: 'community#forum_category'
    post '/forum/post', to: 'community#create_post'
    get '/forum/post/:id', to: 'community#show_post'
    post '/forum/reply', to: 'community#create_reply'
  end

  # Documentation Routes
  get '/docs', to: 'docs#index'
  get '/docs/:section', to: 'docs#section'
  get '/docs/:section/:topic', to: 'docs#topic'

  # Learning Routes
  get '/learn', to: 'learn#index'
  get '/learn/tutorials', to: 'learn#tutorials'
  get '/learn/tutorial/:id', to: 'learn#tutorial'
  get '/learn/paths', to: 'learn#paths'
  get '/learn/path/:id', to: 'learn#path'

  # Press & Awards Routes
  get '/press', to: 'press#index'
  get '/press/:publication', to: 'press#show'
  get '/awards', to: 'awards#index'
  get '/awards/:award', to: 'awards#show'

  # Features Routes
  get '/features', to: 'features#index'
  get '/features/conversational-ai', to: 'features#conversational_ai'
  get '/features/content-media', to: 'features#content_media'
  get '/features/intelligence-analytics', to: 'features#intelligence_analytics'

  # Infrastructure Routes
  get '/infrastructure', to: 'infrastructure#index'
  get '/infrastructure/tech-stack', to: 'infrastructure#tech_stack'
  get '/infrastructure/security', to: 'infrastructure#security'
  get '/infrastructure/deployment', to: 'infrastructure#deployment'

  # Newsletter Routes
  get '/newsletter', to: 'pages#newsletter'
  post '/newsletter', to: 'pages#newsletter_subscribe'
  post '/newsletter/subscribe', to: 'pages#newsletter_subscribe'

  # Legal & Policy Pages
  get '/privacy', to: 'pages#privacy'
  get '/terms', to: 'pages#terms'
  get '/cookies', to: 'pages#cookies'

  # Admin Pages (Protected)
  get '/admin', to: 'admin#dashboard'
  get '/admin/users', to: 'admin#users'
  get '/admin/agents', to: 'admin#agents'
  get '/admin/reports', to: 'admin#reports'
  get '/admin/payments', to: 'admin#payments'
  get '/admin/analytics', to: 'admin#analytics'

  # Additional Platform Features
  get '/marketplace', to: 'pages#marketplace'
  get '/tutorials', to: 'pages#tutorials'
  get '/changelog', to: 'pages#changelog'
  get '/status-page', to: 'pages#status'
  get '/careers', to: 'pages#careers'
  get '/partners', to: 'pages#partners'
  get '/developers', to: 'pages#developers'

  # Main domain root - Modern Landing Page
  root 'home#index'

  # Health check endpoints
  get '/health', to: 'health#show'
  get '/ready', to: 'health#ready'

  # AI Agents API
  resources :agents, only: %i[index show] do
    member do
      post :chat
      get :status
      post :feedback
    end

    collection do
      get :personal_stats
      get :recommendations
    end
  end

  # API namespace for future expansion
  namespace :api do
    namespace :v1 do
      resources :agents, only: %i[index show] do
        member do
          post :chat
          get :status
          post :feedback
        end
      end
    end
  end

  # Girlfriend Companion & Wellness Agent
  scope module: 'girlfriend', path: 'girlfriend' do
    root 'girlfriend#index', as: 'girlfriend_root'
    post 'chat', to: 'girlfriend#chat', as: 'girlfriend_chat'
    post 'emotional_support', to: 'girlfriend#emotional_support', as: 'girlfriend_emotional_support'
    post 'relationship_guidance', to: 'girlfriend#relationship_guidance', as: 'girlfriend_relationship_guidance'
    post 'personal_conversations', to: 'girlfriend#personal_conversations', as: 'girlfriend_personal_conversations'
    post 'wellness_coaching', to: 'girlfriend#wellness_coaching', as: 'girlfriend_wellness_coaching'
    post 'activity_planning', to: 'girlfriend#activity_planning', as: 'girlfriend_activity_planning'
    post 'companion_interactions', to: 'girlfriend#companion_interactions', as: 'girlfriend_companion_interactions'
    get 'status', to: 'girlfriend#status', as: 'girlfriend_status'
  end
end
