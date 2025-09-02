class CreateAgentInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :agent_interactions, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :agent, null: false, foreign_key: true, type: :uuid
      t.references :conversation, null: true, foreign_key: true, type: :uuid
      t.string :interaction_type, null: false
      t.json :input_data, default: {}
      t.json :output_data, default: {}
      t.float :response_time
      t.boolean :success, default: true, null: false
      t.text :error_message
      t.timestamps

      # Indexes for analytics queries
      t.index [:user_id, :agent_id, :created_at], name: 'idx_interactions_user_agent_created'
      t.index [:agent_id, :interaction_type, :created_at], name: 'idx_interactions_agent_type_created'
      t.index [:success, :created_at], name: 'idx_interactions_success_created'
      t.index :interaction_type
    end

    # Add constraints
    add_check_constraint :agent_interactions, "interaction_type IN ('chat', 'function_call', 'error', 'system')", name: 'interactions_type_check'
    add_check_constraint :agent_interactions, "response_time >= 0", name: 'interactions_response_time_positive'
  end
end
