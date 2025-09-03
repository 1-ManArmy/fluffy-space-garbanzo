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

  def cloud
    @page_title = 'Cloud Infrastructure - Railway Platform'
    @cloud_info = {
      provider: 'Railway',
      description: 'Modern cloud platform with automatic scaling and deployment',
      features: [
        'Automatic deployments from GitHub',
        'Built-in PostgreSQL database',
        'Custom domain support (onelastai.com)',
        'SSL certificates (automatic)',
        'Global CDN via Cloudflare',
        'Auto-scaling based on traffic'
      ],
      benefits: [
        'Zero server management',
        'Instant deployments',
        'Cost-effective pricing',
        'Developer-friendly'
      ],
      pricing: '$5-10/month',
      status: 'Planned for deployment'
    }
  end

  def database
    @page_title = 'Database Infrastructure'
    @database_info = {
      primary: {
        name: 'PostgreSQL 15',
        provider: 'Railway',
        description: 'Production-ready PostgreSQL with automatic backups',
        features: ['ACID compliance', 'Full-text search', 'JSON support', 'Auto-backups']
      },
      cache: {
        name: 'Redis 7',
        provider: 'Railway/Docker',
        description: 'In-memory cache for session storage and performance',
        features: ['Session storage', 'Rate limiting', 'Real-time features']
      },
      current_config: {
        environment: 'Docker Compose',
        postgres_version: '15-alpine',
        redis_version: '7-alpine',
        connection_pooling: 'Enabled'
      }
    }
  end

  def security
    @page_title = 'Security Infrastructure - Keycloak Identity Management'
    @security_info = {
      identity_provider: {
        name: 'Keycloak',
        description: 'Open-source identity and access management solution',
        features: [
          'Single Sign-On (SSO)',
          'Multi-factor authentication (MFA)',
          'Social login integration',
          'Role-based access control (RBAC)',
          'OAuth 2.0 / OpenID Connect',
          'User federation'
        ],
        status: 'Configured for deployment'
      },
      ssl_security: {
        provider: 'Cloudflare + Let\'s Encrypt',
        features: ['Wildcard SSL for *.onelastai.com', 'TLS 1.3', 'HSTS', 'Certificate auto-renewal']
      },
      application_security: {
        features: [
          'CORS protection',
          'Rate limiting',
          'Input validation',
          'SQL injection prevention',
          'XSS protection',
          'CSRF tokens'
        ]
      },
      compliance: ['GDPR ready', 'SOC 2 Type II preparation', 'ISO 27001 aligned']
    }
  end

  def payments
    @page_title = 'Payment Infrastructure'
    @payment_info = {
      primary_providers: [
        {
          name: 'Stripe',
          description: 'Primary payment processor with global reach',
          features: ['Credit/Debit cards', 'Apple Pay', 'Google Pay', 'ACH', 'International'],
          fees: '2.9% + 30¢',
          status: 'Active'
        },
        {
          name: 'PayPal',
          description: 'Alternative payment method for user preference',
          features: ['PayPal balance', 'Credit cards', 'Bank transfers', 'Pay in 4'],
          fees: '2.9% + fixed fee',
          status: 'Integrated'
        }
      ],
      additional_providers: [
        {
          name: 'Lemon Squeezy',
          description: 'Modern payment platform for digital products',
          features: ['Global tax compliance', 'Subscription management', 'Digital receipts'],
          fees: '5% + payment processing',
          status: 'Planned'
        }
      ],
      subscription_features: [
        'Automatic billing cycles',
        'Pro-rated upgrades/downgrades',
        'Dunning management',
        'Tax calculation',
        'Invoice generation',
        'Payment analytics'
      ],
      security: [
        'PCI DSS Level 1 compliance',
        'Tokenized card storage',
        'Fraud detection',
        '3D Secure authentication'
      ]
    }
  end

  private

  def set_page_title
    @page_title ||= 'Infrastructure'
  end
end
