class InfrastructureController < ApplicationController
  before_action :set_page_title

  def index
    @page_title = 'Infrastructure - Enterprise-Grade Platform'
    @tech_stack = [
      {
        name: 'AWS EC2',
        description: 'Auto-scaling cloud infrastructure with 99.9% uptime',
        icon: '☁️',
        category: 'cloud',
        features: ['Auto-scaling', 'Load Balancing', 'Global CDN']
      },
      {
        name: 'MongoDB Atlas',
        description: 'Secure, scalable NoSQL database with automated backups',
        icon: '🍃',
        category: 'database',
        features: %w[Auto-scaling Backups Security]
      },
      {
        name: 'Passage Auth',
        description: 'Passwordless authentication powered by 1Password',
        icon: '🔐',
        category: 'security',
        features: ['Passwordless', 'Biometric', 'Zero Trust']
      },
      {
        name: 'Payment Systems',
        description: 'Multiple payment providers for global accessibility',
        icon: '💳',
        category: 'payments',
        features: ['Stripe', 'PayPal', 'Lemon Squeezy']
      }
    ]
  end

  def tech_stack
    @page_title = 'Technology Stack - Infrastructure'
    @technologies = {
      cloud: [
        { name: 'AWS EC2', description: 'Elastic compute cloud platform', status: 'active' },
        { name: 'CloudFlare', description: 'Global CDN and security', status: 'active' },
        { name: 'Docker', description: 'Container orchestration', status: 'active' }
      ],
      database: [
        { name: 'MongoDB Atlas', description: 'Primary NoSQL database', status: 'active' },
        { name: 'Redis', description: 'In-memory caching', status: 'active' },
        { name: 'PostgreSQL', description: 'Relational data backup', status: 'standby' }
      ],
      ai: [
        { name: 'OpenAI', description: 'GPT models and APIs', status: 'active' },
        { name: 'Anthropic', description: 'Claude AI integration', status: 'active' },
        { name: 'Google AI', description: 'agent and Vertex AI', status: 'active' },
        { name: 'Runway ML', description: 'Video generation platform', status: 'active' }
      ]
    }
  end

  def security
    @page_title = 'Security Infrastructure'
    @security_features = [
      {
        title: 'Zero Trust Architecture',
        description: 'Every request is verified and authenticated',
        level: 'enterprise'
      },
      {
        title: 'End-to-End Encryption',
        description: 'All data encrypted in transit and at rest',
        level: 'military'
      },
      {
        title: 'SOC 2 Compliance',
        description: 'Enterprise-grade security standards',
        level: 'certified'
      }
    ]
  end

  def deployment
    @page_title = 'Deployment Infrastructure'
    @deployment_info = {
      environments: %w[Development Staging Production],
      ci_cd: 'GitHub Actions',
      monitoring: ['DataDog', 'Sentry', 'New Relic'],
      uptime: '99.9%'
    }
  end

  private

  def set_page_title
    @page_title ||= 'Infrastructure'
  end
end
