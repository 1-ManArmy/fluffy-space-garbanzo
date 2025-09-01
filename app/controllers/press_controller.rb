class PressController < ApplicationController
  def index
    @press_articles = [
      {
        id: 'techcrunch',
        publication: 'TechCrunch',
        title: 'Revolutionary AI Platform Changing How People Learn to Code',
        date: 'December 15, 2025',
        excerpt: 'OneLastAI\'s phantom-powered learning platform represents a quantum leap in educational technology, offering personalized AI mentorship that adapts to each learner\'s unique style and pace.',
        logo: 'TC',
        color_start: '#16a085',
        color_end: '#27ae60',
        rating: 5,
        tags: ['AI Innovation', 'EdTech', 'Breakthrough'],
        author: 'Sarah Chen',
        read_time: 8,
        full_content: 'In the rapidly evolving landscape of artificial intelligence and education technology, OneLastAI has emerged as a revolutionary force that\'s fundamentally changing how people approach learning to code.<br><br>The platform\'s phantom AI technology represents a breakthrough in personalized learning, offering an experience that feels almost magical in its ability to anticipate and respond to learner needs.<br><br>"We\'re not just teaching code; we\'re creating a new paradigm where AI becomes your personal coding mentor, understanding your learning style and adapting in real-time," explains the OneLastAI development team.<br><br>What sets OneLastAI apart is its ability to create truly personalized learning experiences that evolve with each interaction, making coding education more accessible and effective than ever before.'
      },
      {
        id: 'wired',
        publication: 'Wired',
        title: 'The Phantom AI Teaching the Next Generation of Developers',
        date: 'November 28, 2025',
        excerpt: 'In the shadowy realm of artificial intelligence, OneLastAI emerges as a groundbreaking force that\'s redefining the essence of coding education with its phantom technology.',
        logo: 'WR',
        color_start: '#e74c3c',
        color_end: '#c0392b',
        rating: 5,
        tags: ['Future Tech', 'AI Learning', 'Innovation'],
        author: 'Marcus Rodriguez',
        read_time: 12,
        full_content: 'In the shadowy realm of artificial intelligence, where algorithms dance with data and machines learn to think, OneLastAI emerges as a groundbreaking force that\'s redefining the very essence of coding education.<br><br>Unlike traditional coding bootcamps or online tutorials, OneLastAI\'s phantom technology creates an almost sentient learning companion that evolves with each interaction.<br><br>"It\'s like having a master programmer\'s ghost whispering the secrets of code directly into your consciousness," describes one beta user.<br><br>The platform\'s sophisticated AI doesn\'t just provide answers—it understands context, anticipates challenges, and guides learners through complex programming concepts with an almost supernatural intuition.'
      },
      {
        id: 'forbes',
        publication: 'Forbes',
        title: 'Best AI Learning Platform of 2025: OneLastAI Dominates the Market',
        date: 'October 10, 2025',
        excerpt: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education and professional development, setting new industry standards.',
        logo: 'FB',
        color_start: '#3498db',
        color_end: '#2980b9',
        rating: 5,
        tags: ['Business Innovation', 'Market Leader', 'Awards'],
        author: 'Jennifer Walsh',
        read_time: 10,
        full_content: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education and professional development in 2025.<br><br>With its innovative phantom AI technology and comprehensive suite of learning tools, OneLastAI has established itself as the gold standard for AI-assisted education.<br><br>"OneLastAI represents the future of learning - where artificial intelligence doesn\'t replace human creativity but amplifies it exponentially," states the Forbes Editorial Board.<br><br>The platform\'s market dominance stems from its unique ability to combine cutting-edge AI technology with deeply human-centered learning experiences, creating an educational environment that\'s both technologically advanced and emotionally engaging.'
      },
      {
        id: 'ai-news',
        publication: 'AI News',
        title: 'Phantom AI Technology Revolutionizes Personalized Learning',
        date: 'September 22, 2025',
        excerpt: 'OneLastAI\'s breakthrough phantom technology is setting new benchmarks in AI-powered education, creating learning experiences that adapt in real-time to individual needs.',
        logo: 'AI',
        color_start: '#9b59b6',
        color_end: '#8e44ad',
        rating: 5,
        tags: ['AI Research', 'Machine Learning', 'Personalization'],
        author: 'Dr. Elena Vasquez',
        read_time: 15,
        full_content: 'OneLastAI\'s breakthrough phantom technology is setting new benchmarks in AI-powered education, creating learning experiences that adapt in real-time to individual needs and learning patterns.<br><br>The research behind phantom AI represents years of development in advanced machine learning algorithms that can understand not just what learners are struggling with, but why they\'re struggling.<br><br>"This isn\'t just adaptive learning—it\'s empathetic AI that truly understands the human learning process," explains Dr. Elena Vasquez, AI researcher and education technology specialist.<br><br>The implications for the future of education are profound, as OneLastAI continues to push the boundaries of what\'s possible when artificial intelligence meets human curiosity and creativity.'
      },
      {
        id: 'techreview',
        publication: 'MIT Technology Review',
        title: 'The Science Behind OneLastAI\'s Learning Revolution',
        date: 'August 18, 2025',
        excerpt: 'An in-depth analysis of the advanced algorithms and neural networks powering OneLastAI\'s phantom AI technology and its impact on educational outcomes.',
        logo: 'MIT',
        color_start: '#f39c12',
        color_end: '#e67e22',
        rating: 5,
        tags: ['Scientific Analysis', 'Neural Networks', 'Research'],
        author: 'Prof. Michael Chang',
        read_time: 20,
        full_content: 'An in-depth analysis of the advanced algorithms and neural networks powering OneLastAI\'s phantom AI technology reveals a sophisticated system that goes far beyond traditional educational AI.<br><br>The platform employs a unique combination of transformer architectures, reinforcement learning, and novel attention mechanisms to create truly personalized learning experiences.<br><br>"What OneLastAI has achieved represents a significant breakthrough in applying advanced AI research to practical educational applications," notes Prof. Michael Chang from MIT\'s Computer Science and Artificial Intelligence Laboratory.<br><br>The technical innovation behind phantom AI includes real-time learning style analysis, predictive difficulty modeling, and adaptive content generation that creates a learning experience as unique as each individual learner.'
      },
      {
        id: 'venture-beat',
        publication: 'VentureBeat',
        title: 'OneLastAI Secures Major Funding for Global Education Expansion',
        date: 'July 30, 2025',
        excerpt: 'Leading venture capital firms invest heavily in OneLastAI\'s vision to democratize coding education through advanced AI technology worldwide.',
        logo: 'VB',
        color_start: '#1abc9c',
        color_end: '#16a085',
        rating: 4,
        tags: ['Funding', 'Startup', 'Global Expansion'],
        author: 'Amanda Foster',
        read_time: 6,
        full_content: 'Leading venture capital firms invest heavily in OneLastAI\'s vision to democratize coding education through advanced AI technology worldwide.<br><br>The substantial funding round will enable OneLastAI to expand its phantom AI platform globally, making advanced coding education accessible to learners in emerging markets and underserved communities.<br><br>"OneLastAI represents the kind of transformative educational technology that can level the playing field globally," comments Amanda Foster, covering the latest in venture capital and startup funding.<br><br>With this investment, OneLastAI plans to launch localized versions of its platform in over 20 countries, bringing world-class AI-powered coding education to millions of new learners worldwide.'
      }
    ]
  end

  def show
    @publication = params[:publication]
    @article = get_article(@publication)

    return unless @article.nil?

    redirect_to press_index_path, alert: 'Article not found'
    nil
  end

  private

  def get_article(publication)
    case publication
    when 'techcrunch'
      {
        publication: 'TechCrunch',
        title: 'Revolutionary AI Platform Changing How People Learn to Code',
        date: 'December 15, 2025',
        author: 'Sarah Chen',
        logo: 'TC',
        color: 'green',
        excerpt: 'OneLastAI\'s phantom-powered learning platform represents a quantum leap in educational technology...',
        content: [
          {
            type: 'paragraph',
            text: 'In the rapidly evolving landscape of artificial intelligence and education technology, OneLastAI has emerged as a revolutionary force that\'s fundamentally changing how people approach learning to code.'
          },
          {
            type: 'quote',
            text: 'We\'re not just teaching code; we\'re creating a new paradigm where AI becomes your personal coding mentor, understanding your learning style and adapting in real-time.',
            author: 'OneLastAI Team'
          },
          {
            type: 'paragraph',
            text: 'The platform\'s phantom AI technology represents a breakthrough in personalized learning, offering an experience that feels almost magical in its ability to anticipate and respond to learner needs.'
          }
        ],
        tags: %w[AI Education Technology Innovation],
        rating: 5,
        badge: 'Editor\'s Choice'
      }
    when 'wired'
      {
        publication: 'Wired',
        title: 'The Phantom AI Teaching the Next Generation of Developers',
        date: 'November 28, 2025',
        author: 'Marcus Rodriguez',
        logo: 'WR',
        color: 'red',
        excerpt: 'In the shadowy realm of artificial intelligence, OneLastAI emerges as a groundbreaking force...',
        content: [
          {
            type: 'paragraph',
            text: 'In the shadowy realm of artificial intelligence, where algorithms dance with data and machines learn to think, OneLastAI emerges as a groundbreaking force that\'s redefining the very essence of coding education.'
          },
          {
            type: 'paragraph',
            text: 'Unlike traditional coding bootcamps or online tutorials, OneLastAI\'s phantom technology creates an almost sentient learning companion that evolves with each interaction.'
          },
          {
            type: 'quote',
            text: 'It\'s like having a master programmer\'s ghost whispering the secrets of code directly into your consciousness.',
            author: 'Beta User Review'
          }
        ],
        tags: ['AI', 'Programming', 'Future Tech', 'Learning'],
        rating: 5,
        badge: 'Must Read'
      }
    when 'forbes'
      {
        publication: 'Forbes',
        title: 'Best AI Learning Platform of 2025',
        date: 'October 10, 2025',
        author: 'Jennifer Walsh',
        logo: 'FB',
        color: 'blue',
        excerpt: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education...',
        content: [
          {
            type: 'paragraph',
            text: 'Forbes recognizes OneLastAI as the premier AI-powered learning platform transforming education and professional development in 2025.'
          },
          {
            type: 'paragraph',
            text: 'With its innovative phantom AI technology and comprehensive suite of learning tools, OneLastAI has established itself as the gold standard for AI-assisted education.'
          },
          {
            type: 'quote',
            text: 'OneLastAI represents the future of learning - where artificial intelligence doesn\'t replace human creativity but amplifies it exponentially.',
            author: 'Forbes Editorial Board'
          }
        ],
        tags: %w[Business AI Education Awards],
        rating: 5,
        badge: 'Top Pick'
      }
    else
      nil
    end
  end
end
