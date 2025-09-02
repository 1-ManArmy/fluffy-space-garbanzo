#!/usr/bin/env ruby
# OneLastAI Credentials Setup Script

puts "🚀 OneLastAI Credentials Setup"
puts "=" * 40

# Check if we have the required credentials
def check_credentials
  puts "\n📋 Checking current credentials..."
  
  # Check if master.key exists
  if File.exist?('config/master.key')
    puts "✅ master.key found"
  else
    puts "❌ master.key missing"
    puts "   Run: rails new . --force to regenerate"
  end
  
  # Check if we can access Rails credentials
  begin
    require './config/environment'
    creds = Rails.application.credentials
    
    if creds.secret_key_base
      puts "✅ secret_key_base configured"
    else
      puts "❌ secret_key_base missing"
    end
    
    if creds.openai&.api_key
      puts "✅ OpenAI API key configured"
    else
      puts "⚠️  OpenAI API key missing (required for AI features)"
    end
    
  rescue => e
    puts "❌ Cannot access Rails credentials: #{e.message}"
    puts "   You may need to set up credentials first"
  end
end

# Generate a new secret key
def generate_secret_key
  require 'securerandom'
  SecureRandom.hex(64)
end

# Setup script
def setup_credentials
  puts "\n🔧 Setting up credentials..."
  
  # Generate new secret key
  new_secret = generate_secret_key
  puts "Generated new secret_key_base: #{new_secret[0..20]}..."
  
  # Create .env file for development
  env_content = <<~ENV
    # OneLastAI Development Environment Variables
    # Copy your actual API keys here
    
    SECRET_KEY_BASE=#{new_secret}
    
    # AI Service API Keys (required)
    OPENAI_API_KEY=your-openai-api-key-here
    HUGGINGFACE_TOKEN=your-hf-token-here
    
    # Optional AI Services
    ANTHROPIC_API_KEY=your-anthropic-key-here
    GROQ_API_KEY=your-groq-key-here
    
    # Database
    DATABASE_URL=postgresql://onelastai:onelastai_secure_db_2024@localhost:5432/onelastai_production
    
    # Redis
    REDIS_URL=redis://localhost:6379
    
    # Rails Environment
    RAILS_ENV=development
    NODE_ENV=development
  ENV
  
  File.write('.env', env_content)
  puts "✅ Created .env file"
  
  # Update .gitignore to ensure .env is not committed
  gitignore_content = File.read('.gitignore') rescue ""
  unless gitignore_content.include?('.env')
    File.write('.gitignore', gitignore_content + "\n# Environment variables\n.env\n.env.local\n")
    puts "✅ Updated .gitignore"
  end
  
  puts "\n📝 Next steps:"
  puts "1. Edit .env file and add your actual API keys"
  puts "2. Get OpenAI API key from: https://platform.openai.com/api-keys"
  puts "3. Get HuggingFace token from: https://huggingface.co/settings/tokens"
  puts "4. Run: bundle exec rails server"
end

# Main execution
if ARGV[0] == "check"
  check_credentials
elsif ARGV[0] == "setup"
  setup_credentials
else
  puts "\nUsage:"
  puts "  ruby setup_credentials.rb check   # Check current setup"
  puts "  ruby setup_credentials.rb setup   # Set up new credentials"
  puts "\n🔗 For detailed instructions, see: CREDENTIALS_SETUP_GUIDE.md"
end
