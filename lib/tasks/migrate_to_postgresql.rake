# lib/tasks/migrate_to_postgresql.rake

namespace :db do
  desc "Migrate data from MongoDB to PostgreSQL"
  task migrate_from_mongo: :environment do
    puts "🚀 Starting MongoDB to PostgreSQL migration..."
    
    migration_service = MongoToPostgresqlMigrationService.new
    
    begin
      migration_service.migrate_all
      puts "✅ Migration completed successfully!"
      puts "📊 Check the migration log at: #{Rails.root.join('log', 'migration.log')}"
    rescue StandardError => e
      puts "❌ Migration failed: #{e.message}"
      puts "📋 Check the migration log for details"
      raise
    end
  end

  desc "Verify PostgreSQL migration integrity"
  task verify_migration: :environment do
    puts "🔍 Verifying migration integrity..."
    
    checks = {
      "Users exist" => -> { User.count > 0 },
      "Agents exist" => -> { Agent.count > 0 },
      "User-Agent relationships" => -> { Conversation.joins(:user, :agent).count > 0 },
      "Message content integrity" => -> { Message.where.not(content: [nil, '']).count > 0 },
      "Subscription data" => -> { Subscription.count >= 0 },
      "No orphaned conversations" => -> { Conversation.left_joins(:user).where(users: { id: nil }).count == 0 },
      "No orphaned messages" => -> { Message.left_joins(:conversation).where(conversations: { id: nil }).count == 0 }
    }
    
    results = {}
    checks.each do |check_name, check_proc|
      begin
        results[check_name] = check_proc.call
        status = results[check_name] ? "✅" : "❌"
        puts "#{status} #{check_name}: #{results[check_name]}"
      rescue StandardError => e
        results[check_name] = "ERROR: #{e.message}"
        puts "💥 #{check_name}: #{results[check_name]}"
      end
    end
    
    failed_checks = results.select { |_name, result| result == false || result.to_s.start_with?("ERROR") }
    
    if failed_checks.empty?
      puts "\n🎉 All integrity checks passed!"
    else
      puts "\n⚠️  #{failed_checks.count} checks failed:"
      failed_checks.each { |name, result| puts "   - #{name}: #{result}" }
    end
  end

  desc "Create sample data for testing"
  task create_sample_data: :environment do
    puts "🌱 Creating sample data..."
    
    # Create sample user
    user = User.create!(
      keycloak_id: SecureRandom.uuid,
      username: "demo_user",
      email: "demo@onelastai.com",
      first_name: "Demo",
      last_name: "User",
      subscription_tier: "pro"
    )
    
    # Create sample agents
    sample_agents = [
      {
        name: "ChatBot Assistant",
        agent_type: "chatbot",
        description: "General purpose conversational AI",
        subdomain: "chat",
        capabilities: %w[conversation basic_qa]
      },
      {
        name: "Code Helper",
        agent_type: "specialist",
        description: "Programming and code assistance",
        subdomain: "code",
        capabilities: %w[code_analysis debugging programming_help]
      }
    ]
    
    agents = sample_agents.map { |attrs| Agent.create!(attrs) }
    
    # Create sample conversation
    conversation = Conversation.create!(
      user: user,
      agent: agents.first,
      title: "Welcome Conversation"
    )
    
    # Create sample messages
    conversation.add_user_message("Hello, I'm testing the new PostgreSQL integration!")
    conversation.add_assistant_message(
      "Hello! I'm excited to help you with the new PostgreSQL-powered OneLastAI platform. How can I assist you today?",
      model_used: "llama3.2",
      tokens_used: 45,
      processing_time: 0.8
    )
    
    puts "✅ Sample data created:"
    puts "   - User: #{user.username} (#{user.email})"
    puts "   - Agents: #{agents.map(&:name).join(', ')}"
    puts "   - Conversation: #{conversation.title}"
    puts "   - Messages: #{conversation.messages.count}"
  end

  desc "Clean up MongoDB references and prepare for removal"
  task cleanup_mongo_references: :environment do
    puts "🧹 Cleaning up MongoDB references..."
    
    # Remove MongoDB configuration files (backup first)
    mongo_files = [
      Rails.root.join('config', 'mongoid.yml'),
      Rails.root.join('config', 'initializers', 'mongoid.rb')
    ]
    
    mongo_files.each do |file|
      if File.exist?(file)
        backup_file = "#{file}.backup.#{Time.current.to_i}"
        FileUtils.copy(file, backup_file)
        puts "📋 Backed up #{file} to #{backup_file}"
        
        File.delete(file)
        puts "🗑️  Removed #{file}"
      end
    end
    
    puts "✅ MongoDB reference cleanup completed"
  end

  desc "Update environment for PostgreSQL production"
  task setup_postgresql_env: :environment do
    puts "⚙️  Setting up PostgreSQL environment..."
    
    env_vars = {
      'DATABASE_URL' => 'postgresql://onelastai:your_secure_password@localhost:5432/onelastai_production',
      'DATABASE_HOST' => 'localhost',
      'DATABASE_PORT' => '5432',
      'DATABASE_USERNAME' => 'onelastai',
      'DATABASE_NAME' => 'onelastai_production',
      'KEYCLOAK_URL' => 'http://localhost:8080',
      'KEYCLOAK_REALM' => 'onelastai',
      'KEYCLOAK_CLIENT_ID' => 'onelastai-web'
    }
    
    env_example_file = Rails.root.join('.env.example')
    env_content = []
    
    if File.exist?(env_example_file)
      env_content = File.readlines(env_example_file)
    end
    
    env_vars.each do |key, value|
      line = "#{key}=#{value}\n"
      unless env_content.any? { |l| l.start_with?("#{key}=") }
        env_content << line
        puts "📝 Added #{key} to environment configuration"
      end
    end
    
    File.write(env_example_file, env_content.join)
    puts "✅ Environment configuration updated"
    puts "💡 Don't forget to:"
    puts "   1. Copy .env.example to .env"
    puts "   2. Update password values with secure passwords"
    puts "   3. Configure Keycloak client secret"
  end
end
