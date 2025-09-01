class DocsController < ApplicationController
  def index
    @doc_sections = get_documentation_sections_with_topics
    @getting_started = get_getting_started_guides
    @popular_docs = get_popular_documentation
    @recent_updates = get_recent_doc_updates
    @popular_articles = get_popular_articles
    @api_endpoints = get_api_endpoints
  end

  def section
    @section = params[:section]
    @section_info = get_section_info(@section)
    @topics = get_section_topics(@section)
    @related_sections = get_related_sections(@section)
  end

  def topic
    @section = params[:section]
    @topic_slug = params[:topic]
    @section_name = get_section_info(@section)[:name] || @section.titleize

    # Get the topic data from the section topics
    topics = get_section_topics(@section)
    @topic = topics.find { |t| t[:slug] == @topic_slug }

    # If topic not found, redirect to section
    if @topic.nil?
      redirect_to docs_section_path(@section), alert: 'Topic not found'
      return
    end

    # Add detailed content to the topic
    @topic[:content] = get_topic_detailed_content(@section, @topic_slug)
    @topic[:resources] = get_topic_resources(@section, @topic_slug)

    @navigation = get_topic_navigation(@section, @topic_slug)
    @prev_topic = @navigation[:previous]
    @next_topic = @navigation[:next]
    @related_topics = get_related_topics(@section, @topic_slug)
  end

  private

  def get_documentation_sections
    [
      {
        name: 'Getting Started',
        slug: 'getting-started',
        description: 'Everything you need to begin using Phantom AI',
        icon: '🚀',
        topics: 12,
        color: 'emerald'
      },
      {
        name: 'API Reference',
        slug: 'api',
        description: 'Complete API documentation and examples',
        icon: '📡',
        topics: 45,
        color: 'blue'
      },
      {
        name: 'AI Agents',
        slug: 'agents',
        description: 'Detailed guides for each AI agent',
        icon: '🌌',
        topics: 28,
        color: 'purple'
      },
      {
        name: 'Integration Guides',
        slug: 'integrations',
        description: 'How to integrate with popular platforms',
        icon: '🔗',
        topics: 18,
        color: 'cyan'
      },
      {
        name: 'Authentication',
        slug: 'auth',
        description: 'Security and authentication methods',
        icon: '🔐',
        topics: 8,
        color: 'amber'
      },
      {
        name: 'SDKs & Libraries',
        slug: 'sdks',
        description: 'Official SDKs and community libraries',
        icon: '📦',
        topics: 15,
        color: 'rose'
      },
      {
        name: 'Tutorials',
        slug: 'tutorials',
        description: 'Step-by-step project tutorials',
        icon: '📚',
        topics: 22,
        color: 'indigo'
      },
      {
        name: 'Troubleshooting',
        slug: 'troubleshooting',
        description: 'Common issues and solutions',
        icon: '🔧',
        topics: 19,
        color: 'orange'
      }
    ]
  end

  def get_documentation_sections_with_topics
    get_documentation_sections.map do |section|
      section_topics = get_section_topics(section[:slug]).first(3)
      section.merge(topic_list: section_topics)
    end
  end

  def get_getting_started_guides
    [
      {
        title: 'Quick Start Guide',
        description: 'Get up and running in 5 minutes',
        duration: '5 min',
        difficulty: 'Beginner',
        link: '/docs/getting-started/quick-start'
      },
      {
        title: 'Your First AI Agent',
        description: 'Create and deploy your first agent',
        duration: '15 min',
        difficulty: 'Beginner',
        link: '/docs/getting-started/first-agent'
      },
      {
        title: 'Authentication Setup',
        description: 'Configure API keys and security',
        duration: '10 min',
        difficulty: 'Beginner',
        link: '/docs/getting-started/authentication'
      }
    ]
  end

  def get_popular_documentation
    [
      {
        title: 'EmotiSense API Reference',
        section: 'AI Agents',
        views: 15_420,
        rating: 4.9
      },
      {
        title: 'Webhook Integration Guide',
        section: 'Integration Guides',
        views: 12_850,
        rating: 4.8
      },
      {
        title: 'Rate Limiting Best Practices',
        section: 'API Reference',
        views: 11_200,
        rating: 4.7
      },
      {
        title: 'ContentCrafter Advanced Usage',
        section: 'AI Agents',
        views: 9800,
        rating: 4.9
      }
    ]
  end

  def get_recent_doc_updates
    [
      {
        title: 'CineGen v2.1 API Updates',
        date: '2 days ago',
        type: 'update'
      },
      {
        title: 'New Python SDK Released',
        date: '1 week ago',
        type: 'new'
      },
      {
        title: 'Enhanced Error Handling Guide',
        date: '2 weeks ago',
        type: 'update'
      }
    ]
  end

  def get_popular_articles
    [
      {
        title: 'Getting Started with Phantom AI',
        slug: 'getting-started-phantom-ai',
        excerpt: 'Learn the basics of our AI platform and get up and running quickly.',
        category: 'Getting Started',
        reading_time: 5,
        views: 12_450,
        tags: %w[beginner setup quickstart],
        updated_at: '2 days ago'
      },
      {
        title: 'API Authentication Best Practices',
        slug: 'api-authentication-best-practices',
        excerpt: 'Secure your API calls with proper authentication methods and key management.',
        category: 'API',
        reading_time: 8,
        views: 9_320,
        tags: %w[security api authentication],
        updated_at: '1 week ago'
      },
      {
        title: 'Building Your First AI Agent',
        slug: 'building-first-ai-agent',
        excerpt: 'Step-by-step tutorial for creating and deploying your first AI agent.',
        category: 'Tutorial',
        reading_time: 15,
        views: 8_150,
        tags: %w[tutorial agents deployment],
        updated_at: '3 days ago'
      }
    ]
  end

  def get_api_endpoints
    [
      {
        method: 'GET',
        path: '/api/v1/models',
        description: 'List all available AI models'
      },
      {
        method: 'POST',
        path: '/api/v1/neochat/chat',
        description: 'Send a chat message to NeoChat'
      },
      {
        method: 'POST',
        path: '/api/v1/emotisense/analyze',
        description: 'Analyze text for emotional content'
      },
      {
        method: 'GET',
        path: '/api/v1/status',
        description: 'Check API service status'
      }
    ]
  end

  def get_section_info(section)
    sections = get_documentation_sections
    sections.find { |s| s[:slug] == section } || {}
  end

  def get_section_topics(section)
    case section
    when 'getting-started'
      get_getting_started_topics
    when 'api'
      get_api_topics
    when 'agents'
      get_agents_topics
    when 'integrations'
      get_integration_topics
    when 'auth'
      get_auth_topics
    when 'sdks'
      get_sdk_topics
    when 'tutorials'
      get_tutorial_topics
    when 'troubleshooting'
      get_troubleshooting_topics
    else
      []
    end
  end

  def get_getting_started_topics
    [
      {
        title: 'Quick Start Guide',
        slug: 'quick-start',
        description: 'Get up and running in minutes',
        difficulty: 'Beginner',
        duration: '5 min'
      },
      {
        title: 'Platform Overview',
        slug: 'overview',
        description: 'Understanding the Phantom AI ecosystem',
        difficulty: 'Beginner',
        duration: '8 min'
      },
      {
        title: 'Your First AI Agent',
        slug: 'first-agent',
        description: 'Create and deploy your first agent',
        difficulty: 'Beginner',
        duration: '15 min'
      },
      {
        title: 'Understanding Agent Types',
        slug: 'agent-types',
        description: 'Different types of AI agents and their use cases',
        difficulty: 'Intermediate',
        duration: '12 min'
      }
    ]
  end

  def get_api_topics
    [
      {
        title: 'Authentication',
        slug: 'authentication',
        description: 'API key management and security',
        difficulty: 'Beginner',
        duration: '7 min'
      },
      {
        title: 'Making Your First Request',
        slug: 'first-request',
        description: 'Basic API usage and response handling',
        difficulty: 'Beginner',
        duration: '10 min'
      },
      {
        title: 'Rate Limiting',
        slug: 'rate-limiting',
        description: 'Understanding and managing API limits',
        difficulty: 'Intermediate',
        duration: '8 min'
      },
      {
        title: 'Error Handling',
        slug: 'error-handling',
        description: 'Comprehensive error response guide',
        difficulty: 'Intermediate',
        duration: '12 min'
      },
      {
        title: 'Webhooks',
        slug: 'webhooks',
        description: 'Real-time notifications and callbacks',
        difficulty: 'Advanced',
        duration: '15 min'
      }
    ]
  end

  def get_agents_topics
    [
      {
        title: 'EmotiSense Guide',
        slug: 'emotisense',
        description: 'Emotion analysis and sentiment detection',
        difficulty: 'Beginner',
        duration: '12 min'
      },
      {
        title: 'ContentCrafter Guide',
        slug: 'contentcrafter',
        description: 'AI-powered content generation',
        difficulty: 'Beginner',
        duration: '10 min'
      },
      {
        title: 'CineGen Guide',
        slug: 'cinegen',
        description: 'Video creation and editing',
        difficulty: 'Intermediate',
        duration: '18 min'
      },
      {
        title: 'NeoChat Guide',
        slug: 'neochat',
        description: 'Conversational AI and chatbots',
        difficulty: 'Beginner',
        duration: '8 min'
      }
    ]
  end

  def get_integration_topics
    [
      {
        title: 'Slack Integration',
        slug: 'slack',
        description: 'Connect AI agents to Slack workspaces',
        difficulty: 'Intermediate',
        duration: '20 min'
      },
      {
        title: 'Discord Bots',
        slug: 'discord',
        description: 'Build AI-powered Discord bots',
        difficulty: 'Intermediate',
        duration: '25 min'
      },
      {
        title: 'WordPress Plugin',
        slug: 'wordpress',
        description: 'Add AI features to WordPress sites',
        difficulty: 'Beginner',
        duration: '15 min'
      }
    ]
  end

  def get_auth_topics
    [
      {
        title: 'API Keys',
        slug: 'api-keys',
        description: 'Managing and securing API keys',
        difficulty: 'Beginner',
        duration: '5 min'
      },
      {
        title: 'OAuth 2.0',
        slug: 'oauth',
        description: 'OAuth integration for user authentication',
        difficulty: 'Advanced',
        duration: '20 min'
      }
    ]
  end

  def get_sdk_topics
    [
      {
        title: 'Python SDK',
        slug: 'python',
        description: 'Official Python library and examples',
        difficulty: 'Beginner',
        duration: '10 min'
      },
      {
        title: 'Node.js SDK',
        slug: 'nodejs',
        description: 'JavaScript/TypeScript SDK for Node.js',
        difficulty: 'Beginner',
        duration: '10 min'
      },
      {
        title: 'PHP SDK',
        slug: 'php',
        description: 'PHP library for web applications',
        difficulty: 'Beginner',
        duration: '8 min'
      }
    ]
  end

  def get_tutorial_topics
    [
      {
        title: 'Build a Customer Service Bot',
        slug: 'customer-service-bot',
        description: 'Complete tutorial for AI customer support',
        difficulty: 'Intermediate',
        duration: '45 min'
      },
      {
        title: 'Content Marketing Automation',
        slug: 'content-automation',
        description: 'Automate content creation workflows',
        difficulty: 'Advanced',
        duration: '60 min'
      }
    ]
  end

  def get_troubleshooting_topics
    [
      {
        title: 'Common API Errors',
        slug: 'api-errors',
        description: 'Debugging frequent API issues',
        difficulty: 'Beginner',
        duration: '8 min'
      },
      {
        title: 'Performance Optimization',
        slug: 'performance',
        description: 'Optimizing response times and throughput',
        difficulty: 'Advanced',
        duration: '15 min'
      }
    ]
  end

  def get_related_sections(current_section)
    all_sections = get_documentation_sections
    all_sections.reject { |s| s[:slug] == current_section }.sample(3)
  end

  def get_documentation_content(section, topic)
    {
      title: get_topic_title(section, topic),
      content: get_topic_content(section, topic),
      last_updated: '3 days ago',
      contributors: %w[DocsTeam AIExpert CommunityMember],
      estimated_read_time: '8 min'
    }
  end

  def get_topic_title(section, topic)
    case "#{section}/#{topic}"
    when 'getting-started/quick-start'
      'Quick Start Guide'
    when 'api/authentication'
      'API Authentication'
    when 'agents/emotisense'
      'EmotiSense Agent Guide'
    else
      'Documentation Topic'
    end
  end

  def get_topic_content(section, topic)
    case "#{section}/#{topic}"
    when 'getting-started/quick-start'
      get_quick_start_content
    when 'api/authentication'
      get_api_auth_content
    when 'agents/emotisense'
      get_emotisense_content
    else
      get_default_content
    end
  end

  def get_quick_start_content
    <<~CONTENT
      # Quick Start Guide

      Welcome to Phantom AI! This guide will help you get started with our platform in just a few minutes.

      ## Prerequisites

      - A Phantom AI account (sign up at [phantom-ai.com/signup](https://phantom-ai.com/signup))
      - Basic understanding of REST APIs
      - Your favorite programming language or API client

      ## Step 1: Get Your API Key

      1. Log into your Phantom AI dashboard
      2. Navigate to the API Keys section
      3. Click "Create New Key"
      4. Copy your API key (keep it secure!)

      ## Step 2: Make Your First Request

      ```bash
      curl -X POST "https://api.phantom-ai.com/v1/neochat/chat" \\
        -H "Authorization: Bearer YOUR_API_KEY" \\
        -H "Content-Type: application/json" \\
        -d '{
          "message": "Hello, world!",
          "model": "neochat-v2"
        }'
      ```

      ## Step 3: Explore AI Agents

      Try different agents for various use cases:

      - **NeoChat**: Conversational AI and chatbots
      - **EmotiSense**: Emotion analysis and sentiment detection
      - **ContentCrafter**: AI-powered content generation
      - **CineGen**: Video creation and editing

      ## Next Steps

      - Read the [Platform Overview](/docs/getting-started/overview)
      - Explore our [AI Agents documentation](/docs/agents)
      - Join our [Community Forum](/community/forum)

      ## Need Help?

      - Check our [FAQ](/faq)
      - Visit the [Community Forum](/community/forum)
      - Contact [Support](/support)
    CONTENT
  end

  def get_api_auth_content
    <<~CONTENT
      # API Authentication

      Phantom AI uses API keys for authentication. All API requests must include a valid API key in the Authorization header.

      ## API Key Management

      ### Creating API Keys

      1. Log into your dashboard
      2. Go to Settings → API Keys
      3. Click "Generate New Key"
      4. Give your key a descriptive name
      5. Set appropriate permissions

      ### Security Best Practices

      - Never expose API keys in client-side code
      - Use environment variables to store keys
      - Rotate keys regularly
      - Use different keys for different environments

      ## Authentication Methods

      ### Bearer Token (Recommended)

      ```bash
      Authorization: Bearer YOUR_API_KEY
      ```

      ### Query Parameter (Not Recommended)

      ```bash
      https://api.phantom-ai.com/v1/endpoint?api_key=YOUR_API_KEY
      ```

      ## Error Responses

      | Status | Error | Description |
      |--------|-------|-------------|
      | 401 | unauthorized | Missing or invalid API key |
      | 403 | forbidden | API key lacks required permissions |
      | 429 | rate_limited | Rate limit exceeded |

      ## Rate Limiting

      API keys have different rate limits based on your subscription:

      - **Free**: 100 requests/hour
      - **Pro**: 10,000 requests/hour#{'  '}
      - **Enterprise**: Custom limits

      Rate limit headers are included in all responses:

      ```http
      X-RateLimit-Limit: 10000
      X-RateLimit-Remaining: 9999
      X-RateLimit-Reset: 1640995200
      ```
    CONTENT
  end

  def get_emotisense_content
    <<~CONTENT
      # EmotiSense Agent Guide

      EmotiSense is our advanced emotion analysis and sentiment detection AI agent. It can analyze text, voice, and even facial expressions to understand emotional context.

      ## Capabilities

      - **Text Sentiment Analysis**: Detect emotions in written content
      - **Voice Emotion Recognition**: Analyze emotional tone in speech
      - **Facial Expression Analysis**: Understand emotions from images/video
      - **Multi-modal Processing**: Combine multiple input types for better accuracy

      ## Basic Usage

      ### Text Analysis

      ```bash
      curl -X POST "https://api.phantom-ai.com/v1/emotisense/analyze" \\
        -H "Authorization: Bearer YOUR_API_KEY" \\
        -H "Content-Type: application/json" \\
        -d '{
          "input_type": "text",
          "content": "I am so excited about this new project!"
        }'
      ```

      ### Response Format

      ```json
      {
        "emotions": {
          "joy": 0.85,
          "excitement": 0.78,
          "confidence": 0.65,
          "neutral": 0.12
        },
        "primary_emotion": "joy",
        "confidence_score": 0.92,
        "processing_time": "156ms"
      }
      ```

      ## Advanced Features

      ### Custom Emotion Models

      Train custom models for specific use cases:

      ```json
      {
        "model_type": "custom",
        "training_data": "path/to/dataset",
        "emotions": ["happy", "sad", "frustrated", "satisfied"]
      }
      ```

      ### Real-time Streaming

      Process emotions in real-time using WebSocket connections:

      ```javascript
      const ws = new WebSocket('wss://api.phantom-ai.com/v1/emotisense/stream');

      ws.onmessage = function(event) {
        const emotion_data = JSON.parse(event.data);
        console.log('Real-time emotion:', emotion_data);
      };
      ```

      ## Use Cases

      - **Customer Service**: Analyze customer emotions in support tickets
      - **Content Moderation**: Detect negative sentiment in user-generated content
      - **Mental Health Apps**: Monitor emotional well-being over time
      - **Marketing**: Understand emotional response to campaigns

      ## SDKs and Examples

      ### Python

      ```python
      from phantom_ai import EmotiSense

      client = EmotiSense(api_key="YOUR_API_KEY")

      result = client.analyze_text("I love this product!")
      print(f"Primary emotion: {result.primary_emotion}")
      print(f"Confidence: {result.confidence_score}")
      ```

      ### Node.js

      ```javascript
      const { EmotiSense } = require('@phantom-ai/sdk');

      const client = new EmotiSense({ apiKey: 'YOUR_API_KEY' });

      async function analyzeEmotion() {
        const result = await client.analyzeText('This is amazing!');
        console.log('Emotions:', result.emotions);
      }
      ```

      ## Best Practices

      1. **Batch Processing**: Process multiple texts in a single request for better performance
      2. **Context Window**: Provide sufficient context for accurate emotion detection
      3. **Cultural Sensitivity**: Consider cultural differences in emotional expression
      4. **Privacy**: Ensure user consent before analyzing personal communications

      ## Troubleshooting

      ### Common Issues

      - **Low Confidence Scores**: Provide more context or use longer text samples
      - **Rate Limiting**: Implement exponential backoff for retry logic
      - **Inconsistent Results**: Ensure consistent input formatting

      ### Support

      For technical support:
      - Visit our [Community Forum](/community/forum)
      - Check the [Troubleshooting Guide](/docs/troubleshooting)
      - Contact our [Support Team](/support)
    CONTENT
  end

  def get_default_content
    "# Documentation Content\n\nThis documentation page is under construction. Please check back soon for updated content."
  end

  def get_topic_navigation(section, topic)
    topics = get_section_topics(section)
    current_index = topics.find_index { |t| t[:slug] == topic }

    {
      previous: current_index > 0 ? topics[current_index - 1] : nil,
      next: current_index < topics.length - 1 ? topics[current_index + 1] : nil,
      section: section
    }
  end

  def get_related_topics(section, topic)
    all_topics = get_section_topics(section)
    all_topics.reject { |t| t[:slug] == topic }.sample(3)
  end

  def get_topic_detailed_content(section, topic)
    case "#{section}/#{topic}"
    when 'getting-started/quick-start'
      get_quick_start_detailed_content
    when 'api/authentication'
      get_api_auth_detailed_content
    when 'agents/emotisense'
      get_emotisense_detailed_content
    else
      get_default_detailed_content
    end
  end

  def get_quick_start_detailed_content
    {
      overview: "This guide will help you get started with Phantom AI in just a few minutes. You'll learn how to set up your account, get your API key, and make your first request.",
      sections: [
        {
          title: 'Prerequisites',
          subsections: [
            {
              title: 'Account Setup',
              content: "Before you begin, you'll need a Phantom AI account. Sign up at phantom-ai.com/signup if you haven't already.",
              tip: 'Use your work email for easier team collaboration later.'
            },
            {
              title: 'Basic Requirements',
              content: "You'll need basic understanding of REST APIs and your favorite programming language or API client."
            }
          ]
        },
        {
          title: 'Getting Your API Key',
          subsections: [
            {
              title: 'Dashboard Access',
              content: 'Log into your Phantom AI dashboard and navigate to the API Keys section.',
              code_example: {
                language: 'bash',
                code: '# Navigate to: https://dashboard.phantom-ai.com/api-keys'
              }
            },
            {
              title: 'Key Generation',
              content: "Click 'Create New Key', give it a descriptive name, and copy the generated key immediately.",
              tip: "Store your API key securely - it won't be shown again!"
            }
          ]
        },
        {
          title: 'Your First Request',
          subsections: [
            {
              title: 'Basic API Call',
              content: 'Make your first API request to test the connection:',
              code_example: {
                language: 'bash',
                code: 'curl -X POST "https://api.phantom-ai.com/v1/neochat/chat" \\\n  -H "Authorization: Bearer YOUR_API_KEY" \\\n  -H "Content-Type: application/json" \\\n  -d \'{\n    "message": "Hello, world!",\n    "model": "neochat-v2"\n  }\''
              }
            }
          ]
        }
      ]
    }
  end

  def get_api_auth_detailed_content
    {
      overview: 'Phantom AI uses API keys for authentication. All API requests must include a valid API key in the Authorization header for security.',
      sections: [
        {
          title: 'Authentication Methods',
          subsections: [
            {
              title: 'Bearer Token (Recommended)',
              content: 'The preferred method is using the Authorization header with Bearer token format:',
              code_example: {
                language: 'bash',
                code: 'Authorization: Bearer YOUR_API_KEY'
              }
            },
            {
              title: 'Security Best Practices',
              content: 'Never expose API keys in client-side code, use environment variables, and rotate keys regularly.',
              tip: 'Use different API keys for development, staging, and production environments.'
            }
          ]
        }
      ]
    }
  end

  def get_emotisense_detailed_content
    {
      overview: 'EmotiSense is our advanced emotion analysis AI that can process text, voice, and facial expressions to understand emotional context with high accuracy.',
      sections: [
        {
          title: 'Text Analysis',
          subsections: [
            {
              title: 'Basic Usage',
              content: 'Analyze emotions in text content with a simple API call:',
              code_example: {
                language: 'bash',
                code: 'curl -X POST "https://api.phantom-ai.com/v1/emotisense/analyze" \\\n  -H "Authorization: Bearer YOUR_API_KEY" \\\n  -H "Content-Type: application/json" \\\n  -d \'{\n    "input_type": "text",\n    "content": "I am so excited about this new project!"\n  }\''
              }
            },
            {
              title: 'Response Format',
              content: 'The API returns emotion scores, primary emotion, and confidence metrics:',
              code_example: {
                language: 'json',
                code: '{\n  "emotions": {\n    "joy": 0.85,\n    "excitement": 0.78,\n    "confidence": 0.65\n  },\n  "primary_emotion": "joy",\n  "confidence_score": 0.92\n}'
              }
            }
          ]
        }
      ]
    }
  end

  def get_default_detailed_content
    {
      overview: 'This documentation page is under construction. Please check back soon for updated content.',
      sections: [
        {
          title: 'Coming Soon',
          subsections: [
            {
              title: 'Documentation Update',
              content: "We're working on comprehensive documentation for this topic. Check back soon or contact support for specific questions."
            }
          ]
        }
      ]
    }
  end

  def get_topic_resources(section, topic)
    case "#{section}/#{topic}"
    when 'getting-started/quick-start'
      [
        {
          type: 'guide',
          title: 'Platform Overview',
          description: 'Understanding the Phantom AI ecosystem',
          url: '/docs/getting-started/overview'
        },
        {
          type: 'tutorial',
          title: 'Your First AI Agent',
          description: 'Step-by-step agent creation tutorial',
          url: '/docs/getting-started/first-agent'
        }
      ]
    when 'api/authentication'
      [
        {
          type: 'guide',
          title: 'Rate Limiting',
          description: 'Understanding API limits and best practices',
          url: '/docs/api/rate-limiting'
        },
        {
          type: 'external',
          title: 'Postman Collection',
          description: 'Pre-configured API requests for testing',
          url: 'https://postman.com/phantom-ai'
        }
      ]
    else
      [
        {
          type: 'guide',
          title: 'Getting Started',
          description: 'Learn the basics of Phantom AI',
          url: '/docs/getting-started'
        },
        {
          type: 'tutorial',
          title: 'Community Forum',
          description: 'Get help from the community',
          url: '/community/forum'
        }
      ]
    end
  end
end
