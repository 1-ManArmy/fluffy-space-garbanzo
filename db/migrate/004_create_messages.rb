class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages, id: :uuid do |t|
      t.references :conversation, null: false, foreign_key: true, type: :uuid
      t.references :user, null: true, foreign_key: true, type: :uuid
      t.string :role, null: false
      t.text :content, null: false
      t.json :metadata, default: {}
      t.string :model_used
      t.integer :tokens_used, default: 0
      t.float :processing_time, default: 0.0
      t.timestamps

      # Indexes for performance
      t.index [:conversation_id, :created_at], name: 'idx_messages_conversation_created'
      t.index [:user_id, :created_at], name: 'idx_messages_user_created'
      t.index :role
      t.index :model_used
    end

    # Full-text search on content
    add_index :messages, :content, using: :gin, opclass: :gin_trgm_ops

    # Add constraints
    add_check_constraint :messages, "role IN ('user', 'assistant', 'system')", name: 'messages_role_check'
    add_check_constraint :messages, "tokens_used >= 0", name: 'messages_tokens_positive'
    add_check_constraint :messages, "processing_time >= 0", name: 'messages_processing_time_positive'
  end
end
