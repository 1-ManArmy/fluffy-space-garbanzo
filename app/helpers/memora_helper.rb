# frozen_string_literal: true

module MemoraHelper
  def memora_emoji
    '🌌'
  end

  def memora_primary_color
    '#6B46C1'
  end

  def memora_secondary_color
    '#8B5CF6'
  end

  def memory_type_icon(type)
    case type.to_s.downcase
    when 'goal'
      '🎯'
    when 'fact'
      '📚'
    when 'preference'
      '❤️'
    when 'quirk'
      '🤹'
    when 'context'
      '🌐'
    when 'insight'
      '💡'
    when 'reminder'
      '⏰'
    when 'experience'
      '✨'
    when 'relationship'
      '👥'
    when 'learning'
      '🎓'
    else
      '💾'
    end
  end

  def priority_indicator(priority)
    case priority.to_s.downcase
    when 'critical'
      '🔴 Critical'
    when 'high'
      '🟡 High'
    when 'medium'
      '🟢 Medium'
    when 'low'
      '⚪ Low'
    when 'archive'
      '📦 Archived'
    else
      '⚫ Unknown'
    end
  end

  def memory_privacy_badge(level)
    case level.to_s.downcase
    when 'public'
      content_tag :span, '🌐 Public', class: 'privacy-badge public'
    when 'private'
      content_tag :span, '🔒 Private', class: 'privacy-badge private'
    when 'encrypted'
      content_tag :span, '🔐 Encrypted', class: 'privacy-badge encrypted'
    else
      content_tag :span, '❓ Unknown', class: 'privacy-badge unknown'
    end
  end

  def memory_source_indicator(source)
    case source.to_s.downcase
    when 'terminal'
      '💻 Terminal'
    when 'voice'
      '🎤 Voice'
    when 'api'
      '🔗 API'
    when 'sync'
      '🔄 Agent Sync'
    else
      '📝 Manual'
    end
  end

  def format_memory_content(content, max_length = 100)
    return 'No content' if content.blank?

    if content.length > max_length
      "#{content[0..max_length]}..."
    else
      content
    end
  end

  def memory_timestamp(timestamp)
    return 'Unknown time' unless timestamp

    time_diff = Time.current - timestamp

    case time_diff
    when 0..59
      'Just now'
    when 60..3599
      "#{(time_diff / 60).round} minutes ago"
    when 3600..86_399
      "#{(time_diff / 3600).round} hours ago"
    when 86_400..2_591_999
      "#{(time_diff / 86_400).round} days ago"
    else
      timestamp.strftime('%B %d, %Y')
    end
  end

  def memory_confidence_indicator(score)
    case score.to_i
    when 90..100
      '🌟 Excellent'
    when 80..89
      '⭐ Very Good'
    when 70..79
      '👍 Good'
    when 60..69
      '👌 Fair'
    else
      '📝 Basic'
    end
  end

  def memory_tags_display(tags)
    return '' if tags.blank?

    tags.map do |tag|
      content_tag :span, "##{tag}", class: 'memory-tag'
    end.join(' ').html_safe
  end

  def agent_sync_indicator(agents)
    return 'No sync' if agents.blank?

    agent_icons = {
      'emotisense' => '💜',
      'cinegen' => '🎬',
      'contentcrafter' => '📝',
      'neochat' => '💬'
    }

    synced_icons = agents.map { |agent| agent_icons[agent.to_s] || '🌌' }
    "Synced: #{synced_icons.join(' ')}"
  end

  def memory_graph_node_color(type)
    colors = {
      'goal' => '#FF6B6B',
      'fact' => '#4ECDC4',
      'preference' => '#45B7D1',
      'quirk' => '#96CEB4',
      'context' => '#FECA57',
      'insight' => '#FF9FF3',
      'reminder' => '#54A0FF',
      'experience' => '#5F27CD',
      'relationship' => '#00D2D3',
      'learning' => '#FF9F43'
    }
    colors[type.to_s] || '#6C5CE7'
  end

  def memory_search_suggestions(query)
    suggestions = []

    suggestions << 'Try using more specific keywords' if query.length < 3

    unless query.match?(/\b(goal|fact|preference|quirk|context|insight|reminder|experience|relationship|learning)\b/i)
      suggestions << 'Include memory types like "goal", "fact", or "preference"'
    end

    suggestions << 'Use hashtags like #work, #personal, #health for better results' unless query.include?('#')

    suggestions << 'Try semantic search like "What did I learn about..."'
    suggestions
  end

  def format_memory_stats(stats)
    return {} unless stats

    {
      total_memories: number_with_delimiter(stats[:total_memories] || 0),
      semantic_index: number_with_delimiter(stats[:semantic_index_size] || 0),
      graph_connections: number_with_delimiter(stats[:graph_connections] || 0),
      recent_activity: stats[:recent_activity] || {}
    }
  end

  def memory_type_distribution_chart_data(distribution)
    return [] unless distribution

    distribution.map do |type, count|
      {
        label: memory_type_icon(type) + ' ' + type.to_s.humanize,
        value: count,
        color: memory_graph_node_color(type)
      }
    end
  end

  def export_format_options
    [
      { value: 'json', label: 'JSON', icon: '⚙️', description: 'Structured data format' },
      { value: 'markdown', label: 'Markdown', icon: '📝', description: 'Human-readable text' },
      { value: 'csv', label: 'CSV', icon: '📊', description: 'Spreadsheet compatible' },
      { value: 'xml', label: 'XML', icon: '🗂️', description: 'Markup format' },
      { value: 'txt', label: 'Plain Text', icon: '📃', description: 'Simple text file' }
    ]
  end

  def memory_insights_summary(insights)
    return 'No insights available' unless insights

    summary = []
    summary << "#{insights[:patterns]&.length || 0} patterns identified"
    summary << "#{insights[:knowledge_areas]&.length || 0} knowledge areas"
    summary << "#{insights[:learning_progress]&.values&.sum || 0} learning items tracked"

    summary.join(' • ')
  end

  def memory_recall_accuracy(confidence)
    case confidence.to_i
    when 90..100
      { level: 'Excellent', color: '#10B981', description: 'Very high confidence match' }
    when 75..89
      { level: 'Good', color: '#F59E0B', description: 'Good confidence match' }
    when 50..74
      { level: 'Fair', color: '#EF4444', description: 'Moderate confidence match' }
    else
      { level: 'Low', color: '#6B7280', description: 'Low confidence match' }
    end
  end

  def voice_processing_quality(confidence, emotion)
    quality_score = confidence.to_i

    # Adjust for emotional clarity
    case emotion.to_s.downcase
    when 'clear', 'calm', 'focused'
      quality_score += 5
    when 'excited', 'urgent'
      quality_score += 2
    when 'mumbled', 'unclear'
      quality_score -= 10
    end

    quality_score = [[quality_score, 100].min, 0].max

    {
      score: quality_score,
      level: memory_confidence_indicator(quality_score).split(' ').last,
      recommendation: quality_score < 70 ? 'Consider re-recording for better accuracy' : 'Voice quality is good'
    }
  end

  def memory_context_indicators(context_data)
    return [] unless context_data

    indicators = []
    indicators << "🌌 #{context_data[:agent_context]}" if context_data[:agent_context]
    indicators << "😊 #{context_data[:mood_context]}" if context_data[:mood_context]
    indicators << "🕐 #{context_data[:time_context]}" if context_data[:time_context]

    indicators
  end

  def semantic_concepts_display(concepts)
    return 'No concepts extracted' if concepts.blank?

    concepts.map do |concept|
      content_tag :span, concept, class: 'semantic-concept'
    end.join(' ').html_safe
  end

  def memory_retrieval_score_badge(score)
    score = score.to_i

    case score
    when 90..100
      content_tag :span, "🏆 #{score}%", class: 'score-badge excellent'
    when 80..89
      content_tag :span, "⭐ #{score}%", class: 'score-badge good'
    when 70..79
      content_tag :span, "👍 #{score}%", class: 'score-badge fair'
    when 60..69
      content_tag :span, "👌 #{score}%", class: 'score-badge basic'
    else
      content_tag :span, "📝 #{score}%", class: 'score-badge low'
    end
  end

  def format_processing_time(time_ms)
    if time_ms < 1000
      "#{time_ms.round(1)}ms"
    else
      "#{(time_ms / 1000.0).round(2)}s"
    end
  end

  def memory_relationship_map(relationships)
    return 'No relationships mapped' if relationships.blank?

    relationships.map do |rel|
      "👥 #{rel}"
    end.join(' • ')
  end

  def privacy_settings_summary(settings)
    return 'Default settings' unless settings

    features = []
    features << '🔐 Encrypted' if settings[:encryption_enabled]
    features << '💾 Local Storage' if settings[:local_storage]
    features << '☁️ Cloud Backup' if settings[:cloud_backup]

    features.empty? ? 'Basic privacy' : features.join(' • ')
  end
end
