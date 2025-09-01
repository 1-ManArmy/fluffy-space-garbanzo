class CommunityController < ApplicationController
  def index
    @recent_discussions = get_recent_discussions
    @community_stats = get_community_stats
    @featured_posts = get_featured_posts
  end

  def forum
    @categories = get_forum_categories
    @recent_posts = get_recent_forum_posts
    @trending_topics = get_trending_topics
  end

  def forum_category
    @category = params[:category]
    @posts = get_posts_by_category(@category)
    @category_info = get_category_info(@category)
  end

  def show_post
    @post = get_forum_post(params[:id])
    @replies = get_post_replies(params[:id])
    @related_posts = get_related_posts(@post)
  end

  def create_post
    # Handle forum post creation
    @post = create_forum_post(post_params)

    if @post
      redirect_to community_show_post_path(@post[:id]), notice: 'Post created successfully!'
    else
      redirect_to community_forum_path, alert: 'Error creating post.'
    end
  end

  def create_reply
    # Handle reply creation
    @reply = create_forum_reply(reply_params)

    if @reply
      redirect_to community_show_post_path(params[:post_id]), notice: 'Reply posted successfully!'
    else
      redirect_back(fallback_location: community_forum_path, alert: 'Error posting reply.')
    end
  end

  private

  def get_recent_discussions
    [
      {
        id: 1,
        title: 'Best practices for AI agent integration',
        author: 'TechExplorer',
        replies: 23,
        last_activity: '2 hours ago',
        category: 'Development'
      },
      {
        id: 2,
        title: 'Phantom AI Platform roadmap discussion',
        author: 'CommunityManager',
        replies: 67,
        last_activity: '4 hours ago',
        category: 'General'
      },
      {
        id: 3,
        title: 'Share your AI success stories',
        author: 'InnovationHub',
        replies: 45,
        last_activity: '6 hours ago',
        category: 'Showcase'
      },
      {
        id: 4,
        title: 'API rate limits and optimization tips',
        author: 'DevMaster',
        replies: 31,
        last_activity: '8 hours ago',
        category: 'Technical'
      }
    ]
  end

  def get_community_stats
    {
      total_members: 50_247,
      active_discussions: 1285,
      posts_today: 342,
      answers_given: 8934
    }
  end

  def get_featured_posts
    [
      {
        id: 5,
        title: 'Monthly AI Innovation Showcase',
        excerpt: 'Discover the most innovative AI implementations from our community this month...',
        author: 'AIShowcase',
        featured_image: 'showcase.jpg',
        read_time: '5 min'
      },
      {
        id: 6,
        title: 'Building Your First Multi-Agent System',
        excerpt: 'A comprehensive guide to creating coordinated AI agent workflows...',
        author: 'TutorialTeam',
        featured_image: 'tutorial.jpg',
        read_time: '12 min'
      }
    ]
  end

  def get_forum_categories
    [
      {
        name: 'General Discussion',
        slug: 'general',
        description: 'General discussions about AI development, industry trends, and community news',
        post_count: 1234,
        topics: 1234,
        posts: 5678,
        icon: '💬',
        color: 'blue'
      },
      {
        name: 'Technical Support',
        slug: 'support',
        description: 'Get help with technical issues, API questions, and troubleshooting',
        post_count: 2345,
        topics: 2345,
        posts: 8901,
        icon: '🔧',
        color: 'green'
      },
      {
        name: 'Feature Requests',
        slug: 'features',
        description: 'Suggest new features, improvements, and share your ideas with the community',
        post_count: 567,
        topics: 567,
        posts: 2345,
        icon: '💡',
        color: 'purple'
      },
      {
        name: 'Showcase',
        slug: 'showcase',
        description: 'Share your projects, success stories, and inspire others with your creations',
        post_count: 890,
        topics: 890,
        posts: 3456,
        icon: '🚀',
        color: 'orange'
      }
    ]
  end

  def get_recent_forum_posts
    [
      {
        id: 7,
        title: 'How to optimize EmotiSense for customer service',
        author: 'ServicePro',
        category: 'AI Agents',
        replies: 12,
        views: 234,
        created_at: '3 hours ago',
        last_reply: '1 hour ago'
      },
      {
        id: 8,
        title: 'ContentCrafter API rate limiting best practices',
        author: 'APIExpert',
        category: 'API & Integration',
        replies: 8,
        views: 156,
        created_at: '5 hours ago',
        last_reply: '2 hours ago'
      },
      {
        id: 9,
        title: 'New CineGen video export features',
        author: 'VideoCreator',
        category: 'Showcase',
        replies: 25,
        views: 487,
        created_at: '1 day ago',
        last_reply: '3 hours ago'
      }
    ]
  end

  def get_trending_topics
    [
      'AI agent chaining',
      'Multi-modal processing',
      'Custom training data',
      'Enterprise integration',
      'Real-time analytics'
    ]
  end

  def get_posts_by_category(category)
    # Simulate category-specific posts
    case category
    when 'general'
      get_general_posts
    when 'support'
      get_support_posts
    when 'features'
      get_feature_posts
    when 'showcase'
      get_showcase_posts
    else
      []
    end
  end

  def get_category_info(category)
    categories = get_forum_categories
    categories.find { |cat| cat[:slug] == category } || {}
  end

  def get_forum_post(id)
    {
      id: id,
      title: 'Best practices for AI agent integration',
      content: "I've been working with the Phantom AI platform for several months now and wanted to share some best practices I've discovered...",
      author: 'TechExplorer',
      created_at: '2 days ago',
      views: 342,
      likes: 23,
      category: 'Development',
      tags: %w[best-practices integration ai-agents]
    }
  end

  def get_post_replies(post_id)
    [
      {
        id: 1,
        content: "Great insights! I've been using similar approaches with ContentCrafter...",
        author: 'DevMaster',
        created_at: '1 day ago',
        likes: 8
      },
      {
        id: 2,
        content: 'This is exactly what I needed. The API chaining technique is brilliant!',
        author: 'NewDeveloper',
        created_at: '18 hours ago',
        likes: 5
      }
    ]
  end

  def get_related_posts(post)
    [
      {
        id: 10,
        title: 'Advanced API chaining techniques',
        author: 'APIGuru'
      },
      {
        id: 11,
        title: 'Error handling in multi-agent workflows',
        author: 'ReliabilityExpert'
      }
    ]
  end

  def get_general_posts
    [
      {
        id: 12,
        title: 'Welcome to the Phantom AI Community!',
        author: 'CommunityManager',
        replies: 156,
        views: 2847,
        created_at: '1 week ago'
      }
    ]
  end

  def get_development_posts
    [
      {
        id: 13,
        title: 'Setting up your development environment',
        author: 'DevTeam',
        replies: 89,
        views: 1923,
        created_at: '3 days ago'
      }
    ]
  end

  def get_api_posts
    [
      {
        id: 14,
        title: 'API authentication best practices',
        author: 'SecurityExpert',
        replies: 67,
        views: 1456,
        created_at: '2 days ago'
      }
    ]
  end

  def get_agent_posts
    [
      {
        id: 15,
        title: 'Comparing different AI agent capabilities',
        author: 'AgentExplorer',
        replies: 134,
        views: 2134,
        created_at: '4 days ago'
      }
    ]
  end

  def get_showcase_posts
    [
      {
        id: 16,
        title: 'My AI-powered e-commerce chatbot success story',
        author: 'EcommerceFounder',
        replies: 45,
        views: 892,
        created_at: '1 day ago'
      }
    ]
  end

  def get_feature_posts
    [
      {
        id: 17,
        title: 'Request: Batch processing for CineGen',
        author: 'VideoProducer',
        replies: 28,
        views: 634,
        created_at: '5 days ago'
      }
    ]
  end

  def create_forum_post(params)
    # Simulate post creation
    {
      id: rand(1000..9999),
      title: params[:title],
      content: params[:content],
      category: params[:category]
    }
  end

  def create_forum_reply(params)
    # Simulate reply creation
    {
      id: rand(1000..9999),
      content: params[:content],
      post_id: params[:post_id]
    }
  end

  def post_params
    params.require(:post).permit(:title, :content, :category, :tags)
  end

  def reply_params
    params.require(:reply).permit(:content, :post_id)
  end

  def get_support_posts
    [
      {
        id: 201,
        title: 'API authentication issues with EmotiSense',
        excerpt: "I'm having trouble connecting to the EmotiSense API with my authentication keys...",
        author: 'DevNewbie',
        replies: 12,
        last_activity: '3 hours ago',
        pinned: false,
        solved: true
      },
      {
        id: 202,
        title: 'CineGen video rendering timeout',
        excerpt: 'My video rendering process is timing out after 5 minutes. Is there a way to extend this?',
        author: 'VideoCreator',
        replies: 8,
        last_activity: '6 hours ago',
        pinned: false,
        solved: false
      },
      {
        id: 203,
        title: 'Rate limiting documentation clarification',
        excerpt: 'The API documentation mentions rate limits but I need clarification on the exact limits...',
        author: 'TechLead',
        replies: 15,
        last_activity: '1 day ago',
        pinned: true,
        solved: true
      }
    ]
  end

  def get_feature_posts
    [
      {
        id: 301,
        title: 'Voice cloning feature for NeoChat',
        excerpt: 'It would be amazing if NeoChat could clone voices for more personalized conversations...',
        author: 'AIEnthusiast',
        replies: 45,
        last_activity: '2 hours ago',
        pinned: false,
        solved: false
      },
      {
        id: 302,
        title: 'Multi-language support for all agents',
        excerpt: 'Currently only some agents support multiple languages. It would be great to have this across all agents...',
        author: 'GlobalUser',
        replies: 23,
        last_activity: '5 hours ago',
        pinned: false,
        solved: false
      },
      {
        id: 303,
        title: 'Custom training data upload',
        excerpt: 'The ability to upload custom training data for agents would be a game-changer...',
        author: 'DataScientist',
        replies: 67,
        last_activity: '1 day ago',
        pinned: true,
        solved: false
      }
    ]
  end

  def get_general_posts
    [
      {
        id: 101,
        title: 'Welcome to the Phantom AI Community!',
        excerpt: 'Welcome everyone! This is the place to discuss anything related to AI development and our platform...',
        author: 'CommunityManager',
        replies: 156,
        last_activity: '1 hour ago',
        pinned: true,
        solved: false
      },
      {
        id: 102,
        title: 'Monthly AI Innovation Showcase',
        excerpt: 'Share your latest AI innovations and get feedback from the community...',
        author: 'InnovationHub',
        replies: 89,
        last_activity: '4 hours ago',
        pinned: false,
        solved: false
      },
      {
        id: 103,
        title: 'Industry trends and predictions for 2025',
        excerpt: 'What are your thoughts on where AI development is heading this year?',
        author: 'FuturistTech',
        replies: 34,
        last_activity: '7 hours ago',
        pinned: false,
        solved: false
      }
    ]
  end

  def get_showcase_posts
    [
      {
        id: 401,
        title: 'Built an AI-powered customer service bot with EmotiSense',
        excerpt: 'I successfully integrated EmotiSense into our customer service platform and saw 40% improvement in satisfaction...',
        author: 'CustomerSuccessPro',
        replies: 28,
        last_activity: '2 hours ago',
        pinned: false,
        solved: false
      },
      {
        id: 402,
        title: 'Created a viral marketing video using CineGen',
        excerpt: "Our latest marketing campaign video was created entirely with CineGen and it went viral! Here's how...",
        author: 'MarketingGuru',
        replies: 67,
        last_activity: '5 hours ago',
        pinned: true,
        solved: false
      },
      {
        id: 403,
        title: 'AI-powered content strategy increased engagement 300%',
        excerpt: 'Using ContentCrafter, we developed a content strategy that tripled our social media engagement...',
        author: 'ContentKing',
        replies: 52,
        last_activity: '1 day ago',
        pinned: false,
        solved: false
      }
    ]
  end
end
