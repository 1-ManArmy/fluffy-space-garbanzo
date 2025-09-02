# Simple seeds for PostgreSQL migration test
puts "🌟 Creating simple test data..."

# Create a test user
user = User.create!(
  keycloak_id: "test-user-001",
  username: "testuser",
  email: "test@onelastai.com",
  first_name: "Test",
  last_name: "User",
  subscription_tier: "free"
)

puts "✅ Created user: #{user.email}"

# Create a test agent  
agent = Agent.create!(
  name: "Test Assistant",
  description: "A simple test AI assistant",
  agent_type: "assistant",
  status: "active",
  prompt_template: "You are a helpful AI assistant.",
  model_config: { model: "gpt-3.5-turbo", temperature: 0.7 }.to_json
)

puts "✅ Created agent: #{agent.name}"

# Create a conversation
conversation = Conversation.create!(
  user: user,
  agent: agent,
  title: "Test Conversation",
  session_id: SecureRandom.uuid
)

puts "✅ Created conversation: #{conversation.title}"

# Create a message
message = Message.create!(
  conversation: conversation,
  role: "user",
  content: "Hello, this is a test message",
  tokens_used: 10
)

puts "✅ Created message: #{message.content[0..50]}..."

puts "🎉 Simple seed data created successfully!"
puts "Data counts:"
puts "  Users: #{User.count}"
puts "  Agents: #{Agent.count}"  
puts "  Conversations: #{Conversation.count}"
puts "  Messages: #{Message.count}"
