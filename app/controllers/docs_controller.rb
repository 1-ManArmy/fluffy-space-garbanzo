class DocsController < ApplicationController
  def index
    @doc_sections = get_documentation_sections
    @getting_started = get_getting_started_guides
    @popular_docs = get_popular_documentation
    @recent_updates = get_recent_doc_updates
  end

  def section
    @section = params[:section]
    @section_info = get_section_info(@section)
    @topics = get_section_topics(@section)
    @related_sections = get_related_sections(@section)
  end

  def topic
    @section = params[:section]
    @topic = params[:topic]
    @doc_content = get_documentation_content(@section, @topic)
    @navigation = get_topic_navigation(@section, @topic)
    @related_topics = get_related_topics(@section, @topic)
  end

  private

  def get_documentation_sections
    [
      {
        name: "Getting Started",
        slug: "getting-started",
        description: "Everything you need to begin using Phantom AI",
        icon: "🚀",
        topics: 12,
        color: "emerald"
      },
      {
        name: "API Reference",
        slug: "api",
        description: "Complete API documentation and examples",
        icon: "📡",
        topics: 45,
        color: "blue"
      },
      {
        name: "AI Agents",
        slug: "agents",
        description: "Detailed guides for each AI agent",
        icon: "🌌",
        topics: 28,
        color: "purple"
      },
      {
        name: "Integration Guides",
        slug: "integrations",
        description: "How to integrate with popular platforms",
        icon: "🔗",
        topics: 18,
        color: "cyan"
      },
      {
        name: "Authentication",
        slug: "auth",
        description: "Security and authentication methods",
        icon: "🔐",
        topics: 8,
        color: "amber"
      },
      {
        name: "SDKs & Libraries",
        slug: "sdks",
        description: "Official SDKs and community libraries",
        icon: "📦",
        topics: 15,
        color: "rose"
      },
      {
        name: "Tutorials",
        slug: "tutorials",
        description: "Step-by-step project tutorials",
        icon: "📚",
        topics: 22,
        color: "indigo"
      },
      {
        name: "Troubleshooting",
        slug: "troubleshooting",
        description: "Common issues and solutions",
        icon: "🔧",
        topics: 19,
        color: "orange"
      }
    ]
  end

  def get_getting_started_guides
    [
      {
        title: "Quick Start Guide",
        description: "Get up and running in 5 minutes",
        duration: "5 min",
        difficulty: "Beginner",
        link: "/docs/getting-started/quick-start"
      },
      {
        title: "Your First AI Agent",
        description: "Create and deploy your first agent",
        duration: "15 min", 
        difficulty: "Beginner",
        link: "/docs/getting-started/first-agent"
      },
      {
        title: "Authentication Setup",
        description: "Configure API keys and security",
        duration: "10 min",
        difficulty: "Beginner", 
        link: "/docs/getting-started/authentication"
      }
    ]
  end

  def get_popular_documentation
    [
      {
        title: "EmotiSense API Reference",
        section: "AI Agents",
        views: 15420,
        rating: 4.9
      },
      {
        title: "Webhook Integration Guide",
        section: "Integration Guides", 
        views: 12850,
        rating: 4.8
      },
      {
        title: "Rate Limiting Best Practices",
        section: "API Reference",
        views: 11200,
        rating: 4.7
      },
      {
        title: "ContentCrafter Advanced Usage",
        section: "AI Agents",
        views: 9800,
        rating: 4.9
      }
    ]
  end

  def get_recent_doc_updates
    [
      {
        title: "CineGen v2.1 API Updates",
        date: "2 days ago",
        type: "update"
      },
      {
        title: "New Python SDK Released",
        date: "1 week ago", 
        type: "new"
      },
      {
        title: "Enhanced Error Handling Guide",
        date: "2 weeks ago",
        type: "update"
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
        title: "Quick Start Guide",
        slug: "quick-start",
        description: "Get up and running in minutes",
        difficulty: "Beginner",
        duration: "5 min"
      },
      {
        title: "Platform Overview",
        slug: "overview",
        description: "Understanding the Phantom AI ecosystem",
        difficulty: "Beginner",
        duration: "8 min"
      },
      {
        title: "Your First AI Agent",
        slug: "first-agent",
        description: "Create and deploy your first agent",
        difficulty: "Beginner",
        duration: "15 min"
      },
      {
        title: "Understanding Agent Types",
        slug: "agent-types",
        description: "Different types of AI agents and their use cases",
        difficulty: "Intermediate",
        duration: "12 min"
      }
    ]
  end

  def get_api_topics
    [
      {
        title: "Authentication",
        slug: "authentication",
        description: "API key management and security",
        difficulty: "Beginner",
        duration: "7 min"
      },
      {
        title: "Making Your First Request",
        slug: "first-request",
        description: "Basic API usage and response handling",
        difficulty: "Beginner",
        duration: "10 min"
      },
      {
        title: "Rate Limiting",
        slug: "rate-limiting",
        description: "Understanding and managing API limits",
        difficulty: "Intermediate",
        duration: "8 min"
      },
      {
        title: "Error Handling",
        slug: "error-handling",
        description: "Comprehensive error response guide",
        difficulty: "Intermediate",
        duration: "12 min"
      },
      {
        title: "Webhooks",
        slug: "webhooks",
        description: "Real-time notifications and callbacks",
        difficulty: "Advanced",
        duration: "15 min"
      }
    ]
  end

  def get_agents_topics
    [
      {
        title: "EmotiSense Guide",
        slug: "emotisense",
        description: "Emotion analysis and sentiment detection",
        difficulty: "Beginner",
        duration: "12 min"
      },
      {
        title: "ContentCrafter Guide",
        slug: "contentcrafter",
        description: "AI-powered content generation",
        difficulty: "Beginner", 
        duration: "10 min"
      },
      {
        title: "CineGen Guide",
        slug: "cinegen",
        description: "Video creation and editing",
        difficulty: "Intermediate",
        duration: "18 min"
      },
      {
        title: "NeoChat Guide",
        slug: "neochat",
        description: "Conversational AI and chatbots",
        difficulty: "Beginner",
        duration: "8 min"
      }
    ]
  end

  def get_integration_topics
    [
      {
        title: "Slack Integration",
        slug: "slack",
        description: "Connect AI agents to Slack workspaces",
        difficulty: "Intermediate",
        duration: "20 min"
      },
      {
        title: "Discord Bots",
        slug: "discord",
        description: "Build AI-powered Discord bots",
        difficulty: "Intermediate",
        duration: "25 min"
      },
      {
        title: "WordPress Plugin",
        slug: "wordpress",
        description: "Add AI features to WordPress sites",
        difficulty: "Beginner",
        duration: "15 min"
      }
    ]
  end

  def get_auth_topics
    [
      {
        title: "API Keys",
        slug: "api-keys",
        description: "Managing and securing API keys",
        difficulty: "Beginner",
        duration: "5 min"
      },
      {
        title: "OAuth 2.0",
        slug: "oauth",
        description: "OAuth integration for user authentication",
        difficulty: "Advanced",
        duration: "20 min"
      }
    ]
  end

  def get_sdk_topics
    [
      {
        title: "Python SDK",
        slug: "python",
        description: "Official Python library and examples",
        difficulty: "Beginner",
        duration: "10 min"
      },
      {
        title: "Node.js SDK", 
        slug: "nodejs",
        description: "JavaScript/TypeScript SDK for Node.js",
        difficulty: "Beginner",
        duration: "10 min"
      },
      {
        title: "PHP SDK",
        slug: "php",
        description: "PHP library for web applications",
        difficulty: "Beginner",
        duration: "8 min"
      }
    ]
  end

  def get_tutorial_topics
    [
      {
        title: "Build a Customer Service Bot",
        slug: "customer-service-bot",
        description: "Complete tutorial for AI customer support",
        difficulty: "Intermediate",
        duration: "45 min"
      },
      {
        title: "Content Marketing Automation",
        slug: "content-automation",
        description: "Automate content creation workflows",
        difficulty: "Advanced",
        duration: "60 min"
      }
    ]
  end

  def get_troubleshooting_topics
    [
      {
        title: "Common API Errors",
        slug: "api-errors",
        description: "Debugging frequent API issues",
        difficulty: "Beginner",
        duration: "8 min"
      },
      {
        title: "Performance Optimization",
        slug: "performance",
        description: "Optimizing response times and throughput",
        difficulty: "Advanced",
        duration: "15 min"
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
      last_updated: "3 days ago",
      contributors: ["DocsTeam", "AIExpert", "CommunityMember"],
      estimated_read_time: "8 min"
    }
  end

  def get_topic_title(section, topic)
    case "#{section}/#{topic}"
    when "getting-started/quick-start"
      "Quick Start Guide"
    when "api/authentication"
      "API Authentication"
    when "agents/emotisense"
      "EmotiSense Agent Guide"
    else
      "Documentation Topic"
    end
  end

  def get_topic_content(section, topic)
    case "#{section}/#{topic}"
    when "getting-started/quick-start"
      get_quick_start_content
    when "api/authentication"
      get_api_auth_content
    when "agents/emotisense"
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
      - **Pro**: 10,000 requests/hour  
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
end