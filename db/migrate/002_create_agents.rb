class CreateAgents < ActiveRecord::Migration[7.1]
  def change
    create_table :agents, id: :uuid do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :agent_type, null: false
      t.text :description
      t.json :configuration, default: {}
      t.json :personality_traits, default: {}
      t.string :status, default: 'active', null: false
      t.string :subdomain, index: { unique: true }
      t.json :capabilities, default: []
      t.json :model_preferences, default: {}
      t.string :ai_model_endpoint
      t.string :fallback_model
      t.timestamps

      # Indexes for performance
      t.index :agent_type
      t.index :status
      t.index [:status, :agent_type]
    end

    # Add constraints
    add_check_constraint :agents, "status IN ('active', 'inactive', 'maintenance')", name: 'agents_status_check'
    add_check_constraint :agents, "agent_type IN ('chatbot', 'assistant', 'specialist', 'analyzer')", name: 'agents_type_check'
  end
end
