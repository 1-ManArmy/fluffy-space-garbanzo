# frozen_string_literal: true

module ContentcrafterHelper
  def contentcrafter_emoji
    '📝'
  end
  
  def contentcrafter_primary_color
    '#007acc'
  end
  
  def contentcrafter_secondary_color
    '#0066aa'
  end
  
  def format_content_type(format)
    Agents::ContentcrafterEngine::CONTENT_FORMATS[format.to_sym] || format.to_s.humanize
  end
  
  def format_tone_style(tone)
    Agents::ContentcrafterEngine::TONE_STYLES[tone.to_sym] || tone.to_s.humanize
  end
  
  def format_audience_type(audience)
    Agents::ContentcrafterEngine::AUDIENCE_TYPES[audience.to_sym] || audience.to_s.humanize
  end
  
  def content_complexity_badge(score)
    case score.to_s.downcase
    when 'low'
      content_tag :span, '🟢 Low', class: 'complexity-badge low'
    when 'medium'
      content_tag :span, '🟡 Medium', class: 'complexity-badge medium'
    when 'high'
      content_tag :span, '🔴 High', class: 'complexity-badge high'
    else
      content_tag :span, '⚪ Unknown', class: 'complexity-badge unknown'
    end
  end
  
  def emotional_tone_indicator(tone)
    case tone.to_s.downcase
    when /positive/
      '😊 Positive'
    when /negative/, /cautious/
      '🤔 Analytical'
    else
      '😐 Neutral'
    end
  end
  
  def reading_time_estimate(word_count)
    minutes = (word_count.to_i / 200.0).ceil
    "#{minutes} min read"
  end
  
  def content_format_icon(format)
    case format.to_s.downcase
    when 'blog_post'
      '📄'
    when 'ad_copy'
      '📢'
    when 'agent_intro'
      '🌌'
    when 'script'
      '🎬'
    when 'social_media'
      '📱'
    when 'email_sequence'
      '📧'
    when 'technical_doc'
      '📋'
    when 'creative_writing'
      '🌌'
    when 'press_release'
      '📰'
    when 'product_description'
      '🏷️'
    else
      '📝'
    end
  end
  
  def export_format_icon(format)
    case format.to_s.downcase
    when 'markdown'
      '📝'
    when 'html'
      '🌐'
    when 'json'
      '⚙️'
    when 'pdf'
      '📄'
    when 'txt'
      '📃'
    when 'docx'
      '📊'
    else
      '💾'
    end
  end
  
  def generate_content_preview(content_data)
    return 'No preview available' unless content_data
    
    if content_data[:headline] || content_data[:title]
      title = content_data[:headline] || content_data[:title]
      "#{title[0..100]}#{title.length > 100 ? '...' : ''}"
    elsif content_data[:introduction]
      intro = content_data[:introduction]
      "#{intro[0..150]}#{intro.length > 150 ? '...' : ''}"
    else
      'Content generated successfully'
    end
  end
  
  def agent_fusion_indicator(agents)
    return '' if agents.blank?
    
    agent_icons = {
      'emotisense' => '💜',
      'cinegen' => '🎬',
      'neochat' => '💬',
      'contentcrafter' => '📝'
    }
    
    icons = agents.map { |agent| agent_icons[agent.to_s] || '🌌' }
    "Fusion: #{icons.join(' + ')}"
  end
  
  def content_quality_score(metadata)
    return 'N/A' unless metadata
    
    score = 0
    score += 25 if metadata[:word_count].to_i > 100
    score += 25 if metadata[:emotional_tone] != 'Neutral'
    score += 25 if metadata[:complexity_score] == 'Medium'
    score += 25 if metadata[:reading_time].present?
    
    case score
    when 90..100
      '🌟 Excellent'
    when 75..89
      '⭐ Good'
    when 50..74
      '👍 Fair'
    else
      '📝 Basic'
    end
  end
  
  def format_processing_time(time_ms)
    if time_ms < 1000
      "#{time_ms.round(1)}ms"
    else
      "#{(time_ms / 1000.0).round(2)}s"
    end
  end
  
  def content_length_indicator(length)
    case length.to_s
    when 'short'
      '🔸 Short (200-500 words)'
    when 'medium'
      '🔹 Medium (500-1000 words)'
    when 'long'
      '🔷 Long (1000-2000 words)'
    when 'very_long'
      '🔶 Comprehensive (2000+ words)'
    else
      '📏 Variable length'
    end
  end
  
  def available_export_formats
    [
      { value: 'markdown', label: 'Markdown', icon: '📝' },
      { value: 'html', label: 'HTML', icon: '🌐' },
      { value: 'json', label: 'JSON', icon: '⚙️' },
      { value: 'pdf', label: 'PDF', icon: '📄' },
      { value: 'txt', label: 'Plain Text', icon: '📃' },
      { value: 'docx', label: 'Word Document', icon: '📊' }
    ]
  end
  
  def suggested_content_improvements(suggestions)
    return '' if suggestions.blank?
    
    suggestions.map do |suggestion|
      "💡 #{suggestion}"
    end.join('<br>').html_safe
  end
  
  def content_performance_metrics(metadata)
    return {} unless metadata
    
    {
      readability: calculate_readability_score(metadata),
      engagement: calculate_engagement_score(metadata),
      seo_score: calculate_seo_score(metadata),
      conversion_potential: calculate_conversion_score(metadata)
    }
  end
  
  private
  
  def calculate_readability_score(metadata)
    score = 50 # Base score
    
    # Adjust based on complexity
    case metadata[:complexity_score]
    when 'Low'
      score += 30
    when 'Medium'
      score += 10
    when 'High'
      score -= 20
    end
    
    # Adjust based on word count
    word_count = metadata[:word_count].to_i
    if word_count.between?(300, 800)
      score += 20
    elsif word_count > 1500
      score -= 10
    end
    
    [score, 100].min
  end
  
  def calculate_engagement_score(metadata)
    score = 40 # Base score
    
    # Emotional tone boost
    case metadata[:emotional_tone]
    when /Positive/
      score += 40
    when /Neutral/
      score += 20
    end
    
    # Reading time optimization
    reading_time = metadata[:reading_time].to_s.scan(/\d+/).first.to_i
    if reading_time.between?(3, 7)
      score += 20
    end
    
    [score, 100].min
  end
  
  def calculate_seo_score(metadata)
    score = 30 # Base score
    
    # Word count optimization
    word_count = metadata[:word_count].to_i
    if word_count.between?(500, 1500)
      score += 40
    elsif word_count.between?(300, 2000)
      score += 20
    end
    
    # Format bonus
    case metadata[:format]
    when :blog_post
      score += 30
    when :technical_doc
      score += 20
    end
    
    [score, 100].min
  end
  
  def calculate_conversion_score(metadata)
    score = 35 # Base score
    
    # Format-specific scoring
    case metadata[:format]
    when :ad_copy
      score += 45
    when :product_description
      score += 35
    when :email_sequence
      score += 25
    when :blog_post
      score += 15
    end
    
    # Emotional tone impact
    case metadata[:emotional_tone]
    when /Positive/
      score += 20
    end
    
    [score, 100].min
  end
end
