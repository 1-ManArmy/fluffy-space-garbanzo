# frozen_string_literal: true

# CineGen Agent Engine - Specialized AI engine for cinematic video generation
class CinegenAgentEngine < AiAgentEngine
  CINEMATIC_STYLES = %w[
    cinematic documentary artistic commercial vintage modern noir sci-fi fantasy drama
  ].freeze

  SCENE_TYPES = %w[
    opening_sequence character_introduction dialogue_scene action_sequence
    emotional_moment transition climax resolution montage establishing_shot
  ].freeze

  def initialize(agent, options = {})
    super(agent, options.merge(model_name: 'gpt_oss')) # Use creative model for CineGen
  end

  # Override the main processing to handle video-specific requests
  def process_request(input_data, context = {})
    # Detect if this is a video generation request
    if video_generation_request?(input_data)
      process_video_generation(input_data, context)
    elsif scene_composition_request?(input_data)
      process_scene_composition(input_data, context)
    elsif storyboard_request?(input_data)
      process_storyboard_creation(input_data, context)
    else
      super(input_data, context)
    end
  end

  private

  def video_generation_request?(input_data)
    text = extract_user_input(input_data).downcase
    text.match?(/\b(generate|create|make|produce).*video\b/i) ||
      text.match?(/\b(video|movie|film|cinematic)\b/i)
  end

  def scene_composition_request?(input_data)
    text = extract_user_input(input_data).downcase
    text.match?(/\b(scene|composition|shot|camera)\b/i)
  end

  def storyboard_request?(input_data)
    text = extract_user_input(input_data).downcase
    text.match?(/\b(storyboard|story.*board|visual.*plan)\b/i)
  end

  def process_video_generation(input_data, context)
    user_input = extract_user_input(input_data)

    # Enhanced prompt for video generation
    enhanced_prompt = build_cinematic_prompt(user_input, 'video_generation', context)

    # Generate response using AI model
    model_response = AiModelService.generate(@model_name, enhanced_prompt, cinematic_generation_options)

    if model_response[:success]
      # Parse and structure the video generation response
      structured_response = structure_video_response(model_response[:response], user_input)

      # Store in agent memory
      store_video_generation_memory(user_input, structured_response, context)

      {
        success: true,
        response: structured_response[:formatted_response],
        video_plan: structured_response[:video_plan],
        agent_id: @agent.id.to_s,
        agent_name: @agent.name,
        model_used: @model_name,
        processing_time_ms: model_response[:processing_time_ms],
        tokens_used: model_response[:tokens_used],
        interaction_type: 'video_generation',
        metadata: {
          style_detected: structured_response[:style],
          scene_count: structured_response[:scene_count],
          timestamp: Time.current
        }
      }
    else
      super(input_data, context)
    end
  rescue StandardError => e
    Rails.logger.error "CineGen Video Generation Error: #{e.message}"
    super(input_data, context)
  end

  def process_scene_composition(input_data, context)
    user_input = extract_user_input(input_data)

    enhanced_prompt = build_cinematic_prompt(user_input, 'scene_composition', context)
    model_response = AiModelService.generate(@model_name, enhanced_prompt, cinematic_generation_options)

    if model_response[:success]
      structured_response = structure_scene_response(model_response[:response], user_input)

      {
        success: true,
        response: structured_response[:formatted_response],
        scene_details: structured_response[:scene_details],
        agent_id: @agent.id.to_s,
        agent_name: @agent.name,
        interaction_type: 'scene_composition',
        timestamp: Time.current
      }
    else
      super(input_data, context)
    end
  end

  def process_storyboard_creation(input_data, context)
    user_input = extract_user_input(input_data)

    enhanced_prompt = build_cinematic_prompt(user_input, 'storyboard_creation', context)
    model_response = AiModelService.generate(@model_name, enhanced_prompt, cinematic_generation_options)

    if model_response[:success]
      structured_response = structure_storyboard_response(model_response[:response], user_input)

      {
        success: true,
        response: structured_response[:formatted_response],
        storyboard_frames: structured_response[:frames],
        agent_id: @agent.id.to_s,
        agent_name: @agent.name,
        interaction_type: 'storyboard_creation',
        timestamp: Time.current
      }
    else
      super(input_data, context)
    end
  end

  def build_cinematic_prompt(user_input, task_type, _context)
    prompt = @personality

    case task_type
    when 'video_generation'
      prompt += "TASK: Video Generation and Planning\n"
      prompt += "Available styles: #{CINEMATIC_STYLES.join(', ')}\n"
      prompt += "Scene types: #{SCENE_TYPES.join(', ')}\n\n"
    when 'scene_composition'
      prompt += "TASK: Scene Composition and Camera Work\n"
      prompt += "Focus on: camera angles, lighting, composition, movement\n\n"
    when 'storyboard_creation'
      prompt += "TASK: Storyboard Creation\n"
      prompt += "Create a detailed visual plan with frame descriptions\n\n"
    end

    prompt += "User Request: #{user_input}\n\n"
    prompt += "Provide a detailed, professional response with specific technical details.\n"
    prompt += "#{@agent.name}:"

    prompt
  end

  def structure_video_response(raw_response, user_input)
    # Parse the AI response and extract video plan elements
    style = detect_style(raw_response) || 'cinematic'
    scene_count = count_scenes(raw_response)

    video_plan = {
      title: extract_title(raw_response, user_input),
      style: style,
      duration: extract_duration(raw_response),
      scenes: extract_scenes(raw_response),
      technical_specs: extract_technical_specs(raw_response)
    }

    {
      formatted_response: raw_response,
      video_plan: video_plan,
      style: style,
      scene_count: scene_count
    }
  end

  def structure_scene_response(raw_response, _user_input)
    scene_details = {
      camera_angle: extract_camera_info(raw_response),
      lighting: extract_lighting_info(raw_response),
      composition: extract_composition_info(raw_response),
      movement: extract_movement_info(raw_response)
    }

    {
      formatted_response: raw_response,
      scene_details: scene_details
    }
  end

  def structure_storyboard_response(raw_response, _user_input)
    frames = extract_storyboard_frames(raw_response)

    {
      formatted_response: raw_response,
      frames: frames
    }
  end

  def detect_style(text)
    CINEMATIC_STYLES.find { |style| text.downcase.include?(style) }
  end

  def count_scenes(text)
    # Count scene references in the response
    scene_matches = text.scan(/scene\s+\d+|shot\s+\d+|\d+\.\s/i)
    [scene_matches.length, 1].max
  end

  def extract_title(text, user_input)
    # Try to extract a title from the response or generate from user input
    title_match = text.match(/title[:\s]+([^\n]+)/i)
    return title_match[1].strip if title_match

    # Generate from user input
    words = user_input.split(' ').first(4)
    words.map(&:capitalize).join(' ')
  end

  def extract_duration(text)
    duration_match = text.match(/(\d+)\s*(minutes?|mins?|seconds?|secs?)/i)
    return "#{duration_match[1]} #{duration_match[2]}" if duration_match

    '2-3 minutes' # Default
  end

  def extract_scenes(text)
    scenes = []
    scene_blocks = text.split(/scene\s+\d+|shot\s+\d+/i)[1..-1] || []

    scene_blocks.each_with_index do |block, index|
      scenes << {
        number: index + 1,
        description: block.strip.split("\n").first(3).join(' '),
        type: detect_scene_type(block)
      }
    end

    scenes.any? ? scenes : [{ number: 1, description: text[0..200], type: 'general' }]
  end

  def detect_scene_type(text)
    SCENE_TYPES.find { |type| text.downcase.include?(type.tr('_', ' ')) } || 'general'
  end

  def extract_technical_specs(text)
    {
      resolution: text.match(/(\d+p|4k|hd)/i)&.to_s || '1080p',
      fps: text.match(/(\d+)\s*fps/i)&.captures&.first || '24',
      aspect_ratio: text.match(/(16:9|4:3|21:9)/i)&.to_s || '16:9'
    }
  end

  def extract_camera_info(text)
    camera_terms = %w[close-up wide-shot medium-shot overhead aerial drone handheld steadicam]
    camera_terms.find { |term| text.downcase.include?(term) } || 'medium-shot'
  end

  def extract_lighting_info(text)
    lighting_terms = %w[natural dramatic soft harsh golden-hour blue-hour backlit silhouette]
    lighting_terms.find { |term| text.downcase.include?(term) } || 'natural'
  end

  def extract_composition_info(text)
    composition_terms = %w[rule-of-thirds centered symmetrical leading-lines framing]
    composition_terms.find { |term| text.downcase.include?(term.tr('-', ' ')) } || 'rule-of-thirds'
  end

  def extract_movement_info(text)
    movement_terms = %w[static pan tilt zoom dolly tracking handheld]
    movement_terms.find { |term| text.downcase.include?(term) } || 'static'
  end

  def extract_storyboard_frames(text)
    frames = []
    frame_blocks = text.split(/frame\s+\d+|panel\s+\d+/i)[1..-1] || []

    frame_blocks.each_with_index do |block, index|
      frames << {
        number: index + 1,
        description: block.strip.split("\n").first,
        shot_type: extract_camera_info(block),
        notes: block.strip.split("\n")[1..-1]&.join(' ')
      }
    end

    frames
  end

  def store_video_generation_memory(user_input, structured_response, _context)
    AgentMemory.store_memory(
      @agent,
      'video_generation',
      "project_#{Time.current.to_i}",
      {
        user_request: user_input,
        video_plan: structured_response[:video_plan],
        style: structured_response[:style],
        generated_at: Time.current
      },
      {
        expires_at: 7.days.from_now,
        importance_score: 8.0,
        tags: ['video', 'generation', structured_response[:style]]
      }
    )
  end

  def cinematic_generation_options
    {
      temperature: 0.8, # Higher creativity for cinematic content
      max_tokens: 3000, # More tokens for detailed video plans
      top_p: 0.95
    }
  end

  def apply_agent_specific_processing(response, _input_data, _context)
    # Add CineGen-specific formatting
    if response.length > 50
      # Add cinematic emoji and formatting
      response = "🎬 #{response}" unless response.start_with?('🎬')

      # Enhance with cinematic language
      response = enhance_cinematic_language(response)
    end

    response
  end

  def enhance_cinematic_language(text)
    # Add cinematic terminology and style
    text.gsub(/\bvideo\b/i, 'cinematic piece')
        .gsub(/\bmake\b/i, 'craft')
        .gsub(/\bcreate\b/i, 'envision')
  end
end
