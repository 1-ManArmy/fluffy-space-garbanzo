# frozen_string_literal: true

module EmotisenseHelper
  def emotion_emoji(emotion)
    case emotion.to_s
    when 'joy' then '😊'
    when 'sadness' then '😢'
    when 'anger' then '😠'
    when 'fear' then '😰'
    when 'excitement' then '🤩'
    when 'love' then '😍'
    when 'calm' then '😌'
    else '😐'
    end
  end

  def get_emotion_color(emotion)
    color_map = {
      'joy' => '#ffd700',
      'sadness' => '#74b9ff',
      'anger' => '#ff7675',
      'fear' => '#636e72',
      'excitement' => '#fdcb6e',
      'love' => '#fd79a8',
      'calm' => '#00b894',
      'neutral' => '#6c5ce7'
    }
    color_map[emotion.to_s] || '#6c5ce7'
  end

  def emotion_intensity_color(emotion, intensity)
    base_color = get_emotion_color(emotion)
    
    # Adjust opacity based on intensity
    opacity = case intensity.to_s
    when 'low' then 0.3
    when 'moderate' then 0.6
    when 'high' then 0.8
    when 'very_high' then 0.9
    when 'extreme' then 1.0
    else 0.6
    end
    
    # Convert hex to rgba
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

  def mood_description(mood)
    descriptions = {
      'positive' => 'Feeling great and optimistic',
      'negative' => 'Going through some challenges',
      'neutral' => 'Balanced and centered',
      'agitated' => 'Feeling restless or frustrated', 
      'peaceful' => 'Calm and tranquil'
    }
    descriptions[mood.to_s] || 'Experiencing emotions'
  end

  def intensity_badge(intensity)
    case intensity.to_s
    when 'low' then content_tag(:span, '●', class: 'intensity-badge low', title: 'Low intensity')
    when 'moderate' then content_tag(:span, '●●', class: 'intensity-badge moderate', title: 'Moderate intensity')
    when 'high' then content_tag(:span, '●●●', class: 'intensity-badge high', title: 'High intensity')
    when 'very_high' then content_tag(:span, '●●●●', class: 'intensity-badge very-high', title: 'Very high intensity')
    when 'extreme' then content_tag(:span, '●●●●●', class: 'intensity-badge extreme', title: 'Extreme intensity')
    else content_tag(:span, '●●', class: 'intensity-badge moderate', title: 'Moderate intensity')
    end
  end

  def time_of_day_emotion_context
    hour = Time.current.hour
    
    case hour
    when 6..11
      { period: 'morning', context: 'Starting the day', emoji: '🌅' }
    when 12..17
      { period: 'afternoon', context: 'Midday energy', emoji: '☀️' }
    when 18..21
      { period: 'evening', context: 'Winding down', emoji: '🌆' }
    else
      { period: 'night', context: 'Nighttime reflection', emoji: '🌙' }
    end
  end

  def emotion_suggestion_icon(suggestion_type)
    icons = {
      'self_care' => '🛁',
      'physical' => '🏃‍♀️',
      'social' => '👥', 
      'creative' => '🎨',
      'mindfulness' => '🧘‍♀️',
      'nature' => '🌿',
      'music' => '🎵',
      'writing' => '🌌'
    }
    icons[suggestion_type.to_s] || '💡'
  end

  def format_session_duration(minutes)
    if minutes < 60
      "#{minutes} min"
    else
      hours = minutes / 60
      remaining_minutes = minutes % 60
      remaining_minutes > 0 ? "#{hours}h #{remaining_minutes}m" : "#{hours}h"
    end
  end

  def emotion_gradient_background(primary_emotion, secondary_emotion = nil)
    primary_color = get_emotion_color(primary_emotion)
    secondary_color = secondary_emotion ? get_emotion_color(secondary_emotion) : primary_color
    
    "background: linear-gradient(135deg, #{primary_color}22 0%, #{secondary_color}22 100%)"
  end

  def wellness_activity_icon(activity_type)
    icons = {
      'breathing' => '🫁',
      'meditation' => '🧘‍♀️',
      'movement' => '💃',
      'journaling' => '📓',
      'music' => '🎶',
      'nature' => '🌲',
      'art' => '🎨',
      'social' => '🤗'
    }
    icons[activity_type.to_s] || '✨'
  end
end
