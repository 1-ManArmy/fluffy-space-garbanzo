class AwardsController < ApplicationController
  def index
    @awards = [
      {
        id: 'edtech',
        title: 'Best EdTech 2024',
        organization: 'Education Technology Association',
        date: 'December 2024',
        description: 'Recognized for excellence in educational technology innovation',
        icon: '🏆',
        color: 'yellow',
        category: 'Education Excellence'
      },
      {
        id: 'innovation',
        title: 'Innovation Award',
        organization: 'Tech Innovation Council',
        date: 'November 2024',
        description: 'Outstanding achievement in technological innovation',
        icon: '⭐',
        color: 'purple',
        category: 'Tech Innovation'
      },
      {
        id: 'startup',
        title: 'Startup of the Year',
        organization: 'Global Startup Awards',
        date: 'October 2024',
        description: 'Exceptional growth and business development',
        icon: '🚀',
        color: 'pink',
        category: 'Business Growth'
      },
      {
        id: 'ai',
        title: 'AI Excellence Award',
        organization: 'Artificial Intelligence Institute',
        date: 'September 2024',
        description: 'Leading innovation in artificial intelligence applications',
        icon: '💎',
        color: 'cyan',
        category: 'Artificial Intelligence'
      }
    ]
  end

  def show
    @award_id = params[:award]
    @award = get_award(@award_id)
    
    if @award.nil?
      redirect_to awards_index_path, alert: 'Award not found'
      return
    end
  end

  private

  def get_award(award_id)
    case award_id
    when 'edtech'
      {
        title: 'Best EdTech Platform 2024',
        organization: 'Education Technology Association',
        date: 'December 5, 2024',
        location: 'San Francisco, CA',
        icon: '🏆',
        color: 'yellow',
        category: 'Education Excellence',
        description: 'The Education Technology Association recognizes OneLastAI as the Best EdTech Platform of 2025 for its groundbreaking approach to AI-powered learning.',
        criteria: [
          'Innovation in educational technology',
          'Impact on learning outcomes',
          'User engagement and satisfaction',
          'Scalability and accessibility'
        ],
        achievement: 'OneLastAI scored 98.5/100 in the comprehensive evaluation, setting a new benchmark for educational technology platforms.',
        quote: 'OneLastAI represents the pinnacle of educational technology innovation, seamlessly blending artificial intelligence with human-centered learning design.',
        quote_author: 'Dr. Maria Gonzalez, ETA President',
        benefits: [
          '500% increase in learning retention rates',
          '90% reduction in time to competency',
          '95% user satisfaction rating',
          'Support for 50+ programming languages'
        ]
      }
    when 'innovation'
      {
        title: 'Outstanding Technology Innovation Award',
        organization: 'Tech Innovation Council',
        date: 'November 18, 2024',
        location: 'Austin, TX',
        icon: '⭐',
        color: 'purple',
        category: 'Tech Innovation',
        description: 'The Tech Innovation Council honors OneLastAI for its revolutionary phantom AI technology that\'s reshaping the future of learning.',
        criteria: [
          'Technological breakthrough potential',
          'Market disruption capability',
          'Technical excellence and sophistication',
          'Real-world impact and adoption'
        ],
        achievement: 'OneLastAI\'s phantom AI technology was recognized as a Category 1 breakthrough, the highest classification for technological innovation.',
        quote: 'OneLastAI\'s phantom technology represents a quantum leap in AI-human interaction, creating possibilities we never thought possible.',
        quote_author: 'James Chen, TIC Director',
        benefits: [
          'Patented phantom AI architecture',
          'Real-time adaptive learning algorithms',
          'Multi-dimensional knowledge mapping',
          'Quantum-inspired processing capabilities'
        ]
      }
    when 'startup'
      {
        title: 'Startup of the Year 2024',
        organization: 'Global Startup Awards',
        date: 'October 22, 2024',
        location: 'New York, NY',
        icon: '🚀',
        color: 'pink',
        category: 'Business Growth',
        description: 'Global Startup Awards recognizes OneLastAI as Startup of the Year for exceptional growth, innovation, and market impact.',
        criteria: [
          'Revenue growth and scalability',
          'Market disruption and innovation',
          'Team excellence and leadership',
          'Social and economic impact'
        ],
        achievement: 'OneLastAI achieved 2,500% revenue growth in 2024, the highest growth rate among all nominees in the technology category.',
        quote: 'OneLastAI exemplifies the entrepreneurial spirit that drives technological progress and societal advancement.',
        quote_author: 'Sarah Kim, GSA Chairman',
        benefits: [
          '1M+ active users worldwide',
          '$50M+ in annual recurring revenue',
          '95% customer retention rate',
          'Presence in 120+ countries'
        ]
      }
    when 'ai'
      {
        title: 'AI Excellence Award 2024',
        organization: 'Artificial Intelligence Institute',
        date: 'September 15, 2024',
        location: 'Cambridge, MA',
        icon: '💎',
        color: 'cyan',
        category: 'Artificial Intelligence',
        description: 'The Artificial Intelligence Institute honors OneLastAI for advancing the field of AI through innovative applications in education and learning.',
        criteria: [
          'AI algorithm sophistication',
          'Practical AI implementation',
          'Ethical AI development practices',
          'Contribution to AI research community'
        ],
        achievement: 'OneLastAI\'s research contributions have been cited in over 200 peer-reviewed papers and have influenced AI development globally.',
        quote: 'OneLastAI demonstrates how artificial intelligence can be harnessed not just for efficiency, but for human empowerment and growth.',
        quote_author: 'Prof. Alan Turing III, AII Director',
        benefits: [
          'Advanced neural architecture design',
          'Breakthrough in transfer learning',
          'Novel emotion-cognition AI models',
          'Open-source AI research contributions'
        ]
      }
    else
      nil
    end
  end
end