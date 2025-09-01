# frozen_string_literal: true

module EmotisenseHelper
  # Enhanced emotion mappings for production-ready experience
  def emotion_emoji(emotion)
    emotion_map = {
      'joy' => '😊', 'happiness' => '�', 'ecstasy' => '🤩', 'elation' => '😆',
      'sadness' => '😢', 'melancholy' => '�', 'grief' => '😭', 'sorrow' => '😞',
      'anger' => '😠', 'rage' => '🤬', 'frustration' => '�', 'annoyance' => '😑',
      'fear' => '😰', 'anxiety' => '😟', 'worry' => '😦', 'panic' => '😱',
      'excitement' => '🤩', 'enthusiasm' => '🥳', 'anticipation' => '😃',
      'love' => '😍', 'affection' => '�', 'adoration' => '😘', 'devotion' => '💕',
      'calm' => '😌', 'peace' => '☮️', 'serenity' => '🧘‍♀️', 'tranquility' => '🕊️',
      'surprise' => '😮', 'amazement' => '😲', 'wonder' => '🤯',
      'disgust' => '🤢', 'contempt' => '😒', 'disdain' => '�',
      'pride' => '😎', 'confidence' => '💪', 'satisfaction' => '😊',
      'shame' => '😳', 'guilt' => '😰', 'embarrassment' => '😅',
      'envy' => '😒', 'jealousy' => '😠', 'resentment' => '�',
      'hope' => '🌟', 'optimism' => '🌈', 'faith' => '✨',
      'loneliness' => '😔', 'isolation' => '🏝️', 'abandonment' => '�',
      'stress' => '😵‍💫', 'overwhelm' => '🤯', 'burnout' => '😴',
      'gratitude' => '🙏', 'appreciation' => '💖', 'thankfulness' => '🌺'
    }
    emotion_map[emotion.to_s] || '😐'
  end

  def get_emotion_color(emotion)
    # Advanced color psychology mapping for emotional intelligence
    color_map = {
      # Joy family - warm, energizing colors
      'joy' => '#ffd700', 'happiness' => '#ffeb3b', 'ecstasy' => '#ff9800', 'elation' => '#ffc107',
      
      # Sadness family - cool, calming blues
      'sadness' => '#74b9ff', 'melancholy' => '#3498db', 'grief' => '#2980b9', 'sorrow' => '#5dade2',
      
      # Anger family - intense reds and oranges
      'anger' => '#ff7675', 'rage' => '#e74c3c', 'frustration' => '#ff6b6b', 'annoyance' => '#fd79a8',
      
      # Fear family - muted, uncertain colors
      'fear' => '#636e72', 'anxiety' => '#95a5a6', 'worry' => '#7f8c8d', 'panic' => '#34495e',
      
      # Excitement family - vibrant, dynamic colors
      'excitement' => '#fdcb6e', 'enthusiasm' => '#f39c12', 'anticipation' => '#e67e22',
      
      # Love family - warm pinks and roses
      'love' => '#fd79a8', 'affection' => '#e84393', 'adoration' => '#ff7675', 'devotion' => '#ff6b9d',
      
      # Calm family - peaceful greens and blues
      'calm' => '#00b894', 'peace' => '#55efc4', 'serenity' => '#81ecec', 'tranquility' => '#74b9ff',
      
      # Additional emotions with therapeutic color mapping
      'surprise' => '#a29bfe', 'amazement' => '#6c5ce7', 'wonder' => '#fd79a8',
      'disgust' => '#6c5ce7', 'contempt' => '#636e72', 'disdain' => '#95a5a6',
      'pride' => '#fdcb6e', 'confidence' => '#f39c12', 'satisfaction' => '#00b894',
      'shame' => '#ff7675', 'guilt' => '#636e72', 'embarrassment' => '#fd79a8',
      'envy' => '#00b894', 'jealousy' => '#636e72', 'resentment' => '#ff7675',
      'hope' => '#55efc4', 'optimism' => '#ffeaa7', 'faith' => '#a29bfe',
      'loneliness' => '#74b9ff', 'isolation' => '#636e72', 'abandonment' => '#95a5a6',
      'stress' => '#ff7675', 'overwhelm' => '#636e72', 'burnout' => '#95a5a6',
      'gratitude' => '#00b894', 'appreciation' => '#fd79a8', 'thankfulness' => '#fdcb6e',
      
      # Default
      'neutral' => '#6c5ce7'
    }
    color_map[emotion.to_s] || '#6c5ce7'
  end

  def emotion_intensity_color(emotion, intensity)
    base_color = get_emotion_color(emotion)
    
    # Advanced intensity mapping with therapeutic significance
    opacity = case intensity.to_s
    when 'minimal', 'barely_noticeable' then 0.2
    when 'low', 'mild' then 0.4
    when 'moderate', 'noticeable' then 0.6
    when 'high', 'strong' then 0.8
    when 'very_high', 'intense' then 0.9
    when 'extreme', 'overwhelming' then 1.0
    else 0.6
    end
    
    # Convert hex to rgba with therapeutic intensity mapping
    if base_color.match(/^#([A-Fa-f0-9]{6})$/)
      hex = base_color[1..-1]
      r = hex[0..1].to_i(16)
      g = hex[2..3].to_i(16)
      b = hex[4..5].to_i(16)
      "rgba(#{r}, #{g}, #{b}, #{opacity})"
    else
      base_color
    end
  end

  def emotion_class_name(emotion)
    "emotion-#{emotion.to_s.downcase.gsub(/[^a-z]/, '-')}"
  end

  def advanced_mood_description(mood, context = {})
    time_context = context[:time_of_day] || current_time_context
    intensity = context[:intensity] || 'moderate'
    
    descriptions = {
      'positive' => {
        'morning' => 'Starting the day with positive energy and optimism',
        'afternoon' => 'Maintaining good spirits and productivity',
        'evening' => 'Feeling satisfied and content with the day',
        'night' => 'Peaceful and grateful for positive experiences'
      },
      'negative' => {
        'morning' => 'Beginning the day with some emotional challenges',
        'afternoon' => 'Working through difficult feelings and situations',
        'evening' => 'Processing complex emotions from the day',
        'night' => 'Reflecting on challenges with compassion for yourself'
      },
      'neutral' => {
        'morning' => 'Centered and balanced as the day begins',
        'afternoon' => 'Maintaining emotional equilibrium',
        'evening' => 'Stable and grounded as evening approaches',
        'night' => 'Peaceful and emotionally balanced'
      },
      'agitated' => {
        'morning' => 'Feeling restless or unsettled early in the day',
        'afternoon' => 'Experiencing frustration or restlessness',
        'evening' => 'Working through feelings of agitation',
        'night' => 'Finding ways to calm restless energy'
      },
      'peaceful' => {
        'morning' => 'Awakening with calm and centered energy',
        'afternoon' => 'Maintaining inner peace throughout the day',
        'evening' => 'Embracing tranquility as day transitions to night',
        'night' => 'Deeply peaceful and ready for rest'
      }
    }
    
    base_description = descriptions.dig(mood.to_s, time_context) || 'Experiencing a range of emotions'
    
    # Add intensity context
    case intensity
    when 'high', 'very_high', 'extreme'
      "#{base_description}. This feeling is quite strong right now."
    when 'low', 'minimal'
      "#{base_description}. These feelings are gentle and manageable."
    else
      base_description
    end
  end

  def therapeutic_intensity_badge(intensity, emotion = nil)
    intensity_data = {
      'minimal' => { dots: 1, class: 'minimal', color: '#95a5a6', label: 'Minimal' },
      'low' => { dots: 2, class: 'low', color: '#74b9ff', label: 'Mild' },
      'moderate' => { dots: 3, class: 'moderate', color: '#fdcb6e', label: 'Moderate' },
      'high' => { dots: 4, class: 'high', color: '#fd79a8', label: 'Strong' },
      'very_high' => { dots: 5, class: 'very-high', color: '#ff7675', label: 'Intense' },
      'extreme' => { dots: 5, class: 'extreme', color: '#e74c3c', label: 'Overwhelming' }
    }
    
    data = intensity_data[intensity.to_s] || intensity_data['moderate']
    dots = '●' * data[:dots]
    
    content_tag(:span, dots, 
      class: "intensity-badge #{data[:class]}", 
      style: "color: #{data[:color]};",
      title: "#{data[:label]} intensity",
      data: { emotion: emotion, intensity: intensity }
    )
  end

  def current_time_context
    hour = Time.current.hour
    
    case hour
    when 5..11 then 'morning'
    when 12..17 then 'afternoon' 
    when 18..21 then 'evening'
    else 'night'
    end
  end

  def time_of_day_emotion_context
    hour = Time.current.hour
    
    case hour
    when 5..11
      { period: 'morning', context: 'Starting the day with intention', emoji: '🌅', energy: 'rising' }
    when 12..17
      { period: 'afternoon', context: 'Peak energy and productivity', emoji: '☀️', energy: 'high' }
    when 18..21
      { period: 'evening', context: 'Transitioning and reflecting', emoji: '🌆', energy: 'winding_down' }
    else
      { period: 'night', context: 'Rest and introspection', emoji: '🌙', energy: 'low' }
    end
  end

  def therapeutic_suggestion_icon(suggestion_type)
    # Evidence-based therapeutic intervention icons
    icons = {
      # Cognitive techniques
      'cognitive_reframing' => '🌌', 'thought_challenging' => '�', 'mindfulness' => '🧘‍♀️',
      
      # Behavioral interventions
      'physical_activity' => '🏃‍♀️', 'breathing_exercises' => '🫁', 'progressive_relaxation' => '😌',
      
      # Social and relational
      'social_connection' => '👥', 'communication' => '💬', 'boundary_setting' => '🛡️',
      
      # Creative and expressive
      'creative_expression' => '🎨', 'music_therapy' => '🎵', 'writing_therapy' => '📝',
      
      # Self-care and wellness
      'self_care' => '🛁', 'nutrition' => '�', 'sleep_hygiene' => '😴',
      
      # Nature and environment
      'nature_therapy' => '🌿', 'sunlight_exposure' => '☀️', 'grounding' => '🌍',
      
      # Professional support
      'therapy' => '👨‍⚕️', 'meditation_apps' => '📱', 'support_groups' => '🤝',
      
      # Crisis and emergency
      'crisis_support' => '🆘', 'emergency_contact' => '📞', 'safety_planning' => '🛡️'
    }
    icons[suggestion_type.to_s] || '💡'
  end

  def format_session_duration(minutes)
    return '0 min' if minutes.nil? || minutes <= 0
    
    if minutes < 60
      "#{minutes} min"
    elsif minutes < 1440 # less than a day
      hours = minutes / 60
      remaining_minutes = minutes % 60
      remaining_minutes > 0 ? "#{hours}h #{remaining_minutes}m" : "#{hours}h"
    else
      days = minutes / 1440
      remaining_hours = (minutes % 1440) / 60
      day_text = days == 1 ? 'day' : 'days'
      remaining_hours > 0 ? "#{days} #{day_text} #{remaining_hours}h" : "#{days} #{day_text}"
    end
  end

  def advanced_emotion_gradient_background(primary_emotion, secondary_emotion = nil, intensity = 'moderate')
    primary_color = get_emotion_color(primary_emotion)
    secondary_color = secondary_emotion ? get_emotion_color(secondary_emotion) : primary_color
    
    # Adjust opacity based on intensity for therapeutic visualization
    opacity = case intensity.to_s
    when 'minimal', 'low' then '11'
    when 'moderate' then '22'
    when 'high', 'very_high' then '33'
    when 'extreme' then '44'
    else '22'
    end
    
    "background: linear-gradient(135deg, #{primary_color}#{opacity} 0%, #{secondary_color}#{opacity} 100%)"
  end

  def wellness_activity_icon(activity_type)
    # Evidence-based wellness activities with therapeutic value
    icons = {
      # Mindfulness and meditation
      'breathing' => '🫁', 'meditation' => '🧘‍♀️', 'body_scan' => '🔍', 'loving_kindness' => '💕',
      
      # Physical wellness
      'movement' => '💃', 'yoga' => '🧘‍♀️', 'walking' => '🚶‍♀️', 'stretching' => '🤸‍♀️',
      
      # Creative and expressive
      'journaling' => '📓', 'art_therapy' => '🎨', 'music' => '🎶', 'dancing' => '💃',
      
      # Social and connection
      'social' => '🤗', 'volunteering' => '🤝', 'community' => '👥', 'family_time' => '👨‍👩‍👧‍👦',
      
      # Nature and environment
      'nature' => '🌲', 'gardening' => '🌱', 'sunrise_sunset' => '🌅', 'water_therapy' => '�',
      
      # Cognitive and learning
      'reading' => '📚', 'learning' => '🎓', 'puzzles' => '🧩', 'planning' => '📅',
      
      # Sensory and comfort
      'aromatherapy' => '🌸', 'tea_ceremony' => '🍵', 'warm_bath' => '🛁', 'massage' => '💆‍♀️',
      
      # Spiritual and meaning
      'gratitude' => '🙏', 'prayer' => '🕊️', 'ritual' => '🕯️', 'reflection' => '�'
    }
    icons[activity_type.to_s] || '✨'
  end

  def emotion_analysis_confidence_level(confidence)
    case confidence.to_f
    when 0.9..1.0 then { level: 'Very High', color: '#00b894', description: 'Highly confident analysis' }
    when 0.8..0.89 then { level: 'High', color: '#55efc4', description: 'Strong confidence in analysis' }
    when 0.7..0.79 then { level: 'Good', color: '#fdcb6e', description: 'Good confidence level' }
    when 0.6..0.69 then { level: 'Moderate', color: '#fd79a8', description: 'Moderate confidence' }
    when 0.5..0.59 then { level: 'Low', color: '#ff7675', description: 'Lower confidence analysis' }
    else { level: 'Very Low', color: '#636e72', description: 'Analysis may need refinement' }
    end
  end

  def therapeutic_recommendation_priority(recommendation_type)
    priorities = {
      'immediate_safety' => { priority: 1, urgency: 'critical', color: '#e74c3c' },
      'crisis_intervention' => { priority: 1, urgency: 'critical', color: '#e74c3c' },
      'professional_support' => { priority: 2, urgency: 'high', color: '#f39c12' },
      'coping_strategies' => { priority: 3, urgency: 'moderate', color: '#f1c40f' },
      'wellness_activities' => { priority: 4, urgency: 'beneficial', color: '#2ecc71' },
      'self_care' => { priority: 4, urgency: 'beneficial', color: '#2ecc71' },
      'monitoring' => { priority: 5, urgency: 'ongoing', color: '#3498db' }
    }
    
    priorities[recommendation_type.to_s] || { priority: 3, urgency: 'moderate', color: '#95a5a6' }
  end

  def format_emotional_timestamp(timestamp)
    return 'Unknown time' unless timestamp
    
    time = timestamp.is_a?(String) ? Time.parse(timestamp) : timestamp
    time_ago = Time.current - time
    
    case time_ago
    when 0..60 then 'Just now'
    when 61..3600 then "#{(time_ago / 60).to_i} minutes ago"
    when 3601..86400 then "#{(time_ago / 3600).to_i} hours ago"
    when 86401..2592000 then "#{(time_ago / 86400).to_i} days ago"
    else time.strftime('%B %d, %Y')
    end
  end

  def emotion_journey_progress_indicator(current_session, total_sessions)
    return 'Starting your journey' if total_sessions <= 1
    
    progress_percentage = (current_session.to_f / total_sessions * 100).round
    
    case progress_percentage
    when 0..20 then { stage: 'Beginning', emoji: '🌱', message: 'Every journey starts with a single step' }
    when 21..40 then { stage: 'Growing', emoji: '🌿', message: 'Building emotional awareness' }
    when 41..60 then { stage: 'Developing', emoji: '🌳', message: 'Strengthening emotional skills' }
    when 61..80 then { stage: 'Flourishing', emoji: '🌸', message: 'Embracing emotional wisdom' }
    else { stage: 'Mastering', emoji: '🌟', message: 'Living with emotional intelligence' }
    end
  end
end
